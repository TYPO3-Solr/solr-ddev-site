# Xdebug: PHPStorm and Claude Code in parallel

Two debug clients share one Xdebug through a **DBGp proxy** running inside the web
container. Each client registers an *idekey*; every request names the idekey it wants, and
the proxy hands the session to that client. PHPStorm is the default.

```
                                  ┌──────────── PHPStorm (host)     idekey PHPSTORM
PHP + Xdebug ──► dbgpProxy ───────┤            registers via published 127.0.0.1:9140
127.0.0.1:9003   -s 127.0.0.1:9003│
(container)      -i 0.0.0.0:9140  └──────────── xdebug-mcp (container) idekey claude
                 (container)                    registers via 127.0.0.1:9140
```

**All of this is opt-in.** Nothing here changes how the project behaves until you run
`ddev dbgp-proxy on`. Until then Xdebug is exactly what DDEV ships: `ddev xdebug on`
connects straight to your IDE on `host.docker.internal:9003`, no proxy in the path. If you
have no interest in the fan-out, stop reading — the stock workflow is untouched.

The switch is a PHP module, `xdebug_dbgp_proxy`, installed into
`/etc/php/*/mods-available/` and toggled with `phpenmod`/`phpdismod`. Its `; priority=90`
makes it load after `20-xdebug.ini`, so its overrides win while enabled and vanish
completely while disabled.

```bash
ddev dbgp-proxy on       # enable routing + start the proxy
ddev dbgp-proxy off      # back to stock DDEV
ddev dbgp-proxy status   # what is on, plus the values for PHPStorm
```

**Xdebug is disabled by default** — an always-loaded Xdebug slows every unrelated PHP
process down. `on` loads it and `off` unloads it, so the default state comes back the moment
you are done. `ddev xdebug on|off` keeps its stock DDEV meaning and remains what you want
when you need Xdebug *without* the routing — code coverage, for instance.

On top of that, `xdebug.start_with_request = trigger` (from the module) means that even
while Xdebug is loaded, a process only connects when it explicitly asks — so a forgotten
breakpoint can never stall a parallel test run or somebody else's request.

None of these commands need `sudo`: DDEV makes `/etc/php/*/{conf.d,mods-available}`
world-writable and runs PHP-FPM as the container user, so `phpenmod` and the FPM reload work
unprivileged.

## PHPStorm settings

**Settings → PHP → Debug → DBGp Proxy**

| Field   | Value                                    |
|---------|------------------------------------------|
| IDE key | `PHPSTORM`                               |
| Host    | `127.0.0.1`                              |
| Port    | `9140` on `main` — see the table below   |

`ddev dbgp-proxy status` prints these, so you never have to work them out.

### The port encodes the release line

`.ddev/docker-compose.dbgp.yaml` publishes the port on `127.0.0.1`, so the Host never
changes. To let several solr-ddev-site instances run at once, the port carries the release
line — `9` + major + minor, matching `extra.branch-alias` in
`packages/ext-solr/composer.json`:

| branch           | version | port   |
|------------------|---------|--------|
| `main`           | 14.0    | `9140` |
| `release-13.1.x` | 13.1    | `9131` |
| `release-12.1.x` | 12.1    | `9121` |

That file is the **single source of truth** — `.ddev/xdebug/dbgp-proxy` reads the port back
out of it, so the published port and the port the proxy listens on cannot drift apart. Host
port and container port are deliberately identical, which is what makes `DBGP_PROXY_PORT`
the same value whether `xdebug-mcp` runs in the container or on the host.

These sit below both ephemeral ranges (Linux `32768-60999`, macOS `49152-65535`), so the OS
will never claim one for an outgoing connection. `/etc/services` has nothing in 91xx beyond
`bacula` on 9101-9103. Be aware that `9121` is also the community default for Prometheus
`redis_exporter`, and 9131 is used by some exporters too — only relevant if you run those
locally. Check with `ss -lntu | grep -E ':(9121|9131|9140)\b'` (Linux) or
`lsof -nP -iTCP:9140 -sTCP:LISTEN` (macOS).

Bound to loopback deliberately: whoever reaches this port gets full debug control of the
container. Traefik/`HTTP_EXPOSE` is not an alternative — DBGp is raw TCP with no `Host`
header and no TLS SNI, so the router has nothing to match on.

Deleting the compose file falls back to the proxy's own default `9001`, unpublished and
reachable only on the container's bridge IP — which changes on every container recreation.
`ddev dbgp-proxy status` prints whichever applies.

