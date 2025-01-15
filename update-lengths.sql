set @avg = (select avg(speed) from results where speed>0);

update lengths
  set avg_speed =
    (select avg(speed)
      from results
      join races on races.id=results.race
      where
        speed>0
        and races.yards>=lengths.lower_bound
        and races.yards<lengths.upper_bound);

update lengths
  set corr_speed =
    (select avg(corrected_speed)
      from results
      join races on races.id=results.race
      where
        results.corrected_speed>0
        and races.yards>=lengths.lower_bound
        and races.yards<lengths.upper_bound);

update lengths as l1
  right join lengths as lu
    on lu.lower_bound = l1.upper_bound
  set l1.ub_corr = @avg / ((l1.avg_speed + lu.avg_speed) / 2);

update lengths as l1
  right join lengths as ll
    on ll.upper_bound = l1.lower_bound
  set l1.lb_corr = @avg / ((l1.avg_speed + ll.avg_speed) / 2);

update lengths
  set lb_corr = (@avg / avg_speed) + (@avg / avg_speed - ub_corr)
  where lb_corr is null;

update lengths
  set ub_corr = @avg / avg_speed + (@avg / avg_speed - lb_corr)
  where ub_corr is null;
