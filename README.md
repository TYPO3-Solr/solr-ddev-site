# DDEV Apache Solr for TYPO3 System

Get going quickly with TYPO3 CMS and Apache Solr.

## Prerequisites

* Install docker (Version should be higher than 17.05)
* Install ddev (Version should be equal or higher than 1.22.1)

## Quickstart

The DDEV environment can be created very easily for desired EXT:solr major version.
Each EXT:solr major version has its own branch, so this repository reflects that and uses the same branch-name for desired EXT:solr branch:
So you'll find the branches like `release-<major-version>` on all EXT:solr repositories.

**Note:**

**Each major-branch requires the own folder or project in your IDE. You can not switch to other major version after project was started.**

Background: We want to test the things, features, backports, tests, etc. in different major versions.
With this approach we can run different versions simultaneously and save time for setup by switching versions.

### Chose required branch

***when to use main branch***

If you want to implement and test some feature or make a bugfix, you want the `main` branch in 99% of cases.
So after checkout of this repository you can proceed with the "Startup" section.
**Note: The main branch could be very unstable and have issues within the EXT:solr* feature set, but at least the tests are runnable.**


***when to use release-x.y.z branch***

* For our workshops you want the newest stable release branch.
* For test and or implement the back-ports and ports

**Info:** The new release-x.y.z will be crated from stable state of main branch only.


### Startup

```
ddev start
```

After the startup you can access the TYPO3 site with the following url:

**Note: The domain is dependent on used solr-ddev-site branch. Use `ddev describe` to get right URL.**

```
https://solr-12.0.ddev.site/
```

The TYPO3 backend can be accessed with:

```
https://solr-12.0.ddev.site/typo3/
```

Username: admin
Password: Password1!

***Recreate***

From time to time you might want to start again with a clean database state. To do that run:

```
ddev solr:clean:ddev-site
```

This will remove all the things and bring the system tu the initial state.


## The folder structure and contribution to EXT:solr*
```
.
├── config
│     ├── sites
│     └── system
├── packages
│     ├── apache_solr_for_typo3_sitepackage -> our site-package
│     ├── ext-solr                          -> cloned in desired branch automatically by ddev. Please add your fork as remote here.
│     ├── introduction_news                 -> settings for EXT:news
│     ├── introduction_solrconsole          -> settings for EXT:solrconsole
│     ├── introduction_solrdebugtools       -> settings for EXT:solrdebugtools
│     ├── introduction_solrfal              -> settings for EXT:solrfal
│     └── introduction_tika                 -> settings for EXT:tika
├── public
└── vendor
```

The DDEV clones the EXT:solr repository automatically in `packages/ext-solr` folder
and changes into the the same branch as solr-ddev-site repository, if necessary by first start.
So you will get the "dev-state" of major-branch on you system up and running.

### Contributing

1. See https://docs.github.com/en/get-started/exploring-projects-on-github/contributing-to-a-project
2. Add your fork as remote to the git repository on `packages/ext-*` folder
3. Checkout the new branch like bugfix/issue-number_keywords
4. add the tests(See: Running tests section), make changes, etc.
5. commit changes and push them to your fork
6. create a pull request

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

(EB = requires EB account and presence of addon in packages/ext-<addon-name> path.)
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
ddev solr:enable tika
ddev solr:enable solrfal
```

## Available commands

This project provides multiple commands, all of them are prepended with `solr:` so you can easily find them:

* either by `ddev` command
* or `ddev composer` command
  alternatively within `ddev ssh` session by `composer` command


[See more about running tests whithin ddev](.ddev/commands/web/README.md)
