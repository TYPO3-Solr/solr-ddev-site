# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## MOST IMPORTANT RULE: Never lose a test case

A test case may only disappear when the production code it asserts is **removed**. When production
code is **moved** — refactored, renamed, split, relocated into another class — the test moves with
it and keeps asserting the same behaviour against the new API.

* **Integration tests must never be deleted.** They assert functionality, and functionality
  survives a refactoring. Point them at the new entry point instead.
* **Unit tests** assert concrete lines. They may go only together with the lines they cover. If
  those lines moved, the unit test moves too — rewritten against whatever now owns them.
* "Superseded by another test" is not a reason to drop a case. Move it, then let the redundancy be
  a separate, explicit decision.

## Project Overview

DDEV-based development environment for **Apache Solr for TYPO3** - an enterprise search integration extension. This is a monorepo containing the main EXT:solr extension and related add-ons (tika, solrconsole, solrfal, solrdebugtools, etc.).

**Tech Stack:** PHP 8.2, TYPO3 14.x (dev-main), Apache Solr, MySQL 8.0, DDEV

**Important:** No backwards compatibility with older TYPO3 versions is required. Code only needs to work with TYPO3 14.

## Essential Commands

### Running Tests (inside DDEV container)
```bash
# Unit tests
ddev composer tests:solr:unit
ddev composer tests:tika:unit
ddev composer tests:solrfal:unit
ddev composer tests:solrconsole:unit

# Integration tests
ddev composer tests:solr:integration
ddev composer tests:tika:integration
ddev composer tests:solrfal:integration
ddev composer tests:solrconsole:integration

# With PHPUnit arguments (extension name required as first param)
ddev composer tests:solr:integration -- --filter=IndexerTest
```

### Alternative DDEV commands
```bash
ddev solr:tests:unit [extension] [--filter=TestName]
ddev solr:tests:integration [extension] [--filter=TestName]
```

### Code Quality
```bash
# Static analysis (PHPStan level 6)
ddev composer tests:solr:phpstan
ddev composer tests:tika:phpstan
ddev composer tests:solrfal:phpstan

# Code refactoring with Rector
ddev composer tests:solr:rector-check    # Dry run
ddev composer tests:solr:rector          # Apply changes

# Code style fix (TYPO3 Coding Standards)
ddev composer t3:standards:fix
```

### Environment Management
```bash
ddev start                      # Start environment
ddev solr:clean:ddev-site       # Reset to initial state
ddev solr:enable <addon>        # Enable: tika, news, solrconsole, solrfal, solrdebugtools
```

## Architecture

### Tip: Reference Snapshot: TYPO3-13.4_and_EXT_solr_13.1_State

The folder `TYPO3-13.4_and_EXT_solr_13.1_State/` should contain a **working snapshot** of TYPO3 13.4 with EXT:solr 13.1.
Use this as a reference when making TYPO3 14 compatibility changes to:
- Compare how code worked before the upgrade
- Look up working TCA configurations, test fixtures, etc.
- Understand the previous behavior when fixing deprecations

**Hint:** All `composer tests:solr:*` commands are available inside this folder, so you can run tests there to verify the previous working state.

**Setup (if folder is empty):**
1. Clone the branch: `git clone -b release-13.1.x git@github.com:TYPO3-Solr/solr-ddev-site.git TYPO3-13.4_and_EXT_solr_13.1_State`
2. Change `name: solr-13.1` to `name: solr-13.1-ref` inside of `TYPO3-13.4_and_EXT_solr_13.1_State/.ddev/config.yaml`
3. Ask the developer to run `ddev start` on host in this directory (cannot be done from inside DDEV container)

### Multi-Repository Structure
The `packages/ext-*` folders are **separate git repositories** cloned into this development environment - not a monorepo. Each extension has its own repository at https://github.com/TYPO3-Solr/.

**Important:** All cloned repositories must be on matching branches (e.g., all on `main` or all on `release-13.1.x`).

- `packages/ext-solr/` - Main Apache Solr extension (namespace: `ApacheSolrForTypo3\Solr`)
- `packages/ext-tika/` - Apache Tika text extraction (`ApacheSolrForTypo3\Tika`)
- `packages/ext-solrfal/` - FAL integration (`ApacheSolrForTypo3\Solrfal`)
- `packages/ext-solrconsole/` - Query console tool (`ApacheSolrForTypo3\Solrconsole`)
- `packages/ext-solrdebugtools/` - Debugging utilities

Root `composer.json` references these via path repositories with version overrides for local development.

