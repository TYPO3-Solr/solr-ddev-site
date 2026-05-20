# Project Structure

## Docker Services

The DDEV environment starts the following containers:

| Service      | Image                                                       | Port     | Purpose                                                    |
|--------------|-------------------------------------------------------------|----------|------------------------------------------------------------|
| `web`        | DDEV nginx-fpm + PHP 8.2                                    | 80 / 443 | TYPO3 application, runs tests and CLI commands             |
| `db`         | MySQL 8.0                                                   | 3306     | TYPO3 site database                                        |
| `db-tests`   | MySQL 8.0 (tmpfs / RAM)                                     | 3307     | Integration test databases — 4 GB RAM-backed for speed     |
| `solr-site`  | Built from `packages/ext-solr/Docker/SolrServer/Dockerfile` | 8983     | Apache Solr instance for the TYPO3 frontend                |
| `solr-tests` | Same image as `solr-site`                                   | 8985     | Apache Solr instance used exclusively by integration tests |

`solr-site` and `solr-tests` are built from the EXT:solr repository itself, so the Solr configuration always matches the extension under development.

### Solr admin UI

Run `ddev describe` to get the project hostname. The Solr admin UIs are exposed on:

| Container    | Port   |
|--------------|--------|
| `solr-site`  | `8983` |
| `solr-tests` | `8985` |

→ `https://<project-name>.ddev.site:8983/` for site
→ `https://<project-name>.ddev.site:8985/` for tests

After selecting a core, the most relevant views for EXT:solr development are:

- **Schema** — inspect field definitions, types, and analyzers configured in the core
- **Query** — build and test Solr queries (filters, facets, sorting, highlighting) directly
- **Analysis** — trace how a given input string is tokenized and transformed by the analyzer chain at index and query time
- **Documents** — manually add, update, or delete documents in the index
- **Logging** — view recent Solr server log entries (alternative to `ddev solrtail-site` / `ddev solrtail-tests`)

### Index persistence

- **`solr-site`**: the index is **persistent** across `ddev restart` and host reboots — documents indexed by the TYPO3 frontend survive container lifecycles.
- **`solr-tests`**: the index is **flushed by the EXT:solr integration tests themselves** — each test run starts from a clean state.

### Solr cores

The `TYPO3_SOLR_ENABLED_CORES` environment variable in `.ddev/docker-compose.solr.yaml` controls which language cores are loaded (default: `english german danish`).

- **`solr-site`** loads only the enabled cores once.
- **`solr-tests`** loads the enabled cores **once per CPU core** (controlled by `PARATEST=on`) so EXT:solr integration tests can run in parallel via `paratest`.
  Each worker gets its own isolated set of cores.
  The number of workers defaults to the host's CPU count and can be capped via `PARATEST_NUM_WORKERS`.

## Folder Structure

```
/var/www/html/
├── .ddev/                                  # DDEV configuration
│   ├── commands/host/                      # Commands executed on the host machine
│   │   ├── clone                           # Clone ext-* repositories into packages/
│   │   ├── enable                          # Enable an EXT:solr addon
│   │   ├── disable                         # Disable an EXT:solr addon
│   │   ├── solr_clean_ddev-site            # Reset environment to initial state
│   │   ├── solrtail                        # Tail solr-site container log
│   │   ├── solrtail-site                   # Tail .ddev/solr/site/logs/solr.log
│   │   └── solrtail-tests                  # Tail .ddev/solr/tests/logs/solr.log
│   ├── commands/web/                       # Commands executed inside the web container
│   │   ├── claude                          # Start Claude Code session
│   │   ├── examples-nutch                  # Crawl external sites via Apache Nutch into Solr
│   │   └── rector-process                  # Run Rector on a package
│   ├── claude-code/                        # Claude Code persistent storage (binaries, config)
│   ├── solr/site/                          # Solr data volume for solr-site container
│   ├── solr/tests/                         # Solr data volume for solr-tests container
│   ├── tika-jars/                          # Apache Tika JAR files
│   ├── config.yaml                         # Main DDEV project configuration
│   ├── config.claude-code.yaml             # Claude Code integration (packages, hooks, symlinks)
│   ├── config.claude-code.local.yaml       # Claude Code credentials (Don't commit/push)
│   ├── docker-compose.env.yaml             # Environment variables for web container (TYPO3, test DB)
│   ├── docker-compose.hosts.yaml           # Adds extra_hosts entry for the web container
│   ├── docker-compose.ramfs.yaml           # db-tests container (MySQL on RAM)
│   ├── docker-compose.solr.yaml            # solr-site and solr-tests containers
│   └── docker-compose.UDS.yaml             # Mounts host SSH agent socket into web container
├── packages/                               # Cloned EXT:solr* git repositories (each is independent)
│   ├── ext-solr/                           # Main EXT:solr extension
│   ├── ext-tika/                           # Apache Tika integration (after `ddev solr:enable tika`)
│   ├── ext-solrfal/                        # FAL (file indexing) integration (after `ddev solr:enable solrfal`)
│   ├── ext-solrconsole/                    # Solr query console for TYPO3 backend (after `ddev solr:enable solrconsole`)
│   ├── ext-solrdebugtools/                 # Debugging utilities (after `ddev solr:enable solrdebugtools`)
│   ├── ext-solrheadless/                   # Headless/API mode (after `ddev solr:enable solrheadless`)
│   ├── ext-solrmlt/                        # "More Like This" feature (after `ddev solr:enable solrmlt`)
│   ├── apache_solr_for_typo3_sitepackage/  # TYPO3 site package for this dev environment
│   ├── introduction_*/                     # Addon introduction/demo packages
│   └── php-solr-explain/                   # PHP Solr Explain library (must be cloned manually)
├── config/                                 # TYPO3 site configuration
├── Documentation/                          # Project documentation (this folder)
├── public/                                 # Web root (docroot)
├── var/                                    # TYPO3 runtime cache and logs
└── vendor/                                 # Composer dependencies
```

## packages/ — independent git repositories

Each `packages/ext-*` directory is a separate git repository cloned from `https://github.com/TYPO3-Solr/`.
They are not subdirectories of this repo — commits, branches, and remotes are managed independently.

`ddev clone` clones `ext-solr` automatically on first `ddev start`. Other extensions can be added via `ddev clone <addon>` or by cloning them into `packages/ext-<addon>/` using any preferred method.
