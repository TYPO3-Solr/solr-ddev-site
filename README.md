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
  Get an invite via the [TYPO3 Slack sign-up](https://my.typo3.org/about-mytypo3org/slack/)
- **GitHub Issues** — [bug reports & feature requests for this DDEV environment](https://github.com/TYPO3-Solr/solr-ddev-site/issues)
  EXT:solr issues belong in [the respective extension repo](https://github.com/TYPO3-Solr/)

## Further Documentation


- [Project Structure & Docker Services](Documentation/ProjectStructure.md) — folder layout and container overview
- [EXT:solr Backend Modules](Documentation/BackendModules.md) — overview of the modules EXT:solr adds to the TYPO3 backend
- [Addons & Demo Features](Documentation/Addons.md) — enable optional EXT:solr extensions
- [Workshops — Participant Guide](Documentation/Workshops.md) — preparation guide for EXT:solr training & workshop attendees
- [Claude Code Integration](Documentation/Claude-Code.md) — AI-assisted development setup
- [DDEV Commands Reference](.ddev/commands/web/README.md) — all available `ddev solr:*` commands