### TYPO3 Extension Structure (each package)
```
Classes/           # PSR-4 namespaced PHP code
Tests/Unit/        # PHPUnit unit tests
Tests/Integration/ # PHPUnit integration tests (uses TYPO3 Testing Framework)
Configuration/     # TypoScript, TCA, site sets
Resources/         # Templates, icons, language files
Documentation/     # ReST documentation
Build/Test/        # Test configs (UnitTests.xml, IntegrationTests.xml, phpstan.neon)
```

## TYPO3 Core API Reference

When working on `packages/ext-*` code, always look up how to use the TYPO3 Core API in:
- `vendor/typo3/cms-core/Documentation/` - Official documentation
- `vendor/typo3/cms-*/Classes/` - Core implementation examples
- `vendor/typo3/cms-*/Tests/` - Test examples for proper usage

**Troubleshooting workflow:**
1. First, look how it worked in TYPO3 13 (see `TYPO3-13.4_and_EXT_solr_13.1_State/`)
2. Then, look into TYPO3 Core API Reference resources above to understand the new TYPO3 14 way

## Code Standards

- **PHPStan Level 6** - Strict type checking enforced
- **TYPO3 Coding Standards v0.8.0** - PSR-2 based
- **Rector for TYPO3 14** - Automated code modernization
- **PHP 8.2** - Use strict types and modern features
- **Doc comments:** Never add `@param` or `@return` doc comments when parameter/return types are self-explanatory from the signature. Only add doc comments when additional context is needed (e.g., explaining what values are expected, side effects, or non-obvious behavior).
- **Comments:** Short but informative. If the code says it already, write no comment. When a comment is needed, explain *why*, not *what*, and keep it to one or two lines. Never restate the class or method name (`Class ItemRepository`).
- **Code identifiers in prose are always marked up.** Methods with their parentheses
  (`executePageIndexer()`), classes (`IndexingService`), fields, columns, settings, file paths,
  TypoScript and query fragments (`field:*`). Never leave them as bare words. How to mark them
  up depends on the format:
  - **Markdown and plain text** — commit messages, pull request descriptions, `.md` files,
    answers in chat: single backticks. This is existing house style; the last hundred commits on
    `main` carry over 250 backticked identifiers.
  - **ReST is stricter and wants a role, not plain literals.** Use `:php:` for PHP identifiers,
    classes, methods and namespaces, `:file:` for paths, `:bash:` for shell, `:code:` for
    anything else, and `:ref:` / `:doc:` for cross-references. Reach for ``double backticks``
    only where no role fits. `Documentation/Releases/solr-release-14-0.rst` is the reference —
    e.g. ``:php:`getTaskParameters()` ``. Note that file is not fully consistent: it also has
    class names in plain ``literals``, which are the older form, not the target.

## Debugging with Xdebug

Opt-in and off by default: `ddev dbgp-proxy on` loads Xdebug, enables DBGp routing and starts
the proxy; `off` reverts all three. Full setup in `Documentation/Xdebug-DBGp.md`.

Where Claude Code itself runs decides how to invoke this. Inside the web container `ddev` is
not on `PATH`; on a sandboxed host (macOS/Windows today, possibly Linux later) it is, and
`ddev` execs into the container. Detect with `command -v ddev` or `$IS_DDEV_PROJECT`.

```bash
ddev dbgp-proxy on                                        # from a host / sandbox
/var/www/html/.ddev/xdebug/dbgp-proxy on                  # from inside the web container
ddev xdebug-run -k claude vendor/bin/typo3 scheduler:run
/var/www/html/.ddev/xdebug/xdebug-run -k claude vendor/bin/typo3 scheduler:run
```

Running on a sandboxed host also puts the MCP server outside the container, which needs the
host-side `.mcp.json` variant — see the doc.

Rules that are not discoverable from the code:

* **Debug tests with plain `phpunit`, never `composer tests:solr:*`.** Composer's
  XdebugHandler restarts PHP *without* Xdebug, and the trigger additionally fires on
  `composer`, `paratest` and `phpunit-wrapper` — each opens a DBGp session that blocks
  waiting for commands, so the suite never reaches the test. Use
  `vendor/bin/phpunit -c packages/ext-solr/Build/Test/IntegrationTests.xml --filter <Test>`.
* **Always `detach` when finished.** After the last breakpoint the session sits at
  `stopping` and the PHP process stays blocked — a web request hangs until then.
* **Remove pending breakpoints.** They live in the MCP server, outlive the session and
  re-arm on the next connection. This is how a "phantom" hang gets reported days later.
* **Leave Xdebug off** (`dbgp-proxy off`) so the project default is restored.
* `get_variable` truncates strings (`"pages"` → `"pa"`); use `evaluate` for real values.
* `list_sessions` can report `starting` while already paused — trust the breakpoint's
  `hitCount`.
