drop table if exists lengths;

create table lengths
(
  id int not null auto_increment primary key,
  upper_bound int,
  lower_bound int,
  avg_speed float,
  corr_speed float,
  ub_corr float,
  lb_corr float
);

alter table lengths add index length_index (upper_bound);

insert into lengths (upper_bound, lower_bound)
  values (1000, 0), (2000, 1000), (3000, 2000), (4000, 3000), (5000, 4000), (6000, 5000), (7000, 6000), (8000, 7000);