**Settings → PHP → Debug → Xdebug**

| Field      | Value              |
|------------|--------------------|
| Debug port | `9003` (unchanged) |

The two `9003`s do not collide: PHPStorm's is on the host, the proxy's engine-side
listener is inside the container, and neither is published.

Then, once per PHPStorm session: **Tools → DBGp Proxy → Register IDE**, and switch on
*Start Listening for PHP Debug Connections*. Registering is the step that is easy to
forget — without it the proxy has no `PHPSTORM` client and your sessions go nowhere.
Confirm it arrived with `tail /tmp/dbgp-proxy.log`, which logs every `proxyinit`.

### Path mappings

Xdebug reports absolute container paths (`file:///var/www/html/...`) and has no mapping
setting of its own — translating them is the client's job, so PHPStorm needs its own
mapping under **Settings → PHP → Servers** with *Use path mappings* ticked:

```
<your local project root>  →  /var/www/html
```

PHPStorm normally offers a *Configure path mappings* button on the first delivered session,
and the **DDEV Integration** plugin sets it up for you. Without the mapping the session is
still delivered — it just runs straight through without stopping, which looks identical to
"debugging is broken". The two failures are distinguishable in the proxy log: no mapping
still logs `IDE connected` / `Init forwarded`, whereas an unregistered IDE logs
`Could not find IDE connection for IDE Key`.

`xdebug-mcp` needs no mapping because it runs inside the container, where those paths are
real. It would need `PATH_MAPPINGS` only if it ran on the host — the macOS case.

## Setup

```bash
ddev dbgp-proxy on
```

That is the whole thing. It installs and enables the `xdebug_dbgp_proxy` module, loads
Xdebug, reloads PHP-FPM, starts the proxy and prints the values to paste into PHPStorm. It is
idempotent, so simply re-run it after a `ddev restart`. Both binaries come from the image, so
it needs no network and cannot be broken by xdebug.org being down.

One `ddev restart` is needed the first time, so Docker picks up the published port from
`.ddev/docker-compose.dbgp.yaml` — publishing a port is a start-time operation. Everything
else works without one.

To have the proxy come up automatically instead, create `.ddev/config.dbgp.yaml`:

```yaml
web_extra_daemons:
  - name: dbgp-proxy
    command: "/var/www/html/.ddev/xdebug/dbgp-proxy daemon"
    directory: /var/www/html
```

That needs one `ddev restart` to take effect, and it starts the proxy for everyone using the
project — which is why it is not shipped enabled.

Because `/etc/php` lives in the container image, the module has to be reinstalled after a
rebuild — `on` does that every time, so it is never a separate step.

## Enabling the MCP server (per developer, deliberately not by default)

`.mcp.json` only *declares* the server. It is **not** pre-approved in any tracked settings
file, so nobody gets an Xdebug debugger they never asked for. Claude Code asks before using
a project-scoped MCP server; to enable it permanently, put this in your own untracked
settings (`~/.claude/settings.json`):

```json
{ "enabledMcpjsonServers": ["xdebug"] }
```

`.claude/settings.local.json` works equally well and is gitignored, so it stays yours.

The caution is warranted rather than ceremonial. An MCP debug session pauses the PHP process
and holds it until `detach`, and a breakpoint left registered arms again on the next
connection. To someone unaware the setup is active, that presents as the application or the
test suite hanging for no reason, with nothing in any application log — a phantom bug that
costs real time to chase. Two independent opt-ins are therefore required: `ddev dbgp-proxy
on` for the routing, and approving the MCP server for the client.

### Registration with the proxy

`xdebug-mcp` registers itself with the proxy only when it *starts*, so any later proxy
restart leaves it unreachable — sessions for its idekey get `Could not find IDE connection`,
with nothing in the editor to explain it. `dbgp-proxy on` therefore registers it too, reading
the port and idekey from `.mcp.json` so the listener and the forwarding address cannot drift.
For the reverse order, when the MCP server starts after the proxy is already up:

```bash
ddev dbgp-proxy register-mcp
```

It is skipped, with a message, when nothing is listening on the MCP's port. Registering an
address nothing answers on is worse than not registering: the proxy accepts the session and
forwards it into a black hole, so PHP blocks instead of failing fast.

