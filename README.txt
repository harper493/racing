These files read and digest racing result files in the format supplied by
racingformbook.com into MySql databases that can be used to analyse the
results.

Loading Data
------------

The raw CSV data from the website is loaded into table 'rawdata' in a database
called 'raw', using the load-raw.sh script. It takes one argument, which is
the name of the file to load:

./load-raw.sh data/SFF_2016-2019.csv

This can be repeated for each distinct CSV file.

Building Analytic Data
----------------------

Once the raw data is loaded, as many custom databases as wanted can be
constructed from it, using the build-tables.sh script:

./build-tables.sh database-name criteria

This creates or updates a database of the given name, for races matching the
given criteria. A list of avalable criteria is given below.

The new database contiains the following tables:

-- races, one row per matching race, with information common to all
   entries in the race
-- results, one row per horse per race, with information that horse
   in the races
-- horses, one row per horse that has appeared in at least one
   selected race
-- trainers, one row per trainer
-- jockeys, one row per jockey
-- courses, one row per course

'Races' table
-------------

The 'races' table has the columns show below. Note that the database
is normmalizsed, so to obtain details of e.g. the horse, a table join must
be used.

-- id - unique identifier for the race
-- raceid - the race identifier from the source data
-- name - the name of the race
-- course - the identifer of the course, in the 'sourses' table
-- racedate - the date of the race, in the format yyyy-mm-dd
-- racetime - the time of the race, in the format hh:mm
-- class - the race class
-- agelimit - the upper age limit for the race
-- prize - the prize for the race
-- ran - number of horses running
-- yards - race length in yards
-- going - one of firm, good, yielding, soft, heavy or
           average (the latter where the source data contains
           any other value)
-- handicap_limit
-- winseconds - the time in seconds for the winning horse
-- length_corr - a correction factor applied for the race
                 length, when compouting corrected speed

'Results' table
---------------

The 'results' table has the following columns:

-- id - unique identifier for the result
-- race - the identifier of the race in the 'races' table
-- horse - the identifier of the horse in the 'horses' table
-- jockey - the identifier of the jockey in the 'jockeys' table
-- trainer - the identifier of the trainer in the 'trainers' table
-- position - the position of the horse, if it finished
-- yards - race length in yards
-- winseconds - winner's time in seconds
-- dstbtn - difference between this horse's time and the winner,
            or an explanation of why it didn't finish
-- totalbeaten - difference between this horse's time and the winner
-- odds - this horse's odds
-- age
-- weight - in pounds
-- favs - 'Fav' if this horse was favourite
-- rating - horse's rating
-- runtime - this horse's time for the race, or 0 if it didn't
             finish or was very distant
-- speed - this horse's speed for the race, in mph
-- corrected_speed - speed corrected for going and race length
                     (see explanation below)
-- winnings - for the winner, its odds for the race. Otherwise, -1.

'Corrected speed' is the actual speed of a horse adjusted for
the specific race, to give a metric which is (as far as possible) independent
of the length and going of the race. This uses averages across
all the data to compensate for:

-- race length - the average speed for longer races is lower than for
                 shorter ones
-- going - the average speed for softer going is lower than for harder
           going

'Horses', 'Trainers' and 'Jockeys' Tables
-----------------------------------------

The 'horses', 'jockeys' and 'trainers' tables all have the following
columns:

-- id - unique identifer
-- name
-- first_race - date of the first race in this selection
-- last_race - date of the last race in this selection
-- avg_speed - average speed across all relevant races
-- max_speed - maximum speed
-- min_speed - minimum speed
-- avg_corr_speed - average corrected speed (see above)
-- max_corr_speed
-- min_corr_speed
-- winnings - the average win or loss per race. -1 indicates
              that every race was lost. 0 means means you would
              have neither won nor lost had you backed this horse etc
              in every race.
-- fav_winnings - as above but only for races where the horse
                  was favourite
-- races - number of races participated in
-- fav_races - number of races where the horse was favourite
-- wins - the number of wins
-- fav_wins - the number of wins where the horse was favourite
-- win_rate - ratio of wins to races
-- fav_win_rate - as above where the horse was favourite

In addition, the 'horses' table has the following extra columns:

-- avg_odds - the average odds for all races (calculated as the
              geometric mean)
-- min_odds
-- max_odds

Raw Data Selection Criteria
---------------------------

The following columns in the raw data (table raw.rawdata) can usefully
be used to reduce the data. There are many other columns which are
primarily there to populate the analytic tables.

-- course - name as a string
-- racedate - in the form yyyy-mm-dd
-- type - 'h' for hurdles, blank for flat
-- class - the class of the race from 1 (best horses) to 6
-- agelimit
-- prize
-- yards - race length in yards

Using the Database
------------------

Once a database has been vcreated for the required criteria, it can
be analysed using MySql statements, for example:

select * from horses order by winnings desc limit 30;

    Show the top 30 horses by the amount you would win if
    you simply bet on them in every race.

select * from horses where races>1 and max_odds<20 order by winnings desc limit 30;

    As above but don't include horses which only ran once or which won
    by fluke on very long odds.

select * from trainers where races>5 order by win_rate desc limit 20;

    Show the best 20 trainers by how often they win, ignoring those
    who have had few races.

select * from results join horses on horses.id=results.horse join
    trainers on trainers.id=results.trainer order by horses.win_rate desc
    limit 20;

    Show the trainers for the horses that have the best win rate.
    
