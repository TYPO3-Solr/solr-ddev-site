<?php

defined('TYPO3') || die();

/***************
 * Add default configuration
 */

\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTypoScriptSetup('
  @import \'EXT:introduction_solrdebugtools/Configuration/TypoScript/setup.typoscript\'
');
