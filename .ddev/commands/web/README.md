# Running tests with ddev

Scripts in this directory will be executed inside the web container.

## Running unit tests:

Following command will execute the unit tests for all enabled EXT:solr extensions:

    ddev composer tests:solr:unit

Following command will execute the unit tests for EXT:tika extension:

    ddev composer tests:tika:unit

**Note: The EXT:tika is not enabled by default, so you want to enable it.**

This script will download EXT:tika sources and load and configure it automatically for tests and in TYPO3 instance.

    ddev solr:enable tika

## Running integration tests:

Following command will execute the integration tests for all enabled EXT:solr extensions:

    ddev composer tests:solr:integration

Following command will execute the integration tests provided by EXT:solr `Integration\IndexQueue\IndexerTest`:

    ddev composer tests:solr:integration -- --filter=IndexerTest
