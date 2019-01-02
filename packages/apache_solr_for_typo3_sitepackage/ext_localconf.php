<?php
defined('TYPO3_MODE') || die();

/***************
 * Add default RTE configuration
 */
$GLOBALS['TYPO3_CONF_VARS']['RTE']['Presets']['apache_solr_for_typo3_sitepackage'] = 'EXT:apache_solr_for_typo3_sitepackage/Configuration/RTE/Default.yaml';

\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTypoScriptSetup('
  module.tx_form.settings.yamlConfigurations.100 = EXT:apache_solr_for_typo3_sitepackage/Configuration/Form/CustomFormSetup.yaml
');