# EXT:solr Addons & Demo Features

The `ddev solr:enable` command activates additional EXT:solr extensions or demo content in this development environment.

```bash
ddev solr:enable <addon-or-demo>
```

## Available addons

| Addon            | Status  | Description                           |
|------------------|---------|---------------------------------------|
| `solrconsole`    | EB      | Solr query console for TYPO3 backend  |
| `solrdebugtools` | EB      | Debugging utilities for EXT:solr      |
| `solrfal`        | EB      | File Abstraction Layer (FAL) indexing |
| `solrheadless`   | EB + Nø | Headless/API mode for Solr results    |
| `solrmlt`        | Nø      | "More Like This" feature              |
| `tika`           | -       | Apache Tika text extraction           |
| `news`           | Demo    | EXT:news record indexing demo         |


**EB** = Enterprise Branch — requires an EB account and the extension cloned into `packages/ext-<addon-name>/`.
**Nø** = Not yet fully integrated into this DDEV environment.

## Examples

```bash
ddev solr:enable news             # Enable EXT:news demo content
ddev solr:enable solrfal          # Enable FAL indexing extension
ddev solr:enable tika             # Enable Apache Tika
```

## Cloning an EB extension

EB extensions are not publicly available. If you have access, clone them into the `packages/` directory:

```bash
git clone git@github.com:TYPO3-Solr/ext-solrfal.git packages/ext-solrfal
ddev solr:enable solrfal
```

See the main [README.md](../README.md) for the full development workflow.
