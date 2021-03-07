<?php

/**
 * Extension Manager/Repository config file for ext "introduction_solrfal".
 */
$EM_CONF[$_EXTKEY] = [
    'title' => 'Apache Solr for TYPO3 Sitepackage : EXT:Solrfal for Introduction',
    'description' => 'Solr development site : EXT:Solrfal Introduction',
    'category' => 'distribution',
    'constraints' => [
        'depends' => [
            'typo3' => '10.4.0-10.4.99',
            'solrfal' => '*'
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
