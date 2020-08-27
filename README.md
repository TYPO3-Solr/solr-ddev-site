# DDEV Apache Solr for TYPO3 System

Get going quickly with TYPO3 CMS and Apache Solr.

## Prerequisites

* Install docker (Version should be higher then 17.05)
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

From time to time you might want to start again with a clean data base. To do that run:

```
ddev clean
```

This will remove all the things and bring the system tu the initial state.


## Running tests:

The tests can be executed within the ddev docker containers.

### run unit tests    
    ddev tests-unit

### run integration tests
    ddev tests-integration

[See more about running tests whithin ddev](.ddev/commands/web/README.md)