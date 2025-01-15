insert ignore into courses (
  name
) select course as name from raw.rawdata
  #where#
  group by course;

insert ignore into horses (
  name
) select horse as name from raw.rawdata
  #where#
  group by horse;

insert ignore into trainers (
  name
) select trainer as name from raw.rawdata
  #where#
  group by trainer;

insert ignore into jockeys (
  name
) select jockey as name from raw.rawdata
  #where#
  group by jockey;

insert ignore into races (
  raceid,
  name,
  course,
  racedate,
  racetime,
  class,
  agelimit,
  prize,
  ran,
  yards,
  going,
  handicap_limit,
  winseconds
) select
    raceid,
    racename as name,
    courses.id as course,
    racedate,
    racetime,
    class,
    agelimit,
    prize,
    ran,
    yards,
    going,
    handicap_limit,
    winseconds
  from raw.rawdata
    join courses
      on courses.name=raw.rawdata.course
  #where#
  group by
    raceid,
    racename,
    courses.id,
    racedate,
    racetime,
    class,
    agelimit,
    prize,
    ran,
    yards,
    going,
    handicap_limit,
    winseconds;

insert ignore into results (
    race,
    horse,
    jockey,
    trainer,
    position,
    yards,
    winseconds,
    dstbtn,
    totalbeaten,
    odds,
    age,
    weight,
    favs,
    rating,
    runtime
) select
    races.id as race,
    horses.id as horse,
    jockeys.id as jockey,
    trainers.id as trainer,
    position,
    races.yards as yards,
    races.winseconds as winseconds,
    dstbtn,
    totalbeaten,
    odds,
    age,
    weight,
    favs,
    rating,
    runtime
  from raw.rawdata
    join races
      on races.raceid=raw.rawdata.raceid
    join horses
      on horses.name=raw.rawdata.horse
    join jockeys
      on jockeys.name=raw.rawdata.jockey
    join trainers
      on trainers.name=raw.rawdata.trainer
  #where#;
      
    

