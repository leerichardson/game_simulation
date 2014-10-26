# The purpose of this script is to demo how to use R with the newly formed SQLite database
# and show how it can be used in future algorithms 

# Set to directory with SQLite database
############# THIS IS A LINE YOU MUST CHANGE ##########################
setwd("C:/Users/Lee/game_simulation/data/nba")

# Read in the appropriate packages. Might have to do install.packages("RSQLite") the first time 
# install.packages("RSQLite")
library("RSQLite")
library("dplyr")

# connect to the sqlite file
con <- dbConnect(drv="SQLite", dbname="nba.db")

# get a list of all tables
alltables <- dbListTables(con)

rpm <- dbGetQuery(con,'SELECT * FROM rpm')

#Pulling a team/year
houston_2013 <- dbGetQuery(con,'SELECT * FROM rpm WHERE year_=2013 AND Tm LIKE "hou"')
teams <- dbGetQuery(con, 'SELECT * FROM teams')
game_score <- dbGetQuery(con, 'SELECT * FROM gameScore')
espn_player <- dbGetQuery(con,'SELECT * FROM players')

#Merge on Player name
player_rpm_merge <- dbGetQuery(con,'SELECT * FROM rpm LEFT JOIN players ON 
                               players.playerName=rpm.Player AND players.SEASON=rpm.year_
                               AND players.team = rpm.Tm')

#Pulling a specific player, Graphing his EPM over the years
kobe <- dbGetQuery(con,'SELECT * FROM rpm LEFT JOIN players ON 
                               players.playerName=rpm.Player AND players.SEASON=rpm.year_
                               AND players.team = rpm.Tm WHERE playerName = "Kobe Bryant"')
plot(kobe$year, kobe$RPM)

#Checking the unmerged player-RPM columns
fully_filled <- filter(player_rpm_merge, complete.cases(player_rpm_merge))

# 8 Teams to fix: bkn-brk, gsw-gs, nyk-ny, phx-pho, sas-sa, uta-utah, was-wsh, nop-no

