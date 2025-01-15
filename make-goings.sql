drop table if exists goings;

create table goings
(
  id int not null auto_increment primary key,
  name varchar(12),
  avg_speed float,
  min_speed float,
  max_speed float,
  avg_corr_speed float,
  min_corr_speed float,
  max_corr_speed float,
  weight float,
  corr_weight float,
  key name_index (name)
);

insert into goings (name)
  values ('Firm'), ('Good'), ('Yielding'), ('Soft'), ('Heavy'), ('Average');
