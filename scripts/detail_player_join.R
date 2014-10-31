# Set to directory with SQLite database
############# THIS IS A LINE YOU MUST CHANGE ##########################
setwd("C:/Users/Lee/game_simulation/data/nba")

# Read in the appropriate packages. Might have to do install.packages("RSQLite") the first time 
# install.packages("RSQLite")
library("RSQLite")
library("dplyr")

# connect to the sqlite file
con <- dbConnect(drv="SQLite", dbname="nba.db")

# Inspect RPM and ESPN player's in 2009
player_rpm_merge <- dbGetQuery(con,'SELECT * FROM players LEFT JOIN rpm ON 
                               players.playerName=rpm.Player AND players.SEASON=rpm.year_
                               AND players.team = rpm.Tm')

#Pulling the relevant columns 
player_inputs <- select(player_rpm_merge, playerId, playerName, SEASON, Tm, MPG, PER)
filter(player_inputs, !complete.cases(player_inputs))

######### CONSTRUCT THE X TEST DATASET ###############

full_game_summary <- dbGetQuery(con, 'SELECT gameScore.match_id, gameScore.gameDate, gameScore.game_year, 
gameScore.home_team, gameScore.home_team_score, gameScore.visit_team, gameScore.visit_team_score, 
home, gameDetail.playerID, players.playerName FROM gameScore LEFT JOIN gameDetail 
                                ON gameScore.match_id = gameDetail.match_id LEFT JOIN
                                players ON gameDetail.playerId = players.playerId
                                WHERE gameScore.game_year = players.SEASON 
                                AND gameDetail.netPoints is not null')

#### TEST PULLING DATA FROM PREVIOUS YEAR ###########
game_train <- dbGetQuery(con, 'SELECT * FROM gameScore LEFT JOIN gameDetail 
    ON gameScore.match_id = gameDetail.match_id LEFT JOIN players ON gameDetail.playerId = players.playerId
    WHERE gameDetail.match_id = 311225018 AND players.SEASON = ')

