# Running tests with ddev

Scripts in this directory will be executed inside the web container.

## Running unit tests:

Following command will execute the unit tests for all enabled EXT:solr extensions:

    ddev solr:tests:unit

Following command will execute the unit tests for EXT:tika extension:

    ddev solr:tests:unit tika

## Running integration tests:

Following command will execute the integration tests for all enabled EXT:solr extensions:

    ddev solr:tests:integration

Following command will execute the integration tests provided by EXT:solr `Integration\IndexQueue\IndexerTest`:

    ddev solr:tests:integration solr --filter=IndexerTest

Following command will execute the unit tests for EXT:tika extension:

    ddev solr:tests:integration tika

Note: For using PhpUnits arguments on `ddev solr:tests:*` commands the extension name must be provided by first parameter.
