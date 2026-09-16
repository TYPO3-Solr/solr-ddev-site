<?php


require_once('/var/www/html/config/system/additional.php');

$GLOBALS['TYPO3_CONF_VARS'] = array_replace_recursive(
    $GLOBALS['TYPO3_CONF_VARS'],
    [
        // Use DDEV default database credentials during development
        'DB' => [
            'Connections' => [
                'Default' => [
                    'dbname' => 'db_ter',
                ],
            ],
        ],
        'SYS' => [
            'trustedHostsPattern' => '.*.ddev.site',
        ],
    ],
);
