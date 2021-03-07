<?php
defined('TYPO3_MODE') || die();

/***************
 * Add default RTE configuration
 */

\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTypoScriptConstants('
  @import \'EXT:introduction_solrfal/Configuration/TypoScript/constants.typoscript\'
');

\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTypoScriptSetup('
  @import \'EXT:introduction_solrfal/Configuration/TypoScript/setup.typoscript\'
');