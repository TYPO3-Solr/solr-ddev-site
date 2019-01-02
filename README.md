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
http://solr-ddev-site.ddev.local/
```

The TYPO3 backend can be accessed with:

```
http://solr-ddev-site.ddev.local/typo3/
```

Username: admin
Password: password

***Recreate***

From time to time you might want to start again with a clean data base. To do that run:

```
ddev stop
ddev remove --remove-data
ddev start
```