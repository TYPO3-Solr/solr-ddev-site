#######################################
### Default data for ImpExp
### Preset for Solr development site : News Introduction

INSERT INTO `tx_impexp_presets` (`user_uid`, `title`, `public`, `item_uid`, `preset_data`) VALUES
(1, 'Solr development site : News Introduction', 0, 500, 'a:14:{s:8:\"pagetree\";a:3:{s:2:\"id\";s:3:\"500\";s:6:\"levels\";s:3:\"999\";s:6:\"tables\";a:1:{i:0;s:4:\"_ALL\";}}s:12:\"external_ref\";a:1:{s:6:\"tables\";a:1:{i:0;s:4:\"_ALL\";}}s:15:\"external_static\";a:1:{s:6:\"tables\";a:1:{i:0;s:4:\"_ALL\";}}s:19:\"showStaticRelations\";s:0:\"\";s:15:\"excludeDisabled\";s:0:\"\";s:20:\"download_export_name\";s:16:\"tree_PID500_L999\";s:6:\"preset\";a:2:{s:5:\"title\";s:41:\"Solr development site : News Introduction\";s:6:\"public\";i:0;}s:4:\"meta\";a:3:{s:5:\"title\";s:41:\"Solr development site : News Introduction\";s:11:\"description\";s:39:\"Exports news records for news extension\";s:5:\"notes\";s:450:\"Exports the news data to news.xml file.\r\n\r\nThe exported data should be moved to packages/news_introduction/Initialisation/ and named data.xml and data.xml.files\r\nalso following command could be used:\r\n```\r\nmv public/fileadmin/user_upload/_temp_/importexport/news.xml packages/news_introduction/Initialisation/data.xml\r\nmv public/fileadmin/user_upload/_temp_/importexport/news.xml.files packages/news_introduction/Initialisation/data.xml.files\r\n``` \r\n\";}s:8:\"filetype\";s:3:\"xml\";s:8:\"filename\";s:8:\"news.xml\";s:24:\"excludeHTMLfileResources\";s:0:\"\";s:26:\"saveFilesOutsideExportFile\";s:0:\"\";s:13:\"extension_dep\";s:0:\"\";s:7:\"exclude\";a:0:{}}');

### END: ImpExp
#######################################

#######################################
### Fix news records

-- Override uids and pids from page and all news and relations
START TRANSACTION;
SET @oldPluginPageId=(SELECT `uid` FROM `pages` WHERE `pages`.`doktype` = 1 AND `pages`.`title` = 'News');
SET @oldStoragePageId=(SELECT `uid` FROM `pages` WHERE `pages`.`doktype` = 254 AND `pages`.`title` = 'News Storage');

UPDATE `pages` SET `uid` = '500', `pid` = '1', `sorting` = '545' WHERE `pages`.`uid` = @oldPluginPageId;
UPDATE `pages` SET `uid` = '501', `pid` = '500' WHERE `pages`.`uid` = @oldStoragePageId;
UPDATE `tt_content` SET `pid` = '500' WHERE `pid` = @oldPluginPageId;
UPDATE `tx_news_domain_model_link` SET `pid` = '501';
UPDATE `tx_news_domain_model_news` SET `pid` = '501';
UPDATE `tx_news_domain_model_tag` SET `pid` = '501';
-- @todo: use vars and update the mm tables
COMMIT;

### END: Fix news records
#######################################
