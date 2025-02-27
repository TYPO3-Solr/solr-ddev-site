<?php

/**
 * Extension Manager/Repository config file for ext "introduction_solrdebugtools".
 */
$EM_CONF[$_EXTKEY] = [
    'title' => 'Apache Solr for TYPO3 Sitepackage : EXT:solrdebugtools for Introduction',
    'description' => 'Solr development site : EXT:solrdebugtools Introduction',
    'category' => 'distribution',
    'version' => '13.0.0',
    'state' => 'stable',
    'constraints' => [
        'depends' => [
            'typo3' => '*',
            'solrdebugtools' => '*'
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
