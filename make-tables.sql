drop table if exists races;
drop table if exists results;
drop table if exists courses;
drop table if exists trainers;
drop table if exists jockeys;
drop table if exists horses;

create table if not exists races (
  id int not null auto_increment primary key,
  raceid int,
  name varchar(30),
  course int,
  racedate date,
  racetime time,
  class int,
  agelimit varchar(10),
  prize int,
  ran int,
  yards int,
  going varchar(10),
  handicap_limit int,
  winseconds float,
  length_corr float,
  key course_index (course)
);

create table if not exists results (
   id int not null auto_increment primary key,
  `race` int DEFAULT NULL,
  `horse` int DEFAULT NULL,
  `jockey` int DEFAULT NULL,
  `trainer` int DEFAULT NULL,
  `position` varchar(6) DEFAULT NULL,
  `yards` int DEFAULT NULL,
  `winseconds` float DEFAULT NULL,
  `dstbtn` varchar(6) DEFAULT NULL,
  `totalbeaten` float DEFAULT NULL,
  `odds` float DEFAULT NULL,
  `age` int DEFAULT NULL,
  `weight` int DEFAULT NULL,
  `favs` varchar(10) DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `runtime` float DEFAULT NULL,
  `speed` float GENERATED ALWAYS AS (if(((`runtime` is null)
                                       or (`winseconds` = 0.0)
                                       or (`dstbtn` = _utf8mb4'dist')),
                                     0,
                                     ((`yards` / `runtime`) * (3600 / 1760)))) VIRTUAL,
  `corrected_speed` float DEFAULT NULL,
  `winnings` float GENERATED ALWAYS AS (if((`position` = 1),`odds`,-(1))) VIRTUAL,
  key race_index (race),
  key horse_index (horse),
  key trainer_index (trainer),
  key jockey_index (jockey)
 );

create table if not exists courses (
  id int not null auto_increment primary key,
  name varchar(30)
);

create table if not exists horses (
  id int not null auto_increment primary key,
  name varchar(30),
  first_race date,
  last_race date,
  avg_speed float,
  max_speed float,
  min_speed float,
  avg_corr_speed float,
  max_corr_speed float,
  min_corr_speed float,
  winnings float,
  fav_winnings float,
  races int,
  fav_races int,
  wins int,
  fav_wins int,
  win_rate float generated always as (wins/if(races=0, 1, races)),
  fav_win_rate float generated always as (fav_wins/(if(fav_races=0, 1, fav_races))),
  avg_odds float,
  min_odds float,
  max_odds float,
  key name_index (name)
);

create table if not exists trainers (
  id int not null auto_increment primary key,
  name varchar(30),
  first_race date,
  last_race date,
  avg_speed float,
  max_speed float,
  min_speed float,
  avg_corr_speed float,
  max_corr_speed float,
  min_corr_speed float,
  winnings float,
  fav_winnings float,
  races int,
  fav_races int,
  wins int,
  fav_wins int,
  win_rate float generated always as (wins/if(races=0, 1, races)),
  fav_win_rate float generated always as (fav_wins/(if(fav_races=0, 1, fav_races))),
  key name_index (name)
);

create table if not exists jockeys (
  id int not null auto_increment primary key,
  name varchar(30),
  first_race date,
  last_race date,
  avg_speed float,
  max_speed float,
  min_speed float,
  avg_corr_speed float,
  max_corr_speed float,
  min_corr_speed float,
  winnings float,
  fav_winnings float,
  races int,
  fav_races int,
  wins int,
  fav_wins int,
  win_rate float generated always as (wins/if(races=0, 1, races)),
  fav_win_rate float generated always as (fav_wins/(if(fav_races=0, 1, fav_races))),
  key name_index (name)
);
