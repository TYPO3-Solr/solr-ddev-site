<?php
defined('TYPO3_MODE') || die();

call_user_func(function()
{
    /**
     * Temporary variables
     */
    $extensionKey = 'apache_solr_for_typo3_sitepackage';

    /**
     * Default TypoScript for ApacheSolrForTypo3Sitepackage
     */
    \TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addStaticFile(
        $extensionKey,
        'Configuration/TypoScript',
        'Apache Solr for TYPO3 Sitepackage'
    );
});
