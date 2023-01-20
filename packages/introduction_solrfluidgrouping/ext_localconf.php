<?php
defined('TYPO3') || die();

/***************
 * Add default configuration
 */

\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTypoScriptConstants('
  @import \'EXT:introduction_solrfluidgrouping/Configuration/TypoScript/constants.typoscript\'
');

\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTypoScriptSetup('
  @import \'EXT:introduction_solrfluidgrouping/Configuration/TypoScript/setup.typoscript\'
');
