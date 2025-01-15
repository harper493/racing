set global local_infile=1;

use raw;

CREATE TABLE if not exists `rawdata` (
  `id` int NOT NULL AUTO_INCREMENT,
  `raceid` int DEFAULT NULL,
  `course` varchar(30) DEFAULT NULL,
  `racedate` date DEFAULT NULL,
  `racetime` time DEFAULT NULL,
  `racename` varchar(60) DEFAULT NULL,
  `type` varchar(8) DEFAULT NULL,
  `class` int DEFAULT NULL,
  `agelimit` varchar(10) DEFAULT NULL,
  `prize` int DEFAULT NULL,
  `ran` int DEFAULT NULL,
  `distance` varchar(20) DEFAULT NULL,
  `yards` int DEFAULT NULL,
  `going_raw` varchar(30) DEFAULT NULL,
  `handicap_limit` int DEFAULT NULL,
  `wintime` varchar(20) DEFAULT NULL,
  `winseconds` float DEFAULT NULL,
  `position` varchar(6) DEFAULT NULL,
  `dstbtn` varchar(6) DEFAULT NULL,
  `totalbeaten` float DEFAULT NULL,
  `cardno` int DEFAULT NULL,
  `horse` varchar(40) DEFAULT NULL,
  `draw` int DEFAULT NULL,
  `odds` float DEFAULT NULL,
  `age` int DEFAULT NULL,
  `stone` int DEFAULT NULL,
  `lbs` int DEFAULT NULL,
  `weight` int DEFAULT NULL,
  `favs` varchar(10) DEFAULT NULL,
  `aid` varchar(6) DEFAULT NULL,
  `trainer` varchar(30) DEFAULT NULL,
  `jockey` varchar(30) DEFAULT NULL,
  `allow` int DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `runtime` float GENERATED ALWAYS AS (if(((`totalbeaten` > 0) or (`position` = 1)),(`winseconds` + `totalbeaten`),NULL)) VIRTUAL,
  `speed` float GENERATED ALWAYS AS (if(((`runtime` is null) or (`winseconds` = 0.0)),0,((`yards` / `runtime`) * (3600 / 1760)))) VIRTUAL,
  `going` varchar(10) GENERATED ALWAYS AS (substring_index(`going_raw`,_utf8mb4' ',1)) VIRTUAL,
  PRIMARY KEY (`id`),
  KEY `horsename` (`horse`)
);

load data local infile "#file#" into table raw.rawdata
character set latin1
fields terminated by ',' enclosed by '"'
lines terminated by '\n'
ignore 1 lines
( raceid,
 course,
 @t1,
 racetime,
 racename,
 type,
 class,
 agelimit,
 @t2,
 ran,
 distance,
 yards,
 going_raw,
 handicap_limit,
 wintime,
 winseconds,
 position,
 dstbtn,
 totalbeaten,
 cardno,
 horse,
 draw,
 odds,
 age,
 stone,
 lbs,
 weight,
 favs,
 aid,
 trainer,
 jockey,
 allow,
 rating,
 @t3 
)
set racedate = str_to_date(@t1, '%d-%M-%y'),
prize=replace(@t2, ',', '')
;
