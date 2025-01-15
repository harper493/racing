
update ignore #type#s join (
  select
    #type#,
    count(*) as races,
    min(racedate) as first_race,
    max(racedate) as last_race
  from results
    join races
    on results.race = races.id
  group by #type#)
  as r
  on r.#type#=#type#s.id
  set
    #type#s.races = r.races,
    #type#s.first_race = r.first_race,
    #type#s.last_race = r.last_race;

update ignore #type#s join (
  select
    #type#,
    count(*) as races,
    avg(speed) as avg_speed,
    max(speed) as max_speed,
    min(speed) as min_speed,
    avg(corrected_speed) as acs,
    max(corrected_speed) as mcs,
    min(corrected_speed) as min_corr_speed
  from results
    join races
    on results.race = races.id
  where results.speed > 0
  group by #type#)
  as r
  on r.#type#=#type#s.id
  set
    #type#s.avg_speed = r.avg_speed,
    #type#s.max_speed = r.max_speed,
    #type#s.min_speed = r.min_speed,
    #type#s.avg_corr_speed = r.acs,
    #type#s.min_corr_speed = r.min_corr_speed,
    #type#s.max_corr_speed = r.mcs;

update ignore #type#s join (
  select
    #type#,
    sum(winnings) as winnings
  from results
    join races
    on results.race = races.id
  group by #type#)
  as r
  on r.#type#=#type#s.id
  set
    #type#s.winnings = r.winnings / #type#s.races;

update ignore #type#s join(
  select
    #type#,
    count(*) as favs,
    sum(winnings) as fav_winnings
  from results
    join races
    on results.race = races.id
  where results.favs = "Fav"
  group by #type#)
  as r
  on r.#type#=#type#s.id
  set
    #type#s.fav_races = r.favs,
    #type#s.fav_winnings = r.fav_winnings / r.favs;

update #type#s
  set
    fav_races=0,
    fav_winnings=0
  where fav_races is null;

update ignore #type#s join (
  select
    #type#,
    count(*) as wins
  from results
    join races
    on results.race = races.id
    where results.position = 1
  group by #type#)
  as r
  on r.#type#=#type#s.id
  set
    #type#s.wins = r.wins;

update #type#s
  set
    wins=0
  where wins is null;

update ignore #type#s join (
  select
    #type#,
    count(*) as fav_wins
  from results
    join races
    on results.race = races.id
    where results.position = 1
      and results.favs="Fav"
  group by #type#)
  as r
  on r.#type#=#type#s.id
  set
    #type#s.fav_wins = r.fav_wins;

update #type#s
  set
    fav_wins=0
  where fav_wins is null;

