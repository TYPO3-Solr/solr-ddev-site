<?php

/**
 * Extension Manager/Repository config file for ext "introduction_tika".
 */
$EM_CONF[$_EXTKEY] = [
    'title' => 'Apache Solr for TYPO3 Sitepackage : EXT:tika for Introduction',
    'description' => 'Solr development site : EXT:tika Introduction',
    'category' => 'distribution',
    'constraints' => [
        'depends' => [
            'typo3' => '10.4.0-10.4.99',
            'tika' => '*'
        ],
        'conflicts' => [
        ],
    ],
    'state' => 'stable',
    'uploadfolder' => 0,
    'createDirs' => '',
    'clearCacheOnLoad' => 1,
    'author' => 'dkd Internet Service GmbH',
    'author_email' => 'solr-eb-suport@dkd.de',
    'author_company' => 'dkd',
    'version' => '1.0.0',
];
