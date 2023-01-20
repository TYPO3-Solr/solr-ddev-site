<?php

declare(strict_types=1);

use TYPO3\CMS\Core\Utility\ExtensionManagementUtility;

defined('TYPO3') || die();

/***************
 * Add default RTE configuration
 */
$GLOBALS['TYPO3_CONF_VARS']['RTE']['Presets']['apache_solr_for_typo3_sitepackage'] = 'EXT:apache_solr_for_typo3_sitepackage/Configuration/RTE/Default.yaml';


ExtensionManagementUtility::addTypoScriptConstants('
  @import \'EXT:apache_solr_for_typo3_sitepackage/Configuration/TypoScript/constants.typoscript\'
');

ExtensionManagementUtility::addTypoScriptSetup('
  @import \'EXT:apache_solr_for_typo3_sitepackage/Configuration/TypoScript/setup.typoscript\'
');
