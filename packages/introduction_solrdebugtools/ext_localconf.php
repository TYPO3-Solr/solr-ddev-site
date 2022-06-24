<?php

defined('TYPO3_MODE') || die();

/***************
 * Add default configuration
 */

\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTypoScriptSetup('
  @import \'EXT:introduction_solrdebugtools/Configuration/TypoScript/setup.typoscript\'
');
