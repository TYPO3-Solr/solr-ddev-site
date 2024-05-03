<?php

declare(strict_types=1);

use Rector\Config\RectorConfig;
use Rector\PHPUnit\Set\PHPUnitSetList;
use Rector\PostRector\Rector\NameImportingPostRector;
use Rector\TypeDeclaration\Rector\ClassMethod\AddVoidReturnTypeWhereNoReturnRector;
use Rector\ValueObject\PhpVersion;
use Ssch\TYPO3Rector\CodeQuality\General\ConvertImplicitVariablesToExplicitGlobalsRector;
use Ssch\TYPO3Rector\CodeQuality\General\ExtEmConfRector;
use Ssch\TYPO3Rector\Configuration\Typo3Option;
use Ssch\TYPO3Rector\Set\Typo3LevelSetList;
use Ssch\TYPO3Rector\Set\Typo3SetList;

// https://github.com/rectorphp/rector/issues/6842
// withSkip() and withPaths() does not work properly if .Build directory exists inside of extension, also if `composer tests:setup` was executed inside.
// That happen because of symlink-infinite-loop inside .Build directory (See: inside of packages/ext-solr after `composer tests:setup && ls -la .Build/vendor/apache-solr-for-typo3/solr/.Build/vendor/apache-solr-for-typo3/solr/.Build`)
// To avoid some specific commands inside of composer.json, we'll remove all the "composer tests:setup"-artefacts inside of packages/*/.
shell_exec('/bin/bash -c \'rm -Rf packages/*/{.Build,.*.cache,*.cache,composer.lock,var}\'');

return RectorConfig::configure()
    ->withPhpVersion(PhpVersion::PHP_81)
    ->withSets([
        Typo3SetList::CODE_QUALITY,
        Typo3SetList::GENERAL,
        Typo3LevelSetList::UP_TO_TYPO3_12,
        PHPUnitSetList::PHPUNIT_100,
    ])
    # To have a better analysis from PHPStan, we teach it here some more things
    ->withPHPStanConfigs([
        Typo3Option::PHPSTAN_FOR_RECTOR_PATH
    ])
    ->withRules([
        AddVoidReturnTypeWhereNoReturnRector::class,
        ConvertImplicitVariablesToExplicitGlobalsRector::class,
    ])
    ->withConfiguredRule(ExtEmConfRector::class, [
        ExtEmConfRector::PHP_VERSION_CONSTRAINT => '8.1.0-8.3.99',
        ExtEmConfRector::TYPO3_VERSION_CONSTRAINT => '12.4.3-12.4.99',
        ExtEmConfRector::ADDITIONAL_VALUES_TO_BE_REMOVED => []
    ])
    ->withImportNames()
    ->withSkip([
        __DIR__ . '/**/Configuration/ExtensionBuilder/*',
        __DIR__ . '/**/.Build/*',
        __DIR__ . '/**/var/*',
        __DIR__ . '/**/packages/**/.Build/*',
        __DIR__ . '/**/packages/**/var/*',
        NameImportingPostRector::class => [
            'ClassAliasMap.php',
        ]
    ]);
