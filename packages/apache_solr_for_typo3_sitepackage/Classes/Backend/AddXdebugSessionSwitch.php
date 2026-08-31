<?php

declare(strict_types=1);

namespace Dkd\ApacheSolrForTypo3Sitepackage\Backend;

use TYPO3\CMS\Backend\Controller\Event\BeforeBackendPageRenderEvent;
use TYPO3\CMS\Core\Attribute\AsEventListener;
use TYPO3\CMS\Core\Page\JavaScriptModuleInstruction;

/**
 * Puts the Xdebug session switch into the backend shell, the same widget the frontend gets via
 * TypoScript. It renders once for the whole backend because the event fires for the shell
 * document, not for each module.
 *
 * The widget itself decides whether to appear at all (local development hosts only) and never
 * issues a request, so loading it unconditionally cannot start a debug session on its own.
 * See Documentation/Xdebug-DBGp.md.
 */
#[AsEventListener('apache-solr-for-typo3-sitepackage/add-xdebug-session-switch')]
final readonly class AddXdebugSessionSwitch
{
    public function __invoke(BeforeBackendPageRenderEvent $event): void
    {
        $event->javaScriptRenderer->addJavaScriptModuleInstruction(
            JavaScriptModuleInstruction::create(
                '@dkd/apache-solr-for-typo3-sitepackage/XdebugSessionSwitch.js',
            ),
        );
    }
}