Re-registration is also the recovery when a session **aborts** — a request cancelled while
the proxy has it piped to the MCP produces `Protocol error … EOF` and takes that idekey's
registration down with it. Nothing needs restarting; `register-mcp` is enough.

Unlike the MCP, PHPStorm has to be re-registered by hand after a proxy restart, through
**Tools → DBGp Proxy → Register IDE**. There is no way to do that from outside the IDE.

## Updating the tooling

Both binaries are baked into the web image by `.ddev/web-build/Dockerfile.xdebug-dbgp`
rather than fetched at runtime. Neither npm's global prefix
(`/usr/local/n/lib/node_modules`) nor `/usr/local/bin` is on a volume, so a rebuild would
wipe them; and fetching on demand made `ddev dbgp-proxy on` depend on the network.

**`xdebug-mcp` is pinned:**

```bash
# 1. bump the pin in .ddev/web-build/Dockerfile.xdebug-dbgp
#      ARG XDEBUG_MCP_VERSION=1.4.0
# 2. rebuild the web image
ddev utility rebuild -s web
# 3. confirm what actually landed
ddev dbgp-proxy status        # -> "mcp:     xdebug-mcp 1.4.0"
```

Until the rebuild happens, `status` names the mismatch rather than letting it pass
unnoticed:

```
mcp:     1.3.0 (pinned 1.4.0) — run 'ddev utility rebuild -s web'
```

Pinned deliberately: `xdebug-mcp` receives full debug control of the container, and this
setup depends on 1.3.x behaviour — the `DBGP_PROXY_*` registration variables, and the hard
rejection of `XDEBUG_SOCKET_PATH` when proxy mode is active.

**`dbgpProxy` cannot be pinned.** xdebug.org publishes only an unversioned binary
(`dbgpProxy-0.6.2` is a 404) and the project exposes no releases API, so the version is
whatever was current when the image was built. That is still an improvement on fetching it
once per developer and keeping it forever: it is now fixed for the image's lifetime and
identical for everyone on the same build. `status` reports it, so an upstream change is
visible:

```
binary:  /usr/local/bin/dbgpProxy (dbgpProxy 0.6.2)
```

The Dockerfile runs `dbgpProxy -v` as the last build step, so a truncated download or an
HTML error page fails the build rather than surfacing at first use.

## Daily use

Arm Xdebug, then name the idekey you want. `ddev xdebug-run` does both and switches Xdebug
back off afterward if it turned it on:

```bash
# to PHPStorm (default)
ddev xdebug-run vendor/bin/typo3 scheduler:run

# to Claude Code
ddev xdebug-run -k claude vendor/bin/typo3 solr:index
```

Where Claude Code runs decides the invocation. On a sandboxed host (macOS/Windows today,
possibly Linux later) `ddev` is available and the commands above work as written. When Claude
Code runs *inside* the web container — the current Linux arrangement, since there is no
sandbox for it there — `ddev` is not on `PATH`, so it calls the script by path:

```bash
/var/www/html/.ddev/xdebug/xdebug-run -k claude vendor/bin/typo3 scheduler:run
```

`command -v ddev` or `$IS_DDEV_PROJECT` distinguishes the two.

