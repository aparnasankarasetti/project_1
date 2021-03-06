# Find an example of an English wikipedia article that is relatively more popular in the Americas than elsewhere.
CREATE TABLE IF NOT EXISTS en_am_views (page STRING, views INT) PARTITIONED BY (lang STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
---------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO TABLE en_am_views PARTITION (lang = 'en') SELECT page, views FROM april_pageviews WHERE lang = 'en';
------------------------------------
CREATE TABLE IF NOT EXISTS total_am_views AS SELECT DISTINCT(page), SUM(views) OVER (PARTITION BY page ORDER BY page) AS total_views_am FROM en_am_views WHERE page != 'Main_Page' AND page != 'Special:Search' AND page != '-';
----------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS gm_de_views (page STRING,views INT) PARTITIONED BY (lang STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
-------------------------------------------------------------------------------------------
INSERT INTO TABLE gm_de_views PARTITION (lang = 'de') SELECT page, views FROM april_pageviews WHERE lang = 'de
---------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS total_gm_views AS SELECT DISTINCT(page), SUM(views) OVER (PARTITION BY page ORDER BY page) AS total_views_gm FROM gm_de_views WHERE page != 'Main_Page' AND page != 'Special:Search' AND page != '-';
---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS am_gm_views AS SELECT a.page, a.total_views_am, g.total_views_gm FROM total_am_views a INNER JOIN total_gm_views g ON (a.page = g.page);
-------------------------------------------------------------------
SELECT * FROM am_gm_views order by total_views_am desc limit 20; 
