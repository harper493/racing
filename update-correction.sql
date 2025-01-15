update ignore races
  join lengths
    on lengths.upper_bound = (floor(yards/1000 + 1) * 1000)
  set
     length_corr = (( yards - floor(yards/1000)*1000 ) / 1000)
                     * (ub_corr - lb_corr) 
                     + ub_corr;

update ignore results
  join races
    on races.id = results.race
  left join goings
    on races.going = goings.name
  set corrected_speed = speed * races.length_corr / ifnull(goings.weight, 1);


