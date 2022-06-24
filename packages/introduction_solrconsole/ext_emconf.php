<?php

/**
 * Extension Manager/Repository config file for ext "introduction_solrconsole".
 */
$EM_CONF[$_EXTKEY] = [
    'title' => 'Apache Solr for TYPO3 Sitepackage : EXT:solrconsole for Introduction',
    'description' => 'Solr development site : EXT:solrconsole Introduction',
    'category' => 'distribution',
    'version' => '11.5.0',
    'state' => 'stable',
    'constraints' => [
        'depends' => [
            'typo3' => '*',
            'solrconsole' => '*'
        ],
        'conflicts' => [
        ],
    ],
    'uploadfolder' => 0,
    'createDirs' => '',
    'clearCacheOnLoad' => 1,
    'author' => 'dkd Internet Service GmbH',
    'author_email' => 'solr-eb-suport@dkd.de',
    'author_company' => 'dkd',
];
