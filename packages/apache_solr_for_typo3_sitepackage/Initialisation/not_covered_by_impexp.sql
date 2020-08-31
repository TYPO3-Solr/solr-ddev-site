#
# Add Static SQL tables
#

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

########################################################################################################################
### ImpExp:
### Preset for TYPO3 Solr development

--
-- Dumping data for table `tx_impexp_presets`
--

LOCK TABLES `tx_impexp_presets` WRITE;
/*!40000 ALTER TABLE `tx_impexp_presets` DISABLE KEYS */;
INSERT INTO `tx_impexp_presets` VALUES (1,1,'Introduction Package',1,0,'a:15:{s:8:"pagetree";a:3:{s:2:"id";s:1:"0";s:6:"levels";s:3:"999";s:6:"tables";a:1:{i:0;s:4:"_ALL";}}s:12:"external_ref";a:1:{s:6:"tables";a:1:{i:0;s:4:"_ALL";}}s:15:"external_static";a:1:{s:6:"tables";a:1:{i:0;s:4:"_ALL";}}s:19:"showStaticRelations";s:0:"";s:15:"excludeDisabled";s:1:"1";s:20:"download_export_name";s:14:"tree_PID0_L999";s:6:"preset";a:2:{s:5:"title";s:33:"Apache Solr for TYPO3 Sitepackage";s:6:"public";i:1;}s:4:"meta";a:3:{s:5:"title";s:33:"Apache Solr for TYPO3 Sitepackage";s:11:"description";s:42:"The development environment fot TYPO3 Solr";s:5:"notes";s:16:"State 2020.08.28";}s:8:"filetype";s:3:"xml";s:8:"filename";s:8:"data.xml";s:24:"excludeHTMLfileResources";s:0:"";s:26:"saveFilesOutsideExportFile";s:1:"1";s:13:"extension_dep";s:0:"";s:10:"softrefCfg";a:45:{s:32:"f6d1cb09107ce40378ade6058e179a47";a:1:{s:4:"mode";s:0:"";}s:32:"a761a8076f59728d210fe6a326dec1f7";a:1:{s:4:"mode";s:0:"";}s:32:"48e18ce820445817b13e30bc8e656d67";a:1:{s:4:"mode";s:0:"";}s:32:"489ae4563160371e2e111352ae4bf04f";a:1:{s:4:"mode";s:0:"";}s:32:"9700f40eaef01981e52bf05e7047c8db";a:1:{s:4:"mode";s:0:"";}s:32:"e0d903270af391bc1e7dddd38eae0072";a:1:{s:4:"mode";s:0:"";}s:32:"e56cdf0a5f2822c64c0111ad24373a54";a:1:{s:4:"mode";s:0:"";}s:32:"98931a85208d5f3e47fb02c4ee38b94a";a:1:{s:4:"mode";s:0:"";}s:32:"c1e8f2d5acfe105c4840bd8092ea3314";a:1:{s:4:"mode";s:0:"";}s:32:"e187fba080d7911a05a05a05039b731c";a:1:{s:4:"mode";s:0:"";}s:32:"694379a2d1273bf3dc9ebca498ba7096";a:1:{s:4:"mode";s:0:"";}s:32:"241aaeef3d97a824ab6401ed92b12976";a:1:{s:4:"mode";s:0:"";}s:32:"7f0d77e28de222e72730b4bc452cd4c8";a:1:{s:4:"mode";s:0:"";}s:32:"363dcd56e89c2b9130f23c64fee73631";a:1:{s:4:"mode";s:0:"";}s:32:"c6223f4bee65583a543187730c6db029";a:1:{s:4:"mode";s:0:"";}s:32:"0da0e6ee9c8526b1a9fffe7083f7ceca";a:1:{s:4:"mode";s:0:"";}s:32:"4b6635e5953f61181df4eeb1a7a94854";a:1:{s:4:"mode";s:0:"";}s:32:"ffd71b1fad70aa0d741e2d7e605354a3";a:1:{s:4:"mode";s:0:"";}s:32:"fe40e7f3779ca1809a5da365dab425d6";a:1:{s:4:"mode";s:0:"";}s:32:"adc31a25c50909afdfb439280d31ec47";a:1:{s:4:"mode";s:0:"";}s:32:"efa395b5a8dac46505dabe973f44ea3f";a:1:{s:4:"mode";s:0:"";}s:32:"58cb31ff7881ff18f4e911d63bb0dfb4";a:1:{s:4:"mode";s:0:"";}s:32:"df63486e300c5cdda7e74771f3387aa3";a:1:{s:4:"mode";s:0:"";}s:32:"0f65c761f9929d0e19da2d19abd31fa3";a:1:{s:4:"mode";s:0:"";}s:32:"fc2a618c20881a9af09c84f804f7060c";a:1:{s:4:"mode";s:0:"";}s:32:"c273386018cb5513bf7f8e480626bf2c";a:1:{s:4:"mode";s:0:"";}s:32:"a9cd6a7e7972b6248ad2f97f30e5653c";a:1:{s:4:"mode";s:0:"";}s:32:"b471aa51ef4e52171c8af285931559e7";a:1:{s:4:"mode";s:0:"";}s:32:"8373ea7740e1e552a3c27a431b0497b0";a:1:{s:4:"mode";s:0:"";}s:32:"acd7df507659b949fc76a5e575b3978c";a:1:{s:4:"mode";s:0:"";}s:32:"3fd670bc2be21d92bd6cf10cec7e4444";a:1:{s:4:"mode";s:0:"";}s:32:"4f41ab257d850be225b3378547c42494";a:1:{s:4:"mode";s:0:"";}s:32:"05e4c44b332058deae458722ce060af6";a:1:{s:4:"mode";s:0:"";}s:32:"1da6b09c5ccd59b2172d2a3a92ec7ec0";a:1:{s:4:"mode";s:0:"";}s:32:"fdd71f7f45955e06b6472db4f16d4dcb";a:1:{s:4:"mode";s:0:"";}s:32:"f5dd98e290f65965cb2f9de81426b47f";a:1:{s:4:"mode";s:0:"";}s:32:"e7be84ecf155158cf490bf9f67c5747b";a:1:{s:4:"mode";s:0:"";}s:32:"4117fbc6c6198596b48d0009d317c0de";a:1:{s:4:"mode";s:0:"";}s:32:"39fa51cdd305602a715fa9a4f2ea40a1";a:1:{s:4:"mode";s:0:"";}s:32:"620982dfb21e30a92eae12796c56b828";a:1:{s:4:"mode";s:0:"";}s:32:"1759074b8b7a7b22ec7cc8c62ee9ced7";a:1:{s:4:"mode";s:0:"";}s:32:"3d3655db94623b84ef1891a7422c82b9";a:1:{s:4:"mode";s:0:"";}s:32:"c5b1779c4bbb0ea6d7a9ce848f086b01";a:1:{s:4:"mode";s:0:"";}s:32:"3fac1744cd65e8b854083b5df161e8b7";a:1:{s:4:"mode";s:0:"";}s:32:"928d53683b62ee84a43d7951f0743387";a:1:{s:4:"mode";s:0:"";}}s:7:"exclude";a:0:{}}');
/*!40000 ALTER TABLE `tx_impexp_presets` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

### ImpExp: End
########################################################################################################################

########################################################################################################################
### EXT:Solr

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tx_scheduler_task`
--

DROP TABLE IF EXISTS `tx_scheduler_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tx_scheduler_task` (
  `uid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `crdate` int(10) unsigned NOT NULL DEFAULT 0,
  `disable` smallint(5) unsigned NOT NULL DEFAULT 0,
  `deleted` smallint(5) unsigned NOT NULL DEFAULT 0,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nextexecution` int(10) unsigned NOT NULL DEFAULT 0,
  `lastexecution_time` int(10) unsigned NOT NULL DEFAULT 0,
  `lastexecution_failure` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastexecution_context` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `serialized_task_object` mediumblob DEFAULT NULL,
  `serialized_executions` mediumblob DEFAULT NULL,
  `task_group` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`uid`),
  KEY `index_nextexecution` (`nextexecution`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tx_scheduler_task`
--

LOCK TABLES `tx_scheduler_task` WRITE;
/*!40000 ALTER TABLE `tx_scheduler_task` DISABLE KEYS */;
INSERT INTO `tx_scheduler_task` VALUES
(1,1598660873,0,0,'Indexes the records from site with Root Page ID: 1',1598662500,1598662442,'','CLI','O:49:\"ApacheSolrForTypo3\\Solr\\Task\\IndexQueueWorkerTask\":11:{s:24:\"\0*\0documentsToIndexLimit\";i:50;s:16:\"\0*\0forcedWebRoot\";s:0:\"\";s:13:\"\0*\0rootPageId\";s:1:\"1\";s:12:\"\0*\0scheduler\";N;s:10:\"\0*\0taskUid\";i:1;s:11:\"\0*\0disabled\";b:0;s:19:\"\0*\0runOnNextCronJob\";b:0;s:12:\"\0*\0execution\";O:29:\"TYPO3\\CMS\\Scheduler\\Execution\":6:{s:8:\"\0*\0start\";i:1598660771;s:6:\"\0*\0end\";s:0:\"\";s:11:\"\0*\0interval\";i:0;s:11:\"\0*\0multiple\";s:1:\"0\";s:10:\"\0*\0cronCmd\";s:9:\"* * * * *\";s:23:\"\0*\0isNewSingleExecution\";b:0;}s:16:\"\0*\0executionTime\";i:1598662500;s:14:\"\0*\0description\";s:50:\"Indexes the records from site with Root Page ID: 1\";s:12:\"\0*\0taskGroup\";i:1;}','',1),
(2,1598661004,0,0,'Clears the Apache Solr index and the queue, then reinitializes the queue.',1598918460,0,NULL,'','O:40:\"ApacheSolrForTypo3\\Solr\\Task\\ReIndexTask\":10:{s:34:\"\0*\0indexingConfigurationsToReIndex\";a:0:{}s:13:\"\0*\0rootPageId\";s:1:\"1\";s:12:\"\0*\0scheduler\";N;s:10:\"\0*\0taskUid\";i:3;s:11:\"\0*\0disabled\";b:0;s:19:\"\0*\0runOnNextCronJob\";b:0;s:12:\"\0*\0execution\";O:29:\"TYPO3\\CMS\\Scheduler\\Execution\":6:{s:8:\"\0*\0start\";i:1598918460;s:6:\"\0*\0end\";i:1598918460;s:11:\"\0*\0interval\";i:0;s:11:\"\0*\0multiple\";i:0;s:10:\"\0*\0cronCmd\";s:0:\"\";s:23:\"\0*\0isNewSingleExecution\";b:0;}s:16:\"\0*\0executionTime\";i:1598918460;s:14:\"\0*\0description\";s:73:\"Clears the Apache Solr index and the queue, then reinitializes the queue.\";s:12:\"\0*\0taskGroup\";i:1;}',NULL,1),(3,1598661363,0,0,'',1598918460,0,NULL,'','O:48:\"TYPO3\\CMS\\Scheduler\\Task\\FileStorageIndexingTask\":10:{s:10:\"storageUid\";i:1;s:12:\"\0*\0scheduler\";N;s:10:\"\0*\0taskUid\";i:3;s:11:\"\0*\0disabled\";b:0;s:19:\"\0*\0runOnNextCronJob\";b:0;s:12:\"\0*\0execution\";O:29:\"TYPO3\\CMS\\Scheduler\\Execution\":6:{s:8:\"\0*\0start\";i:1598918460;s:6:\"\0*\0end\";s:1:\"0\";s:11:\"\0*\0interval\";i:0;s:11:\"\0*\0multiple\";s:1:\"0\";s:10:\"\0*\0cronCmd\";s:11:\"45 23 * * *\";s:23:\"\0*\0isNewSingleExecution\";b:0;}s:16:\"\0*\0executionTime\";i:1598918460;s:14:\"\0*\0description\";s:0:\"\";s:12:\"\0*\0taskGroup\";i:2;s:9:\"\0*\0logger\";N;}',NULL,2);
/*!40000 ALTER TABLE `tx_scheduler_task` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

### EXT:Solr: End
########################################################################################################################


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