* **Web requests route by cookie, and the two destinations use different ones:**
  `XDEBUG_SESSION=claude` for the MCP, `XDEBUG_TRIGGER=PHPSTORM` for the IDE. A pill in the
  frontend and backend top bar switches them, so ask the developer to select `claude` there
  rather than to install a browser extension. `xdebug.idekey` is *not* a fallback: under
  `start_with_request = trigger` a request with neither cookie starts no session at all.
* **An empty proxy log is a diagnosis, not a dead end.** No `Start new server connection`
  means nothing triggered; `Could not find IDE connection` means the client never registered;
  `Init forwarded, start pipe` without a halt means a missing path mapping.
* **Indexing runs in one process.** `IndexingService` calls `FrontendApplication::handle()`
  in-process, so one CLI session traces the whole chain from the scheduler task through the
  frontend middleware stack: `xdebug-run -k claude vendor/bin/typo3 scheduler:run --task=2
  --force`. No cookie, no second session.
* **Coverage answers reachability, the debugger answers why.** Never step through code to
  find out whether it is dead — that samples one path per run. Use `xdebug.mode=coverage`
  over a production run and over the suite, and compare. Recipes for both, including call
  breakpoints, logpoints and step filters, are in `Documentation/Xdebug-DBGp.md`.

## Testing ELTS / old-PHP branches (e.g. release-11.2.x)

The shared DDEV web container defaults to PHP 8.2 for `main` (TYPO3 14). Old ELTS branches like
`packages/ext-solr`'s `release-11.2.x` need PHP 7.3/7.4 and a different `typo3/cms-core` line, in
the *same* checked-out working directory — there's no separate container per branch. Each such
branch carries its own `.envrc` (tracked, `direnv allow`-gated) that switches `php`/`composer` to
the right version via wrapper scripts under `Build/Helpers/php-compat-bin`, and exports the test
env vars that branch's suite needs; see the comments at the top of that file for the one-time host
setup (installing the old PHP CLI package, fixing MySQL auth). It no-ops if the old PHP isn't
installed, so switching back to `main` in the same directory is unaffected.

Rules that are not discoverable from the code:

* **The container already has Ondrej Sury's PHP apt repo configured**
  (`/etc/apt/sources.list.d/php.sources`), so installing e.g. `php7.3-cli` needs no new apt source
  — just `sudo apt-get install php7.3-cli php7.3-<extensions...>`. It installs alongside the
  default PHP under a versioned binary (`/usr/bin/php7.3`), untouched by `update-alternatives`.
* **The shared `db` DDEV service authenticates `root` with `caching_sha2_password`** (MySQL 8
  default), which old TYPO3's bundled `doctrine/dbal` mysqli driver cannot speak at all — it fails
  with "The server requested authentication method unknown to the client", not a credentials
  error. Fix once per environment: `ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY
  '<password>'; FLUSH PRIVILEGES;` (leave `root`@`localhost` alone; only the `%` grant handles TCP
  connections from other containers).
* **Composer refuses to resolve old `typo3/cms-core`/`nimut/testing-framework` constraints by
  default**, treating packages with any known security advisory as blocked during dependency
  resolution (not just audit-reported) — `Root composer.json requires typo3/cms-core ^10.4 ...
  affected by security advisories`. Set `COMPOSER_NO_AUDIT=1` and `COMPOSER_NO_BLOCKING=1` before
  `composer tests:setup`; there's no fix forthcoming for an EOL line.
