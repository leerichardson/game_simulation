.headers on
.mode csv

.output .csv

drop table match_year;
create table match_year as 
select  gameDetail.match_id, 
        gameScore.game_year, 
        gameDetail.playerId, 
        gameDetail.minutes,
        gameDetail.home,
        gameScore.home_team,
        gameScore.visit_team
from    gameDetail 
left outer join gameScore
on gameDetail.match_id = gameScore.match_id;

drop table minutesTotal_home;
create table minutesTotal_home as
select  sum(minutes) as minutes_year, 
        game_year,
        playerId,
        home_team as team
from    match_year
where home = 1
group by game_year, playerId, home_team
order by team, game_year, minutes_year desc;
 
drop table minutesTotal_visit;
create table minutesTotal_visit as
select  sum(minutes) as minutes_year, 
        game_year,
        playerId,
        visit_team as team
from    match_year
where home = 0
group by game_year, playerId, visit_team
order by team, game_year, minutes_year desc;
  
drop table minutesTotal_tmp;
create table minutesTotal_tmp as
select * from minutesTotal_home;
insert into minutesTotal_tmp
select * from minutesTotal_visit;


drop table minutesTotal;
create table minutesTotal as
select  sum(minutes_year) as minutes_year, 
        game_year,
        playerId,
        team
from    minutesTotal_tmp
group by game_year, playerId, team
order by team, game_year, minutes_year desc;

--3158 records


select  count(playerId) as players
from    minutesTotal
group by team, game_year
order by players asc limit 10;


drop table playersAvgByYear;
create table playersAvgByYear as
select 
    playerId,
    playerName,
    SEASON,
    avg(avg_GP) as avg_GP,
    avg(avg_GS) as avg_GS,
    avg(avg_MIN) as avg_MIN,
    avg(avg_FG_made) as avg_FG_made,
    avg(avg_FG_attempted) as avg_FG_attempted,
    avg(avg_FGpercent) as avg_FGpercent,
    avg(avg_ThreeP_made) as avg_ThreeP_made,
    avg(avg_ThreeP_attempted) as avg_ThreeP_attempted,
    avg(avg_ThreePpercent) as avg_ThreePpercent,
    avg(avg_FT_made) as avg_FT_made,
    avg(avg_FT_attempted) as avg_FT_attempted,
    avg(avg_FTpercent) as avg_FTpercent,
    avg(avg_OR) as avg_OR,
    avg(avg_DR) as avg_DR,
    avg(avg_REB) as avg_REB,
    avg(avg_AST) as avg_AST,
    avg(avg_BLK) as avg_BLK,
    avg(avg_STL) as avg_STL,
    avg(avg_PF) as avg_PF,
    avg(avg_TO) as avg_TO,
    avg(avg_PTS) as avg_PTS,
    avg(total_FG_made) as total_FG_made,
    avg(total_FG_attempted) as total_FG_attempted,
    avg(total_FGpercent) as total_FGpercent,
    avg(total_ThreeP_made) as total_ThreeP_made,
    avg(total_ThreeP_attempted) as total_ThreeP_attempted,
    avg(total_ThreePpercent) as total_ThreePpercent,
    avg(total_FT_made) as total_FT_made,
    avg(total_FT_attempted) as total_FT_attempted,
    avg(total_FTpercent) as total_FTpercent,
    avg(total_OR) as total_OR,
    avg(total_DR) as total_DR,
    avg(total_REB) as total_REB,
    avg(total_AST) as total_AST,
    avg(total_BLK) as total_BLK,
    avg(total_STL) as total_STL,
    avg(total_PF) as total_PF,
    avg(total_TO) as total_TO,
    avg(total_PTS) as total_PTS,
    avg(misc_total_DBLDBL) as misc_total_DBLDBL,
    avg(misc_total_TRIDBL) as misc_total_TRIDBL,
    avg(misc_total_DQ) as misc_total_DQ,
    avg(misc_total_EJECT) as misc_total_EJECT,
    avg(misc_total_TECH) as misc_total_TECH,
    avg(misc_total_FLAG) as misc_total_FLAG,
    avg(misc_total_AST_TO) as misc_total_AST_TO,
    avg(misc_total_STL_TO) as misc_total_STL_TO,
    avg(misc_total_RAT) as misc_total_RAT,
    avg(misc_total_SCEFF) as misc_total_SCEFF,
    avg(misc_total_SHEFF) as misc_total_SHEFF
from players
group by 
    playerId,
    playerName,
    SEASON
;
--4938 records

drop table gameYearPlayer;
create table gameYearPlayer as
select  *
from    minutesTotal
left outer join playersAvgByYear
on  playersAvgByYear.playerId = minutesTotal.playerId
and playersAvgByYear.SEASON = minutesTotal.game_year;

--3158 records

drop table gameYearPlayerNotNull;
create table gameYearPlayerNotNull as
select  * 
from    gameYearPlayer
where   playerName IS NOT NULL;

--3156 records

select count(*) as players from gameYearPlayerNotNull
group by team, game_year
order by players asc;
--at least 12 records