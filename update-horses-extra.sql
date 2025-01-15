update ignore horses join (
  select horse,
         exp(sum(ln(odds)) / count(*)) as avg_odds, -- geometric mean
         min(odds) as min_odds,
         max(odds) as max_odds
  from results
  group by horse
  ) as r
  on horses.id=r.horse
  set
    horses.avg_odds = r.avg_odds,
    horses.min_odds = r.min_odds,
    horses.max_odds = r.max_odds;
  
