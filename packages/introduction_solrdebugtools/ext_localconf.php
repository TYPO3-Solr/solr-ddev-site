<?php

defined('TYPO3') or die('Access denied.');

use TYPO3\CMS\Core\Utility\ExtensionManagementUtility;

/***************
 * Add default configuration
 */

ExtensionManagementUtility::addTypoScriptSetup('
  @import \'EXT:introduction_solrdebugtools/Configuration/TypoScript/setup.typoscript\'
');
