<?php

/**
 * Extension Manager/Repository config file for ext "introduction_news".
 */
$EM_CONF[$_EXTKEY] = [
    'title' => 'Apache Solr for TYPO3 Sitepackage : News for Introduction',
    'description' => 'Solr development site : News for Introduction',
    'category' => 'distribution',
    'constraints' => [
        'depends' => [
            'typo3' => '*',
            'news' => '*'
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
