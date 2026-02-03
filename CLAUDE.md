# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DDEV-based development environment for **Apache Solr for TYPO3** - an enterprise search integration extension. This is a monorepo containing the main EXT:solr extension and related add-ons (tika, solrconsole, solrfal, solrdebugtools, etc.).

**Tech Stack:** PHP 8.2, TYPO3 14.x (dev-main), Apache Solr, MySQL 8.0, DDEV

**Important:** No backwards compatibility with older TYPO3 versions is required. Code only needs to work with TYPO3 14.

## Essential Commands

### Running Tests (inside DDEV container)
```bash
# Unit tests
ddev composer tests:solr:unit
ddev composer tests:tika:unit
ddev composer tests:solrfal:unit
ddev composer tests:solrconsole:unit

# Integration tests
ddev composer tests:solr:integration
ddev composer tests:tika:integration
ddev composer tests:solrfal:integration
ddev composer tests:solrconsole:integration

# With PHPUnit arguments (extension name required as first param)
ddev composer tests:solr:integration -- --filter=IndexerTest
```

### Alternative DDEV commands
```bash
ddev solr:tests:unit [extension] [--filter=TestName]
ddev solr:tests:integration [extension] [--filter=TestName]
```

### Code Quality
```bash
# Static analysis (PHPStan level 6)
ddev composer tests:solr:phpstan
ddev composer tests:tika:phpstan
ddev composer tests:solrfal:phpstan

# Code refactoring with Rector
ddev composer tests:solr:rector-check    # Dry run
ddev composer tests:solr:rector          # Apply changes

# Code style fix (TYPO3 Coding Standards)
ddev composer t3:standards:fix
```

### Environment Management
```bash
ddev start                      # Start environment
ddev solr:clean:ddev-site       # Reset to initial state
ddev solr:enable <addon>        # Enable: tika, news, solrconsole, solrfal, solrdebugtools
```

## Architecture

### Reference Snapshot: TYPO3-13.4_and_EXT_solr_13.1_State

The folder `TYPO3-13.4_and_EXT_solr_13.1_State/` contains a **working snapshot** of TYPO3 13.4 with EXT:solr 13.1. Use this as a reference when making TYPO3 14 compatibility changes to:
- Compare how code worked before the upgrade
- Look up working TCA configurations, test fixtures, etc.
- Understand the previous behavior when fixing deprecations

**Hint:** All `composer tests:solr:*` commands are available inside this folder, so you can run tests there to verify the previous working state.

**Setup (if folder is empty):**
1. Clone the branch: `git clone -b release-13.1.x git@github.com:TYPO3-Solr/solr-ddev-site.git TYPO3-13.4_and_EXT_solr_13.1_State`
2. Ask the developer to run `ddev start` on host in this directory (cannot be done from inside DDEV container)

### Multi-Repository Structure
The `packages/ext-*` folders are **separate git repositories** cloned into this development environment - not a monorepo. Each extension has its own repository at https://github.com/TYPO3-Solr/.

**Important:** All cloned repositories must be on matching branches (e.g., all on `main` or all on `release-13.1.x`).

- `packages/ext-solr/` - Main Apache Solr extension (namespace: `ApacheSolrForTypo3\Solr`)
- `packages/ext-tika/` - Apache Tika text extraction (`ApacheSolrForTypo3\Tika`)
- `packages/ext-solrfal/` - FAL integration (`ApacheSolrForTypo3\Solrfal`)
- `packages/ext-solrconsole/` - Query console tool (`ApacheSolrForTypo3\Solrconsole`)
- `packages/ext-solrdebugtools/` - Debugging utilities

Root `composer.json` references these via path repositories with version overrides for local development.

### TYPO3 Extension Structure (each package)
```
Classes/           # PSR-4 namespaced PHP code
Tests/Unit/        # PHPUnit unit tests
Tests/Integration/ # PHPUnit integration tests (uses TYPO3 Testing Framework)
Configuration/     # TypoScript, TCA, site sets
Resources/         # Templates, icons, language files
Documentation/     # ReST documentation
Build/Test/        # Test configs (UnitTests.xml, IntegrationTests.xml, phpstan.neon)
```

## TYPO3 Core API Reference

When working on `packages/ext-*` code, always look up how to use the TYPO3 Core API in:
- `vendor/typo3/cms-core/Documentation/` - Official documentation
- `vendor/typo3/cms-*/Classes/` - Core implementation examples
- `vendor/typo3/cms-*/Tests/` - Test examples for proper usage

**Troubleshooting workflow:**
1. First, look how it worked in TYPO3 13 (see `TYPO3-13.4_and_EXT_solr_13.1_State/`)
2. Then, look into TYPO3 Core API Reference resources above to understand the new TYPO3 14 way

## Code Standards

- **PHPStan Level 6** - Strict type checking enforced
- **TYPO3 Coding Standards v0.8.0** - PSR-2 based
- **Rector for TYPO3 14** - Automated code modernization
- **PHP 8.2** - Use strict types and modern features

## Commit Quality Requirements

**MANDATORY: Every change-set MUST pass ALL checks before committing.**

### 1. PHPStan (MUST succeed)
```bash
composer tests:solr:phpstan
```

### 2. Unit Tests (MUST succeed)
```bash
composer tests:solr:unit
```
- **Coverage rule:** Each line in newly added methods within `Classes/` must be covered by unit tests
- **Exception:** If too much mocking is required, provide integration tests instead

### 3. Coding Standards (MUST be followed)
```bash
# Check CS (dry-run)
composer t3:standards:fix -- packages/ext-solr --diff --verbose --dry-run --show-progress=none

# Fix CS issues
composer t3:standards:fix -- packages/ext-solr --show-progress=none
```

### 4. Integration Tests (MUST succeed for affected areas)
```bash
# Run tests for associated/affected classes
composer tests:solr:integration -- --filter=<AssociatedClassName>
```

### Verification Workflow
Before any commit, run in this order:
1. `composer tests:solr:phpstan`
2. `composer tests:solr:unit`
3. `composer t3:standards:fix -- packages/ext-solr --show-progress=none`
4. `composer tests:solr:integration -- --filter=<AffectedClass>`

## Git Conventions

**Important:** Never ask to push commits - the developer will always push manually.

Commit message prefixes:
- `[BUGFIX]` - Bug fixes
- `[TASK]` - General tasks/improvements
- `[FEATURE]` - New features
- `[DOCS]` - Documentation changes

Branch strategy:
- `main` - Latest development
- `release-X.X.x` - Release maintenance branches

## URLs (after `ddev start`)

- Frontend: http://solr-ddev-site.ddev.site/
- Backend: http://solr-ddev-site.ddev.site/typo3/ (admin / Password1!)
