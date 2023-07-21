#######################################
### Default data for ImpExp
### Preset for Solr development site : News Introduction


START TRANSACTION;
    SET @@SESSION.information_schema_stats_expiry = 0;
    -- # resolve the auto increment value for the taskUid, since it is a part of serilized string definition of a task record.
    SET @taskUid=(SELECT AUTO_INCREMENT FROM information_schema.tables WHERE `tables`.`TABLE_SCHEMA` = 'db' AND `tables`.`TABLE_NAME` = 'tx_scheduler_task');
    -- # Insert EXT:Solrfal scheduler task
INSERT INTO `tx_scheduler_task` (`uid`, `crdate`, `disable`, `deleted`, `description`, `nextexecution`, `lastexecution_time`, `lastexecution_failure`, `lastexecution_context`, `serialized_task_object`, `serialized_executions`, `task_group`) VALUES
(@taskUid, 1612538958, 0, 0, 'Indexes the files by EXT:Solrfal.', 1612539480, 1612539421, '', 'CLI', CONCAT('O:49:\"ApacheSolrForTypo3\\Solrfal\\Scheduler\\IndexingTask\":11:{s:17:\"\0*\0fileCountLimit\";i:25;s:16:\"\0*\0forcedWebRoot\";s:0:\"\";s:12:\"\0*\0scheduler\";N;s:10:\"\0*\0taskUid\";i:', @taskUid ,';s:11:\"\0*\0disabled\";b:0;s:19:\"\0*\0runOnNextCronJob\";b:0;s:12:\"\0*\0execution\";O:29:\"TYPO3\\CMS\\Scheduler\\Execution\":6:{s:8:\"\0*\0start\";i:1612538925;s:6:\"\0*\0end\";s:1:\"0\";s:11:\"\0*\0interval\";i:0;s:11:\"\0*\0multiple\";s:1:\"0\";s:10:\"\0*\0cronCmd\";s:9:\"* * * * *\";s:23:\"\0*\0isNewSingleExecution\";b:0;}s:16:\"\0*\0executionTime\";i:1612539480;s:14:\"\0*\0description\";s:33:\"Indexes the files by EXT:Solrfal.\";s:12:\"\0*\0taskGroup\";i:1;s:9:\"\0*\0logger\";N;}'), '', 1);
COMMIT;
