# DDEV Apache Solr for TYPO3 System

Get going quickly with TYPO3 CMS and Apache Solr.

## Prerequisites

* Install docker (Version should be higher than 17.05)
* Install ddev (Version should be equal or higher then 1.5.1)

## Quickstart

***Startup***

The ddev environment can be created very easily:

```
ddev start
```

After the startup you can access the TYPO3 site with the following url:

```
http://solr-ddev-site.ddev.site/
```

The TYPO3 backend can be accessed with:

```
http://solr-ddev-site.ddev.site/typo3/
```

Username: admin
Password: Password1!

***Recreate***

From time to time you might want to start again with a clean database state. To do that run:

```
ddev solr:clean:ddev-site
```

This will remove all the things and bring the system tu the initial state.


## Running tests:

The tests can be executed within the ddev docker containers.

### run unit tests for particular EXT:solr* extension
    ddev composer tests:<extension-name>:unit

### run integration tests for particular EXT:solr* extension
    ddev composer tests:<extension-name>:integration

### Use PhpUnit params and flags within the tests

    ddev composer tests:<extension-name>:integration -- <--PhpUnit-params-and/or-flag_01> <--PhpUnit-params-and/or-flag_etc>

## Enable EXT:solr features via EXT:solr* addons.

Following EXT:solr* addons can be switched on in this environment by `ddev solr:enable <addon-or-demo>` command:

(EB = requires EB account and presence of addon in pacages/ext-<addon-name> path.)
(Nø = To be integrated in solr-ddev-site)

* solrconsole (EB)
* solrdebugtools (EB)
* solrfal (EB)
* solrfheadless (EB and Nø)
* solrmlt (Nø)
* tika
* news (As demo of record indexing.)

```
ddev solr:enable <addon-or-demo>
ddev solr:enable news
ddev solr:enable solrfluidgrouping
ddev solr:enable solrfal
```



### Examples for enable addons:



[See more about running tests whithin ddev](.ddev/commands/web/README.md)



# Claude-Code sand-boxed on ddev project

## Requirements:

1. Claude-Code subscription
2. Credentials via ENV in `.ddev/config.claude-code.local.yaml`
   ```yaml
   web_environment:
     - 'ANTHROPIC_AUTH_TOKEN=<your-token>'
     ## Optional:
     # - 'ANTHROPIC_BASE_URL=https://<your_proxy>'
   ```

## How it works:

### Installation of binaries:

See: `.ddev/config.claude-code.yaml`

`webimage_extra_packages:` block inside of `.ddev/config.claude-code.yaml` provides all dependencies required by Claude-Code for DDEV.
DDEV installs them all on start up of web container.

### Paths & co.:

DDEV mounts local project paths required and used by claude-code binaries via `.ddev/docker-compose.claude-code.yaml`.

* `.ddev/claude-code/.local/*` holds the Claude-Code binaries
   This prevents the downloading of ~213MB binaries on each start of DDEV project.
   Note: The binary upgrade must be done manually. See: https://code.claude.com/docs/en/setup#update-claude-code
* `.ddev/claude-code/config/*` holds all your settings.
   Don't push to GIT anything from this folder, except your team really wants the parts of that path in your project.
* `.ddev/homeadditions/.bashrc.d/path.sh` adds Claude-Code binary to `$PATH` variable
   So you can run `claude` inside of web container e.g. after `ddev ssh`...

### GIT

As mentioned above, **Do not push anything related to Claude-Code, except your team requeres/benefits from that parts.**

### Usage:

`ddev claude` will start the session.

TBD...
