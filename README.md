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
https://solr-13.1.ddev.site
```

The TYPO3 backend can be accessed with:

```
https://solr-13.1.ddev.site/typo3/
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
