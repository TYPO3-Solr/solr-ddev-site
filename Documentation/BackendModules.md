# EXT:solr Backend Modules

EXT:solr registers a top-level **Search** module group (`searchbackend`) in the TYPO3 backend with four submodules. They are accessible to all backend users (not just admins).

| Module                   | Purpose                                                                                                                            |
|--------------------------|------------------------------------------------------------------------------------------------------------------------------------|
| **Info**                 | View Solr server status, switch between sites/cores, inspect indexed document details for selected pages or records                |
| **Core Optimization**    | Manage **synonyms** and **stop words** per core — add, import, export, delete                                                      |
| **Index Queue**          | Inspect & manage the indexing queue — re-initialize, clear, requeue documents, view & reset indexing errors, trigger indexing runs |
| **Index Administration** | Empty the Solr index, clear the index queue, reload the index configuration                                                        |

## Related TYPO3 core modules

These are not provided by EXT:solr but commonly used together with it:

| Module                      | Purpose                                                                                                                         |
|-----------------------------|---------------------------------------------------------------------------------------------------------------------------------|
| **Reports → Status Report** | Check EXT:solr's reported status (Solr connection, schema version, plugin status). First place to look when something is broken |
| **System → Scheduler**      | Run the EXT:solr scheduler tasks (index queue worker, optimize index, etc.)                                                     |

## Source

Module registration: [`packages/ext-solr/Configuration/Backend/Modules.php`](../packages/ext-solr/Configuration/Backend/Modules.php)
