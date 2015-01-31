

drop table gameDetail;

create table gameDetail
(
    match_id varchar(10),
    home integer,
    playerId varchar(10),
    minutes integer,
    FG_made integer,
    FG_attempted integer,
    ThreeP_made integer,
    ThreeP_attempted integer,
    FT_made integer,
    FT_attempted integer,
    OREB integer,
    DREB integer,
    REB integer,
    AST integer,
    STL integer,
    BLK integer,
    turnovers integer,
    PF integer,
    netPoints integer,
    PTS integer,
    PRIMARY KEY(match_id,playerId)
);


drop table players;

create table players(
    playerId varchar(10), 
    playerName varchar(50), #"Player" in RPM
    SEASON integer, #"year" in RPM
    team varchar(10),
    avg_GP integer,
    avg_GS integer,
    avg_MIN float,
    avg_FG_made float,
    avg_FG_attempted float,
    avg_FGpercent float,
    avg_ThreeP_made float,
    avg_ThreeP_attempted float,
    avg_ThreePpercent float,
    avg_FT_made float,
    avg_FT_attempted float,
    avg_FTpercent float,
    avg_OR float,
    avg_DR float,
    avg_REB float,
    avg_AST float,
    avg_BLK float,
    avg_STL float,
    avg_PF float,
    avg_TO float,
    avg_PTS float,
    total_FG_made integer,
    total_FG_attempted integer,
    total_FGpercent float,
    total_ThreeP_made integer,
    total_ThreeP_attempted integer,
    total_ThreePpercent float,
    total_FT_made integer,
    total_FT_attempted integer,
    total_FTpercent float,
    total_OR float,
    total_DR integer,
    total_REB integer,
    total_AST integer,
    total_BLK integer,
    total_STL integer,
    total_PF integer,
    total_TO integer,
    total_PTS integer,
    misc_total_DBLDBL integer,
    misc_total_TRIDBL integer,
    misc_total_DQ integer,
    misc_total_EJECT integer,
    misc_total_TECH integer,
    misc_total_FLAG integer,
    misc_total_AST_TO float,
    misc_total_STL_TO float,
    misc_total_RAT float,
    misc_total_SCEFF float,
    misc_total_SHEFF float,
    PRIMARY KEY(playerId,SEASON,team)
);


drop table teams;
create table teams
(
    team varchar(10) primary key,
    fullName varchar(50)
);


drop table gameScore;
create table gameScore
(
match_id varchar(10) primary key,
gameDate varchar(10),
home_team varchar(10),
home_team_score integer,
visit_team varchar(10),
visit_team_score integer,
game_year integer
);


select * from sqlite_master where type="table";