<?php

/**
 * Extension Manager/Repository config file for ext "apache_solr_for_typo3_sitepackage".
 */
$EM_CONF[$_EXTKEY] = [
    'title' => 'Apache Solr for TYPO3 Sitepackage',
    'description' => 'Solr development site',
    'category' => 'distribution',
    'constraints' => [
        'depends' => [
            'typo3' => '*',
            'bootstrap_package' => '*'
        ],
        'conflicts' => [
        ],
    ],
    'autoload' => [
        'psr-4' => [
            'Dkd\\ApacheSolrForTypo3Sitepackage\\' => 'Classes'
        ],
    ],
    'state' => 'stable',
    'uploadfolder' => 0,
    'createDirs' => '',
    'clearCacheOnLoad' => 1,
    'author' => 'Timo Hund',
    'author_email' => 'timo.hund@dkd.de',
    'author_company' => 'dkd',
    'version' => '1.0.0',
];
