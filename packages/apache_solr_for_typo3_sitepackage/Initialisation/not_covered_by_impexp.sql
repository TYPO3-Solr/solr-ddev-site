#######################################
### Default data for EXT:Solr

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

-- # Scheduler task group
INSERT INTO `tx_scheduler_task_group` (`uid`, `pid`, `deleted`, `hidden`, `sorting`, `groupName`, `color`, `description`) VALUES
(1, 0, 0, 0, 256, 'EXT:solr', '', NULL);

-- # Scheduler tasks (TYPO3 14+: tasktype + parameters JSON + execution_details JSON)
INSERT INTO `tx_scheduler_task` (`uid`, `crdate`, `disable`, `deleted`, `description`, `nextexecution`, `lastexecution_time`, `lastexecution_failure`, `lastexecution_context`, `serialized_task_object`, `serialized_executions`, `tasktype`, `parameters`, `execution_details`, `task_group`) VALUES
(1, UNIX_TIMESTAMP(), 1, 0,
 'Clears the Apache Solr index and the queue, then re-initializes the index queue for pages.',
 0, 0, '', '', NULL, '',
 'ApacheSolrForTypo3\\Solr\\Task\\ReIndexTask',
 '{"site": null, "rootPageId": 1, "indexingConfigurations": "", "indexingConfigurationsToReIndex": []}',
 '{"end": 0, "start": 0, "cronCmd": "", "interval": 0, "multiple": false, "frequency": "0", "runningType": "1", "isNewSingleExecution": false}',
 1),
(2, UNIX_TIMESTAMP(), 0, 0,
 'Indexes the records and pages from site with Root Page ID: 1',
 0, 0, '', '', NULL, '',
 'ApacheSolrForTypo3\\Solr\\Task\\IndexQueueWorkerTask',
 '{"site": null, "rootPageId": 1, "documentsToIndexLimit": 60}',
 '{"end": 0, "start": 0, "cronCmd": "* * * * *", "interval": 0, "multiple": false, "isNewSingleExecution": false}',
 1),
(3, UNIX_TIMESTAMP(), 0, 0,
 'Optimizes/defragments the indexes for a site. (E.g.: Removes orphan indexes.)',
 0, 0, '', '', NULL, '',
 'ApacheSolrForTypo3\\Solr\\Task\\OptimizeIndexTask',
 '{"site": null, "cores": ["/core_en", "/core_da", "/core_de"], "rootPageId": 1, "coresToOptimizeIndex": ["/core_en", "/core_da", "/core_de"]}',
 '{"end": 0, "start": 0, "cronCmd": "0 */2 * * *", "interval": 0, "multiple": false, "isNewSingleExecution": false}',
 1),
(4, UNIX_TIMESTAMP(), 0, 0,
 'Task handling the queue data update events. Required if monitoringType is set to "Delayed".',
 0, 0, '', '', NULL, '',
 'ApacheSolrForTypo3\\Solr\\Task\\EventQueueWorkerTask',
 '{"limit": 100}',
 '{"end": 0, "start": 0, "cronCmd": "* * * * *", "interval": 0, "multiple": false, "isNewSingleExecution": false}',
 1);

### END: EXT:Solr:
#######################################
