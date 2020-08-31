<?php

/**
 * Extension Manager/Repository config file for ext "news_introduction".
 */
$EM_CONF[$_EXTKEY] = [
    'title' => 'Apache Solr for TYPO3 Sitepackage : News Introduction',
    'description' => 'Solr development site : News Introduction',
    'category' => 'distribution',
    'constraints' => [
        'depends' => [
            'typo3' => '10.4.99',
            'news' => '8.4.0-8.4.99'
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
