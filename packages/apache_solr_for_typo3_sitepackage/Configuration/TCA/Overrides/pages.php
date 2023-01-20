<?php
defined('TYPO3') || die();

call_user_func(function()
{
    /**
     * Temporary variables
     */
    $extensionKey = 'apache_solr_for_typo3_sitepackage';

    /**
     * Default PageTS for ApacheSolrForTypo3Sitepackage
     */
    \TYPO3\CMS\Core\Utility\ExtensionManagementUtility::registerPageTSConfigFile(
        $extensionKey,
        'Configuration/PageTS/All.txt',
        'Apache Solr for TYPO3 Sitepackage'
    );
});
