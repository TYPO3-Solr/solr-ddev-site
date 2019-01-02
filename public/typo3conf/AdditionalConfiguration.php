<?php

$GLOBALS['TYPO3_CONF_VARS']['SYS']['errorHandlerErrors'] = E_WARNING | E_USER_ERROR | E_USER_WARNING | E_USER_NOTICE | E_RECOVERABLE_ERROR | E_DEPRECATED | E_USER_DEPRECATED;
$GLOBALS['TYPO3_CONF_VARS']['SYS']['exceptionalErrors'] = E_WARNING | E_RECOVERABLE_ERROR | E_DEPRECATED | E_USER_DEPRECATED;

$GLOBALS['TYPO3_CONF_VARS']['SYS']['trustedHostsPattern']  = 'localhost|' . $_SERVER['TYPO3_HOST'];
$GLOBALS['TYPO3_CONF_VARS']['EXTCONF']['solr']['sites'][1]['domains'][]  = $_SERVER['TYPO3_HOST'];

$GLOBALS['TYPO3_CONF_VARS']['EXT']['extConf']['tika'] = 'a:14:{s:9:"extractor";s:4:"solr";s:7:"logging";s:1:"0";s:18:"showTikaSolrModule";s:1:"0";s:16:"excludeMimeTypes";s:0:"";s:13:"fileSizeLimit";s:3:"500";s:8:"tikaPath";s:0:"";s:14:"tikaServerPath";s:0:"";s:16:"tikaServerScheme";s:4:"http";s:14:"tikaServerHost";s:9:"localhost";s:14:"tikaServerPort";s:4:"9998";s:10:"solrScheme";s:4:"http";s:8:"solrHost";s:4:"solr";s:8:"solrPort";s:4:"8983";s:8:"solrPath";s:14:"/solr/core_en/";}';
