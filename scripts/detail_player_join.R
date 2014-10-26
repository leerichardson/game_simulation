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
                               AND players.team = rpm.Tm WHERE players.SEASON = 2009')

espn_2009 <- dbGetQuery(con, 'SELECT * FROM players WHERE SEASON = 2009')
rpm_2009 <- dbGetQuery(con, 'SELECT * FROM rpm WHERE year_ = 2009 AND Player LIKE "%Alston%"')
full_cases <- filter(player_rpm_merge, complete.cases(player_rpm_merge))

############## RPM AND ESPN ARE OFF BY ONE YEAR ################################

full_game_summary <- dbGetQuery(con, 'SELECT * FROM gameScore LEFT JOIN gameDetail 
                                ON gameScore.match_id = gameDetail.match_id LEFT JOIN
                                players ON gameDetail.playerId = players.playerId
                                WHERE gameScore.game_year = players.SEASON')