* **nimut/testing-framework reads different env vars than the ones `composer tests:setup` itself
  uses**: lowercase `typo3DatabaseName`/`typo3DatabaseHost`/`typo3DatabaseUsername`/
  `typo3DatabasePassword`, plus `TESTING_SOLR_HOST`/`TESTING_SOLR_PORT` — distinct from the
  uppercase `TYPO3_DATABASE_*` vars. Both sets need exporting; see
  [`TYPO3-Solr/solr-ddev-site`'s `release-11.2.x` `.ddev/docker-compose.env.yaml`](https://github.com/TYPO3-Solr/solr-ddev-site/blob/release-11.2.x/.ddev/docker-compose.env.yaml)
  for the canonical values.
* **A stale test-system marker silently skips database creation.** nimut caches a
  `last_run.txt` under `.Build/Web/typo3temp/var/tests/functional-<hash>/` and reuses that test
  database for 300 seconds without recreating it. If an earlier run failed before the database was
  actually created (e.g. while still fixing DB auth), later runs fail with `Unknown database
  'db_tests_<hash>'` instead of creating it fresh. Fix: `rm -rf .Build/Web/typo3temp/var/tests`.
* **Integration test fixtures resolve relative to the *test class's own* directory**, not a shared
  fixtures pool: `Tests/Integration/Foo/SomeTest.php` only finds
  `Tests/Integration/Foo/Fixtures/*.xml`. Reusing a fixture from another test's directory means
  copying the file, not just referencing it by name.
* **ELTS work tends to accumulate extra remotes** — a contributor's own fork(s), possibly a
  separate ELTS-only sibling repository alongside the regular `origin`/`upstream` pair — and the
  same branch name can exist on several of them with *different* commits. Check which remote a
  branch actually needs to come from before checking it out. This is exactly the scenario the
  ext-solr `CLAUDE.md`'s "MOST IMPORTANT GIT RULE" guards against: `git checkout -b <local>
  <remote>/<branch>` leaves `<local>` tracking that remote, so an unqualified `git push` later can
  silently push to the wrong fork — repoint tracking to `origin` immediately after creating the
  branch, per that rule.

## Commit Quality Requirements

**MANDATORY: Every change-set MUST pass ALL checks before committing.**

### 1. PHPStan (MUST succeed)
```bash
composer tests:solr:phpstan
```

### 2. Unit Tests (MUST succeed)
```bash
composer tests:solr:unit
```
- **Coverage rule:** Each line in newly added methods within `Classes/` must be covered by unit tests
- **Exception:** If too much mocking is required, provide integration tests instead

### 3. Coding Standards (MUST be followed)
```bash
# Check CS (dry-run)
composer t3:standards:fix -- packages/ext-solr --diff --verbose --dry-run --show-progress=none

# Fix CS issues
composer t3:standards:fix -- packages/ext-solr --show-progress=none
```

### 4. Integration Tests (MUST succeed for affected areas)
```bash
# Run tests for associated/affected classes
composer tests:solr:integration -- --filter=<AssociatedClassName>
```

### Verification Workflow
Before any commit, run in this order:
1. `composer tests:solr:phpstan`
2. `composer tests:solr:unit`
3. `composer t3:standards:fix -- packages/ext-solr --show-progress=none`
4. `composer tests:solr:integration -- --filter=<AffectedClass>`

## Git Conventions

**Important:** Never ask to push commits - the developer will always push manually.

Commit message prefixes:
- `[BUGFIX]` - Bug fixes
- `[TASK]` - General tasks/improvements
- `[FEATURE]` - New features
- `[DOCS]` - Documentation changes

Commit messages are short but informative: a subject line, and a body only when the *why*
is not obvious from the diff. Do not narrate the diff or pad with context the reader has.

Branch strategy:
- `main` - Latest development
- `release-X.X.x` - Release maintenance branches

### MOST IMPORTANT GIT RULE: never leave a working branch tracking `upstream`

`git checkout -b <local> upstream/<remote>` silently sets `branch.<local>.remote = upstream` and
`branch.<local>.merge = refs/heads/<remote>`. A bare `git push` then writes to the **canonical
TYPO3-Solr repository**, under the *remote* branch's name — so a `--force` on a local topic branch
force-pushes a published release branch. This has already come within seconds of destroying
`release-12.1.x`, and an earlier instance of it rewrote a released `14.0.0` tag and stranded
Packagist on an unreachable commit.

**Immediately after creating a branch from `upstream/*`, repoint it at `origin` under its own
name:**

```bash
git checkout -b epic/my_work upstream/release-12.1.x
git config branch.epic/my_work.remote origin
git config branch.epic/my_work.merge refs/heads/epic/my_work
```

Use `git config` rather than `git branch --set-upstream-to=origin/<name>`, which fails while the
branch does not exist on `origin` yet. Verify before any push:

```bash
git config --get branch.$(git symbolic-ref --short HEAD).remote   # must print: origin
```

Rules that follow from this:

* **`upstream` is push-by-explicit-name only.** Never `git push` relying on tracking; write
  `git push origin HEAD` or `git push upstream <src>:<dst>` so the destination is visible in the
  command.
* **Never force-push a `release-X.X.x` branch, `main`, or a tag on `upstream`** without the
  developer confirming that exact command. Releases are immutable once published, and Packagist
  will not re-point a moved tag.
* `main` currently tracks `upstream` in every `packages/ext-*` repository. Treat any checkout of
  `main` as read-only unless the developer says otherwise.

## URLs (after `ddev start`)

- Frontend: https://solr-ddev-site.ddev.site/
- Backend: https://solr-ddev-site.ddev.site/typo3/ (admin / Password1!)
