#######################################
### Default data for EXT:Solr

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

-- # Add default scheduler tasks
INSERT INTO `tx_scheduler_task` (`uid`, `crdate`, `disable`, `deleted`, `description`, `nextexecution`, `lastexecution_time`, `lastexecution_failure`, `lastexecution_context`, `serialized_task_object`, `serialized_executions`, `task_group`) VALUES
(1, 1598988302, 0, 0, 'Clears the Apache Solr index and the queue, then reinitializes the index queue for pages.', 1598918400, 0, NULL, '', 'O:40:\"ApacheSolrForTypo3\\Solr\\Task\\ReIndexTask\":10:{s:34:\"\0*\0indexingConfigurationsToReIndex\";a:1:{i:1;s:5:\"pages\";}s:13:\"\0*\0rootPageId\";s:1:\"1\";s:12:\"\0*\0scheduler\";N;s:10:\"\0*\0taskUid\";i:1;s:11:\"\0*\0disabled\";b:0;s:19:\"\0*\0runOnNextCronJob\";b:0;s:12:\"\0*\0execution\";O:29:\"TYPO3\\CMS\\Scheduler\\Execution\":6:{s:8:\"\0*\0start\";i:1598918400;s:6:\"\0*\0end\";i:1598918400;s:11:\"\0*\0interval\";i:0;s:11:\"\0*\0multiple\";i:0;s:10:\"\0*\0cronCmd\";s:0:\"\";s:23:\"\0*\0isNewSingleExecution\";b:0;}s:16:\"\0*\0executionTime\";i:1598918400;s:14:\"\0*\0description\";s:89:\"Clears the Apache Solr index and the queue, then reinitializes the index queue for pages.\";s:12:\"\0*\0taskGroup\";i:1;}', NULL, 1),
(2, 1598660873, 0, 0, 'Indexes the records from site with Root Page ID: 1', 1598988300, 1598972641, '', 'CLI', 'O:49:\"ApacheSolrForTypo3\\Solr\\Task\\IndexQueueWorkerTask\":11:{s:24:\"\0*\0documentsToIndexLimit\";i:50;s:16:\"\0*\0forcedWebRoot\";s:0:\"\";s:13:\"\0*\0rootPageId\";s:1:\"1\";s:12:\"\0*\0scheduler\";N;s:10:\"\0*\0taskUid\";i:2;s:11:\"\0*\0disabled\";b:0;s:19:\"\0*\0runOnNextCronJob\";b:0;s:12:\"\0*\0execution\";O:29:\"TYPO3\\CMS\\Scheduler\\Execution\":6:{s:8:\"\0*\0start\";i:1598660771;s:6:\"\0*\0end\";s:0:\"\";s:11:\"\0*\0interval\";i:0;s:11:\"\0*\0multiple\";s:1:\"0\";s:10:\"\0*\0cronCmd\";s:9:\"* * * * *\";s:23:\"\0*\0isNewSingleExecution\";b:0;}s:16:\"\0*\0executionTime\";i:1598988300;s:14:\"\0*\0description\";s:50:\"Indexes the records from site with Root Page ID: 1\";s:12:\"\0*\0taskGroup\";i:1;}', '', 1);


### END: EXT:Solr:
#######################################

