# Set to directory with SQLite database
############# THIS IS A LINE YOU MUST CHANGE ##########################
setwd("C:/Users/Lee/game_simulation/data/nba")

# Read in the appropriate packages. Might have to do install.packages("RSQLite") the first time 
# install.packages("RSQLite")
library("RSQLite")                                                                                                                                                                                            
library("plyr")
library("dplyr")
library("doBy")

# connect to the sqlite file
con <- dbConnect(drv="SQLite", dbname="nba.db")

alltables <- dbListTables(con)

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
game_train <- dbGetQuery(con, 'SELECT gameScore.match_id, gameScore.gameDate, gameScore.game_year, 
    gameScore.home_team, gameScore.home_team_score, gameScore.visit_team, gameScore.visit_team_score, 
    home, gameDetail.playerID, players.playerName, players.avg_MIN, players.avg_GP, rpm.RPM, rpm.DRPM, rpm.ORPM, 
    rpm.PER 
    FROM gameScore LEFT JOIN gameDetail ON gameScore.match_id = gameDetail.match_id 
    LEFT JOIN players ON gameDetail.playerId = players.playerId
    LEFT JOIN rpm ON players.playerName=rpm.Player AND players.SEASON=rpm.year_ AND players.team = rpm.Tm
    WHERE gameDetail.match_id = 311225018 AND players.SEASON = 2011')

#### COMBINE DUPLICATED PLAYERS ####
  game_train <- summaryBy(RPM + DRPM + ORPM + PER  + avg_MIN ~ match_id + gameDate + 
      game_year + home_team + home_team_score + visit_team + 
      visit_team_score + home + playerId + playerName, FUN=c(mean), data=game_train)

### ASSIGN NULL VALUES TO 0 FOR RPM ####
  game_train[is.na(game_train)] <- 0

### CONSTRUCT A WEIGHTED AVERAGE OF OFFENSIVE AND DEFENSIVE RPM FOR BOTH TEAMS ###
  total_mins <- ddply(game_train, .(home), summarise, total_mins = sum(avg_MIN.mean))
  game_train <- merge(game_train, total_mins, by.x="home", by.y="home")
  game_train <- mutate(game_train, weighted_mins = avg_MIN.mean/total_mins)

  weight_inputs <- summarise(group_by(game_train, home, match_id, gameDate,  
                                        game_year, home_team, home_team_score, visit_team,
                                        visit_team_score), 
                             RPM_weight = weighted.mean(RPM.mean, weighted_mins),
                             ORPM_weight = weighted.mean(ORPM.mean, weighted_mins),
                             DRPM_weight = weighted.mean(DRPM.mean, weighted_mins),
                             PER_weight = weighted.mean(PER.mean, weighted_mins))

#### COMBINE THE WEIGHTED GAME STATITICS INTO THE FIRST ROW ####
  final_game <- reshape(weight_inputs, timevar="home", idvar=c("match_id", "gameDate",  
                                                 "game_year", "home_team", "home_team_score", "visit_team",
                                                 "visit_team_score"), direction="wide")





