update ignore goings join (
  select
    avg(speed) as avgspd,
    max(speed) as maxspd,
    min(speed) as minspd,
    avg(corrected_speed) as avgcspd,
    max(corrected_speed) as maxcspd,
    min(corrected_speed) as mincspd
  from results
  where speed>0
  ) as r
    set
    goings.avg_speed = r.avgspd,
    goings.max_speed = r.maxspd,
    goings.min_speed = r.minspd,
    goings.avg_corr_speed = r.avgcspd,
    goings.min_corr_speed = r.mincspd,
    goings.max_corr_speed = r.maxcspd
  where
    goings.name="Average";

set @goings_avg = (select avg_speed
  from goings
  where name = 'Average');

set @goings_avg_corr = (select avg_corr_speed
  from goings
  where name = 'Average');

update ignore goings join (
  select
    races.going as going,
    avg(speed) as avgspd,
    max(speed) as maxspd,
    min(speed) as minspd,
    avg(corrected_speed) as avgcspd,
    max(corrected_speed) as maxcspd,
    min(corrected_speed) as mincspd
  from results
    join races
      on races.id=results.race
  where speed>0
  group by going    
  ) as r
    on goings.name = r.going
    set
    goings.avg_speed = r.avgspd,
    goings.max_speed = r.maxspd,
    goings.min_speed = r.minspd,
    goings.avg_corr_speed = r.avgcspd,
    goings.min_corr_speed = r.mincspd,
    goings.max_corr_speed = r.maxcspd,
    goings.weight = (r.avgspd / @goings_avg),
    goings.corr_weight = (r.avgcspd / @goings_avg_corr);


