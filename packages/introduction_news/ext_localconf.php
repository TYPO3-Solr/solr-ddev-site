<?php
defined('TYPO3_MODE') || die();

/***************
 * Add default RTE configuration
 */
$GLOBALS['TYPO3_CONF_VARS']['RTE']['Presets']['apache_solr_for_typo3_sitepackage'] = 'EXT:apache_solr_for_typo3_sitepackage/Configuration/RTE/Default.yaml';

\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTypoScriptConstants('
  @import \'EXT:introduction_news/Configuration/TypoScript/constants.typoscript\'
');

\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTypoScriptSetup('
  @import \'EXT:introduction_news/Configuration/TypoScript/setup.typoscript\'
');