For web requests the destination is carried by a cookie, and a widget in the page sets it —
see [Browser: the session switch](#browser-the-session-switch). By hand, or from a script:

```bash
ddev xdebug on
curl -k -b 'XDEBUG_SESSION=claude'    https://solr-ddev-site.ddev.site/   # to Claude Code
curl -k -b 'XDEBUG_TRIGGER=PHPSTORM'  https://solr-ddev-site.ddev.site/   # to PHPStorm
ddev xdebug off
```

Doing it by hand instead of via `xdebug-run`:

```bash
ddev xdebug on
ddev exec XDEBUG_SESSION=claude vendor/bin/typo3 solr:index
ddev xdebug off
```

## Browser: the session switch

Both the frontend and the backend carry a small pill in the middle of the top bar showing
where the next request will halt, and one click switches it:

```
xdebug → PHPSTORM      blue dot, the default
xdebug → claude        amber dot
```

That replaces the *Xdebug helper* browser extension, so any browser works and there is no
per-browser IDE-key setting to keep in sync. It is plain JavaScript that only touches
`document.cookie` — it never issues a request, because a request under the wrong destination
would open a DBGp session that blocks PHP until someone detaches. It renders only on
`*.ddev.site`, `localhost` and `127.0.0.1`.

The two destinations use different cookies, which is not cosmetic:

| destination | `XDEBUG_TRIGGER` | `XDEBUG_SESSION` |
|-------------|------------------|------------------|
| `PHPSTORM`  | `PHPSTORM`       | deleted          |
| `claude`    | deleted          | `claude`         |

Exactly one is ever set, so the proxy can never see a contradictory pair. `XDEBUG_SESSION` is
left to PHPStorm's own bookmarklet when PHPStorm is selected. Both act as a trigger, and in
both cases the cookie *value* becomes the idekey the proxy routes on.

**When both are present, `XDEBUG_TRIGGER` wins** — verified by sending both at once and
reading which idekey the proxy resolved. The widget reads state in that same order, so the
pill can never name a destination other than the one PHP will dial. A stray pair is worth
looking for if a breakpoint seems dead: a cookie can only be deleted through the exact path it
was set on, so a copy on `/typo3/` — from the Xdebug helper extension, or from before the
scheme changed — survives a `path=/` delete and is still sent to PHP. The widget sweeps the
whole path hierarchy for this reason. Disable that browser extension; it writes the same two
cookies and the two will fight.

**`xdebug.idekey` is not a fallback.** Under `start_with_request = trigger` a request with no
cookie at all starts no session — so "no cookie means PHPStorm" cannot work, and the widget
writes its default cookie on first load rather than only on click. Otherwise the pill would
claim a destination that was not armed, which reads exactly like a broken breakpoint.

While a destination is armed, *every* request carries the trigger, including the backend's
own AJAX polling. Run `dbgp-proxy off` when you are done rather than leaving it armed.

## Debugging tests

Run PHPUnit **directly**, not through `composer tests:solr:*`:

```bash
.ddev/xdebug/dbgp-proxy on
XDEBUG_SESSION=claude vendor/bin/phpunit \
  -c packages/ext-solr/Build/Test/IntegrationTests.xml --filter PagesRepositoryTest
.ddev/xdebug/dbgp-proxy off
```

Two reasons, both observed rather than assumed:

- `composer` runs its own XdebugHandler, which **restarts PHP without Xdebug**
  (`php -n -c /tmp/…`), so breakpoints never arm.
- The trigger applies to *every* PHP process in the chain — `composer`, `paratest` and
  `phpunit-wrapper` each open their own DBGp session and each blocks waiting for debugger
  commands, so the suite never reaches the test. Plain `phpunit` is one process, one
  session.

Things that cost time if you do not know them:

- **Detach when done.** After the last breakpoint the session sits at `stopping` and the
  PHP process stays blocked until `detach`; only then does the test finish.
- **Pending breakpoints outlive the session.** They stay registered in the MCP server and
  arm again on the next connection — remove them explicitly.
- **`get_variable` truncates strings** (`"Products"` arrives as `"Pro"`). Use `evaluate`
  for the real value; that path is not truncated. `MAX_DATA` in `.mcp.json` is the knob.
- `list_sessions` can report `starting` while the session is already paused at a
  breakpoint. Trust the breakpoint's `hitCount` instead.

## If the proxy is down

Xdebug dials the proxy, so with the proxy stopped nothing debugs. Claude Code has a
proxy-free path, because `xdebug-mcp` keeps its own listener on `9004`
(`DBGP_PROXY_ALLOW_FALLBACK=true` means a failed registration does not stop it):

```bash
XDEBUG_TRIGGER=1 XDEBUG_CONFIG="client_host=127.0.0.1 client_port=9004" \
  vendor/bin/typo3 scheduler:run
```

For PHPStorm the escape hatch is simply `ddev dbgp-proxy off`, which restores the stock
DDEV path straight to `host.docker.internal:9003` with no proxy involved. Browser-triggered
routing to Claude Code stops working in that mode, because a browser can only set a cookie,
and without a proxy the cookie cannot change the target.

## Files

| Path                                    | Role                                                                                                                                                         |
|-----------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `.ddev/xdebug/xdebug_dbgp_proxy.ini`    | the opt-in switch: trigger-only, target = in-container proxy, default idekey. Installed to `/etc/php/*/mods-available/`, toggled with `phpenmod`/`phpdismod` |
| `.ddev/php/30-xdebug_code_coverage.ini` | `xdebug.mode` — always loaded, so keep `coverage` for PHPUnit                                                                                                |
| `.ddev/commands/web/dbgp-proxy`         | `ddev dbgp-proxy` wrapper                                                                                                                                    |
| `.ddev/commands/web/xdebug-run`         | `ddev xdebug-run` wrapper                                                                                                                                    |
| `.ddev/docker-compose.dbgp.yaml`        | publishes `127.0.0.1:<port>` and **defines the port** for this release branch                                                                                |
| `.ddev/xdebug/dbgp-proxy`               | routing toggle + proxy lifecycle (`on`/`off`/`status`/`install`/`start`/`stop`/`daemon`/`register-mcp`)                                                      |
| `.ddev/xdebug/xdebug-run`               | arm Xdebug, run one command with an idekey, disarm                                                                                                           |
| `.mcp.json`                             | *declares* the `xdebug-mcp` server (listener + registration as idekey `claude`); not enabled until a developer opts in                                        |
| `.ddev/web-build/Dockerfile.xdebug-dbgp` | bakes `xdebug-mcp` (pinned) and `dbgpProxy` into the web image                                                                                               |

The browser session switch lives in the sitepackage, because it has to be delivered by TYPO3:

| Path                                                                                | Role                                                            |
|-------------------------------------------------------------------------------------|-----------------------------------------------------------------|
| `Resources/Public/JavaScript/XdebugSessionSwitch.js`                                 | the widget; one file serves both frontend and backend           |
| `Configuration/Sets/Solr/setup.typoscript`                                            | frontend delivery via `page.includeJSFooter`                     |
| `Classes/Backend/AddXdebugSessionSwitch.php`                                          | backend delivery: listener on `BeforeBackendPageRenderEvent`     |
| `Configuration/JavaScriptModules.php`                                                 | importmap prefix so the backend can resolve the module           |

Paths are relative to `packages/apache_solr_for_typo3_sitepackage/`. The file has no imports
or exports, which makes it simultaneously a valid classic script and a valid ES module — the
frontend loads it as the former, the backend importmap as the latter.

## Troubleshooting

```bash
ddev dbgp-proxy status
ddev exec ss -lntp | grep -E ':(9140|9003|9004)'   # proxy + mcp listeners
tail -f /tmp/dbgp-proxy.log                        # registrations and forwards
```

The proxy log separates the three ways this fails, which look identical in the editor:

| log line | cause |
|---|---|
| *no `Start new server connection` at all* | nothing triggered the session: no cookie, or Xdebug not loaded. Check `dbgp-proxy status` and the pill |
| `Could not find IDE connection for IDE Key '…'` | that client is not registered. PHPStorm: **Register IDE**. Claude Code: `ddev dbgp-proxy register-mcp` |
| `IDE connected` → `Init forwarded, start pipe` | delivered; if it still does not halt, the path mapping is missing |

Read that first row as a distinct diagnosis, not as absence of evidence. Registrations
(`proxyinit`) appear in the log whether or not any request follows, so a log holding a fresh
registration and no `server` connection says the IDE side is fine and PHP never dialed out.

To see what Xdebug itself decides, add these two lines to
`.ddev/xdebug/xdebug_dbgp_proxy.ini` and re-run `ddev dbgp-proxy on` — it reinstalls the
module and reloads PHP-FPM, so no restart is needed:

```ini
xdebug.log = /tmp/xdebug.log
xdebug.log_level = 10
```

Create the file first with `install -m 0666 /dev/null /tmp/xdebug.log`; it has to be
writable by the PHP user, or Xdebug silently reports `could not be opened`.

## macOS host

Untested, but the published port is what makes it viable rather than a special case. Docker
Desktop cannot route to container IPs, which is exactly the hop publishing removes: PHPStorm
and a host-side `xdebug-mcp` both reach the proxy at `127.0.0.1:9140`, and the proxy dials
back out to the host using the peer address from each registration — a direction Docker
Desktop does support. The PHPStorm settings are therefore identical to Linux.

Two deltas remain, both in `.mcp.json`, because Claude Code is sandboxed on macOS and so
`xdebug-mcp` runs on the host rather than in the container:

- `command` needs a host-side invocation instead of the in-container `xdebug-mcp`.
- `XDEBUG_HOST` must be `0.0.0.0` rather than `127.0.0.1`, so the listener accepts the
  proxy's call-back from the Docker gateway instead of only loopback.

`DBGP_PROXY_HOST`, `DBGP_PROXY_PORT` and `DBGP_IDEKEY` are unchanged — that is the payoff of
publishing host port and container port as the same number.
