.headers on
.mode csv
.output gameScore_rates.csv
select * from gameScore_rates;

alter table gameScore add homeWin integer;
update  gameScore 
set     homeWin = case when (home_team_score>visit_team_score) then 1 else 0 end;

alter table gameScore add column scoreDiff integer;
update gameScore set scoreDiff = home_team_score - visit_team_score;



drop table prevYearWinRate;
create table prevYearWinRate as
select  home_team, 
        game_year+1 as game_year,
        sum(homeWin)*1.0/count(home_team) as homeWinRatePrevYear,
from    gameScore
group by    home_team, game_year;

drop table prevYearWinRate_homeVisit;
create table prevYearWinRate_homeVisit as
select  home_team,
        visit_team,
        game_year+1 as game_year,
        sum(homeWin)*1.0/count(home_team) as homeWinRatePrevYear_homeVisit
from    gameScore
group by    home_team,visit_team, game_year;


drop table scoreDiffHome;
create table scoreDiffHome as
select  game_year+1 as game_year,
        avg(scoreDiff) as avg_scoreDiff_home,
        avg(homeWin) as avg_win_home,
        home_team
from    gameScore
group by game_year, home_team;

drop table scoreDiffVisit;
create table scoreDiffVisit as
select  game_year+1 as game_year,
        -avg(scoreDiff) as avg_scoreDiff_visit,
        1-avg(homeWin) as avg_win_visit,
        visit_team
from    gameScore
group by game_year, visit_team;

drop table scoreDiffPerGame;
create table scoreDiffPerGame as
select  game_year+1 as game_year, 
        avg(scoreDiff) as avg_scoreDiff,
        avg(homeWin) as avg_homeWin,
        home_team, 
        visit_team
from    gameScore
group by game_year, home_team, visit_team;


drop table regTable_scoreDiff;
create table regTable_scoreDiff as
select * from rpmReg
left outer join scoreDiffPerGame
on  rpmReg.game_year = scoreDiffPerGame.game_year
and rpmReg.home_team = scoreDiffPerGame.home_team
and rpmReg.visit_team = scoreDiffPerGame.visit_team;

drop table regTable_home;
create table regTable_home as
select * from regTable_scoreDiff
left outer join scoreDiffHome
on  regTable_scoreDiff.game_year = scoreDiffHome.game_year
and regTable_scoreDiff.home_team = scoreDiffHome.home_team;

drop table regTable_visit;
create table regTable_visit as
select * from regTable_home
left outer join scoreDiffVisit
on  regTable_home.game_year = scoreDiffVisit.game_year
and regTable_home.visit_team = scoreDiffVisit.visit_team;


.read gameScore_rates.sql

alter table gameScore_rates add homeWin integer;
update gameScore_rates set homeWin = case when (home_team_score>visit_team_score) then 1 else 0 end;
update gameScore_rates set avg_scoreDiff = 3.05 where avg_scoreDiff is null;
update gameScore_rates set avg_homeWin = 0.6 where avg_homeWin is null;
update gameScore_rates set avg_scoreDiff_home = 3.03 where avg_scoreDiff_home is null;
update gameScore_rates set avg_win_home = 0.6 where avg_win_home is null;
update gameScore_rates set avg_scoreDiff_visit = -3.03 where avg_scoreDiff_visit is null;
update gameScore_rates set avg_win_visit = 0.4 where avg_win_visit is null;



