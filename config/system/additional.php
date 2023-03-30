<?php

$GLOBALS['TYPO3_CONF_VARS']['SYS']['errorHandlerErrors'] = E_WARNING | E_USER_ERROR | E_USER_WARNING | E_USER_NOTICE | E_RECOVERABLE_ERROR | E_DEPRECATED | E_USER_DEPRECATED;
$GLOBALS['TYPO3_CONF_VARS']['SYS']['exceptionalErrors'] = E_WARNING | E_RECOVERABLE_ERROR | E_DEPRECATED | E_USER_DEPRECATED;

$GLOBALS['TYPO3_CONF_VARS']['SYS']['trustedHostsPattern']  = 'localhost|solr-ddev-site.ddev.site';
$GLOBALS['TYPO3_CONF_VARS']['EXTCONF']['solr']['sites'][1]['domains'][]  = 'solr-ddev-site.ddev.site';

// Temporary fix:
$GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport_sendmail_command'] = '/usr/local/bin/mailhog sendmail test@example.org --smtp-addr 127.0.0.1:1025 -bs';

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Configure Tika within solr-ddev-site                                                                               */
/*   Notes:                                                                                                           */
/*     Only "Extractor" option is writable via BE->Setting->Extension Configuration->tika                             */
if (isset($GLOBALS['TYPO3_CONF_VARS']['EXTENSIONS']['tika'])) {
    \TYPO3\CMS\Core\Utility\ArrayUtility::mergeRecursiveWithOverrule(
        $GLOBALS['TYPO3_CONF_VARS']['EXTENSIONS']['tika'],
        [
            // # General

            // Enable Logging
            'logging' => '0',
            // Show Tika Backend Module ::: Enables a Tika module within the Solr backend module (experimental, only works with Tika server)
            'showTikaSolrModule' => '0',
            // List of mime types to be excluded in metadata extraction
            'excludeMimeTypes' => '',
            // File size limit when a file should be processed (configured in MB)
            'fileSizeLimit' => 500,

            // # Tika App
            // Tika App configuration
            'tikaPath' => '',

            // # Tika Server // Uses ddev's configs from .ddev/docker-compose.tika.yaml
            'tikaServerScheme' => 'http',
            'tikaServerHost' => 'tika',
            'tikaServerPort' => '9998',
            'tikaServerPath' => '',         // Tika Server Jar Path ::: [Optional] The absolute path to your Apache Tika server jar file (tika-server-x.x.jar). When set you can use the backend module to start and stop the Tika server from the TYPO3 backend. Otherwise the host and port settings will be used.

            // # Solr Server // Uses ddev's configs from  .ddev/docker-compose.solr.yaml
            'solrScheme' => 'http',
            'solrHost' => 'solr-site',
            'solrPort' => '8983',
            'solrPath' => '/solr/core_en/'
        ]
    );
}
