# DDEV Development Environment for Apache Solr for TYPO3

DDEV-based development setup for contributing to **EXT:solr** and related Apache Solr extensions for TYPO3 CMS.

## Prerequisites

- Recent [Git](https://git-scm.com/downloads)
- Recent [Docker](https://docs.ddev.com/en/stable/users/install/docker-installation/)
- Recent [DDEV](https://docs.ddev.com/en/stable/users/install/ddev-installation/)
- An IDE with PHP and/or TYPO3 support — e.g. [PhpStorm](https://www.jetbrains.com/phpstorm/), [VS Code](https://code.visualstudio.com/) with the PHP extension, or similar

> Estimated setup time if prerequisites are missing: **~30 min**.

## Quick Start

```bash
ddev start
```

> Estimated first-time startup: **~5 min** (image build + composer install).

Once started, run `ddev describe` to see the project URLs:

- **TYPO3 Frontend**: the listed `https://<project-name>.ddev.site` URL
- **TYPO3 Backend**: `https://<project-name>.ddev.site/typo3/`

> The DDEV project name differs per branch (e.g. `solr-ddev-site` on `main`, `solr-13.1` on `release-13.1.x`). `ddev describe` is the source of truth for the actual URLs.

Backend credentials: `admin` / `Password1!`

To reset to a clean database state:

```bash
ddev solr:clean:ddev-site
```

## Running Tests

All test suites used by EXT:solr* GitHub Actions can be run locally inside the DDEV web container via `ddev composer tests:solr:<type>`.

> **Note:** If using `ddev ssh`, make sure you are in `/var/www/html` before running `composer tests:*` commands.

```bash
# Coding standards
ddev composer t3:standards:fix -- packages/ext-solr

# Static analysis
ddev composer tests:solr:phpstan

# Unit tests
ddev composer tests:solr:unit

# Integration tests
ddev composer tests:solr:integration

# Pass PHPUnit arguments with --
ddev composer tests:solr:integration -- --filter=IndexerTest
```

<details>
<summary>Tests for other EXT:solr* extensions (tika, solrfal, solrconsole)</summary>

```bash
# Coding standards for EXT:solr add-on
ddev composer t3:standards:fix -- packages/ext-<add-on>

# EXT:tika
ddev composer tests:tika:phpstan
ddev composer tests:tika:unit
ddev composer tests:tika:integration

# EXT:solrfal
ddev composer tests:solrfal:phpstan
ddev composer tests:solrfal:unit
ddev composer tests:solrfal:integration

# EXT:solrconsole
ddev composer tests:solrconsole:phpstan
ddev composer tests:solrconsole:unit
ddev composer tests:solrconsole:integration
```

</details>

See [DDEV Commands Reference](.ddev/commands/web/README.md) for additional `ddev solr:tests:*` shorthand commands.

## Debugging with Xdebug

By default, Xdebug behaves exactly as DDEV ships it — `ddev xdebug on` connects straight to
your IDE and nothing below applies.

Opting in with `ddev dbgp-proxy on` lets PHPStorm and Claude Code debug side by side: a
DBGp proxy inside the web container routes each session by *idekey*. It loads Xdebug for
you; `ddev dbgp-proxy off` unloads it again and reverts to stock. `ddev xdebug on|off` keeps
its normal DDEV meaning for when you need Xdebug without the routing, such as coverage runs.

**PHPStorm → Settings → PHP → Debug → DBGp Proxy**

| IDE key    | Host        | Port             |
|------------|-------------|------------------|
| `PHPSTORM` | `127.0.0.1` | `9140` on `main` |

Leave *Debug port* at `9003`, then use **Tools → DBGp Proxy → Register IDE**.
`ddev dbgp-proxy status` prints these values.

The port encodes the release line — `9` + major + minor, matching `extra.branch-alias` in
`packages/ext-solr/composer.json`: `main` → `9140`, `release-13.1.x` → `9131`,
`release-12.1.x` → `9121`. So several instances can run side by side, each on `127.0.0.1`.

```bash
ddev dbgp-proxy on                                    # enable; prints the Host for PHPStorm
ddev xdebug-run vendor/bin/typo3 scheduler:run        # debug in PHPStorm
ddev xdebug-run -k claude vendor/bin/typo3 solr:index # debug in Claude Code
ddev dbgp-proxy off                                   # back to stock DDEV
```

For requests from a browser, a pill in the middle of the frontend and backend top bar shows
where the next one will halt and switches it with one click — `xdebug → PHPSTORM` or
`xdebug → claude`. No browser extension needed, in any browser.

See [Xdebug & DBGp](Documentation/Xdebug-DBGp.md) for the full setup, the cookies behind that
pill, path mappings, fallbacks and troubleshooting.

## Contributing to EXT:solr

`ddev start` automatically clones the `packages/ext-solr` (and related) repositories. However, as a contributor you are responsible for:

- **Forking** `https://github.com/TYPO3-Solr/ext-solr` on GitHub
- **Adding your fork as remote** inside `packages/ext-solr/`:
  ```bash
  cd packages/ext-solr && git remote add origin git@github.com:<your-username>/ext-solr.git
  cd ../../
  ```
  `ddev clone` already sets `https://github.com/TYPO3-Solr/ext-solr` as `upstream` automatically.
- **Switching to the correct branch** before starting work
- **Pushing your changes** to your fork (`origin`) and opening a pull request against `upstream`

Each `packages/ext-*` directory is an independent Git repository — commits, remotes, and branches are managed separately from this `solr-ddev-site` repo.

> **Please note:** EXT:solr* git repositories use a linear history, so please do not use `git merge` commands but always `git rebase` to integrate upstream changes into your branch.

### Backports & parallel release branches

Always start your work on the `main` branch — maintainers will backport merged PRs to active release branches by default.

If a maintainer asks you to do the backport yourself, check out `solr-ddev-site` on the matching release branch (e.g. `release-13.1.x`) into a **separate directory** as an **independent DDEV project**. Each release branch already ships with its own unique `name:` in `.ddev/config.yaml` (e.g. `solr-13.1`), so the projects run side-by-side without conflict. Example layout used by maintainers:

```
~/PhpstormProjects/solr-ddev-site.main    # name: solr-ddev-site  (from main branch)
~/PhpstormProjects/solr-ddev-site.13.1    # name: solr-13.1       (from release-13.1.x branch)
~/PhpstormProjects/solr-ddev-site.12.1    # name: solr-12.1       (from release-12.1.x branch)
```

This allows testing ported features across multiple EXT:solr major releases simultaneously.

### Keep solr-ddev-site up to date

This environment evolves alongside EXT:solr. Pull upstream changes regularly to get the latest DDEV configuration, test helpers, and dependency updates:

```bash
git pull --rebase upstream main
cd packages/ext-solr && git pull --rebase upstream main
cd ../../
ddev start
```

## Getting Help

- **TYPO3 Slack** [`#ext-solr`](https://typo3.slack.com/) — community channel for EXT:solr questions and discussions.
  Get an invitation via the [TYPO3 Slack sign-up](https://my.typo3.org/about-mytypo3org/slack/)
- **GitHub Issues** — [bug reports & feature requests for this DDEV environment](https://github.com/TYPO3-Solr/solr-ddev-site/issues)
  EXT:solr issues belong in [the respective extension repo](https://github.com/TYPO3-Solr/)

## Further Documentation


- [Project Structure & Docker Services](Documentation/ProjectStructure.md) — folder layout and container overview
- [EXT:solr Backend Modules](Documentation/BackendModules.md) — overview of the modules EXT:solr adds to the TYPO3 backend
- [Addons & Demo Features](Documentation/Addons.md) — enable optional EXT:solr extensions
- [Workshops — Participant Guide](Documentation/Workshops.md) — preparation guide for EXT:solr training & workshop attendees
- [Claude Code Integration](Documentation/Claude-Code.md) — AI-assisted development setup
- [Xdebug & DBGp](Documentation/Xdebug-DBGp.md) — opt-in step debugging for PHPStorm and Claude Code in parallel
- [DDEV Commands Reference](.ddev/commands/web/README.md) — all available `ddev solr:*` commands
