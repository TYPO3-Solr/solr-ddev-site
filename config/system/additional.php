<?php

use TYPO3\CMS\Core\Core\Environment;
use TYPO3\CMS\Core\Utility\ArrayUtility;

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
    $tikaComposerManifest = json_decode(file_get_contents(Environment::getProjectPath() . '/packages/ext-tika/composer.json'), true);
    $requiredTikaVersion = $tikaComposerManifest['extra']['TYPO3-Solr']['ext-tika']['require']['Tika'];
    ArrayUtility::mergeRecursiveWithOverrule(
        $GLOBALS['TYPO3_CONF_VARS']['EXTENSIONS']['tika'],
        [
            // # General

            // Enable Logging
            'logging' => '0',
            // List of mime types to be excluded in metadata extraction
            'excludeMimeTypes' => '',
            // File size limit when a file should be processed (configured in MB)
            'fileSizeLimit' => 500,

            // # Tika App
            // Tika App configuration
            'tikaPath' => '/opt/tika/tika-app-' . $requiredTikaVersion . '.jar',

            // # Tika Server // Uses ddev's configs from .ddev/docker-compose.tika.yaml
            'tikaServerScheme' => 'http',
            'tikaServerHost' => 'tika',
            'tikaServerPort' => '9998',

            // # Solr Server // Uses ddev's configs from  .ddev/docker-compose.solr.yaml
            'solrScheme' => 'http',
            'solrHost' => 'solr-site',
            'solrPort' => '8983',
            'solrPath' => '/',
            'solrCore' => 'core_en',
        ]
    );
}
