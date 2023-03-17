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
Password: password

***Recreate***

From time to time you might want to start again with a clean database state. To do that run:

```
ddev solr:clean:ddev-site
```

This will remove all the things and bring the system tu the initial state.


## Running tests:

The tests can be executed within the ddev docker containers.

### run unit tests
    ddev solr:tests:unit

### run integration tests
    ddev solr:tests:integration

## Enable EXT:solr features via EXT:solr* addons.

Following EXT:solr* addons can be switched on in this environment by `ddev solr:enable <addon-or-demo>` command:

(EB = requires EB account and presence of addon in pacages/ext-<addon-name> path.)
(Nø = To be integrated in solr-ddev-site)

* solrconsole (EB)
* solrdebugtools (EB)
* solrfal (EB)
* solrfluidgrouping
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
