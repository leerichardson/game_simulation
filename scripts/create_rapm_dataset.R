# Set to directory with SQLite database
############# THIS IS A LINE YOU MUST CHANGE ##########################
  setwd("C:/Users/Lee/game_simulation")

# Read in the appropriate packages. Might have to do install.packages("RSQLite") the first time 
# install.packages("RSQLite")
  library("RSQLite")                                                                                                                                                                                            
  library("plyr")
  library("dplyr")
  library("doBy")
  
# connect to the sqlite file
  con <- dbConnect(drv="SQLite", dbname="nba_rRegression_chi/nba.db")
  alltables <- dbListTables(con)

# Read in the game score and player tables 
  gs <- dbGetQuery(con, 'SELECT * FROM gameScore')
  p <- dbGetQuery(con, 'SELECT * FROM players')  

###############################################################################################
################### SHOWS HOW WE ARE GETTING DATA FROM ONE PARTICULAR GAME ####################
###############################################################################################

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
  game_train[c("PER.mean")][is.na(game_train[c("PER.mean")])] <- 15
  game_train[c("RPM.mean", "DRPM.mean", "ORPM.mean")][is.na(game_train[c("RPM.mean", "DRPM.mean", "ORPM.mean")])] <- 0  

### CONSTRUCT A WEIGHTED AVERAGE OF OFFENSIVE AND DEFENSIVE RPM FOR BOTH TEAMS ###
#   detach(package:dplyr)    
#   library(plyr)
  total_mins <- ddply(game_train, .(home), summarise, total_mins = sum(avg_MIN.mean))
  game_train <- merge(game_train, total_mins, by.x="home", by.y="home")
  game_train <- mutate(game_train, weighted_mins = avg_MIN.mean/total_mins)

## GET weighted summary stats for each team
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
#################################################################################################


###################################################################
##### LOOP THROUGH EACH MATCH ID AND ADD IN THE COVARIATE DATA ####
###################################################################

######### GET ALL THE MATCH, YEAR, AND PLAYER ID's ################
full_game_summary <- dbGetQuery(con, 'SELECT gameScore.match_id, gameScore.gameDate, gameScore.game_year, 
  gameScore.home_team, gameScore.home_team_score, gameScore.visit_team, gameScore.visit_team_score, 
  home, gameDetail.playerID, players.playerName FROM gameScore LEFT JOIN gameDetail 
  ON gameScore.match_id = gameDetail.match_id LEFT JOIN
  players ON gameDetail.playerId = players.playerId
  WHERE gameScore.game_year = players.SEASON 
  AND gameDetail.netPoints is not null')

### GET THE MATCH IDS #########
### SETTING UP A TEST QUERY ###
    match_ids <- unique(full_game_summary$match_id)
    unique(filter(full_game_summary, match_id == 311225018)$game_year)
  
    mid <- 311225018
    year <- 2011

    dbGetQuery(con, sprintf("SELECT gameScore.match_id, gameScore.gameDate, gameScore.game_year, 
    gameScore.home_team, gameScore.home_team_score, gameScore.visit_team, 
    gameScore.visit_team_score, 
    home, gameDetail.playerID, players.playerName, players.avg_MIN, players.avg_GP, 
    rpm.RPM, rpm.DRPM, rpm.ORPM, 
    rpm.PER 
    FROM gameScore LEFT JOIN gameDetail ON gameScore.match_id = gameDetail.match_id 
    LEFT JOIN players ON gameDetail.playerId = players.playerId
    LEFT JOIN rpm ON players.playerName=rpm.Player AND players.SEASON=rpm.year_ AND 
    players.team = rpm.Tm
    WHERE gameDetail.match_id = %s AND players.SEASON = %s", mid, year))


  ## CREATING EMPTY DATA FRAME ## 
  df <- data.frame(matrix(0, nrow=length(match_ids), ncol= length(final_game)))

  count = 0
  library(plyr)
  for(m in match_ids){
    count = count + 1
    year = unique(filter(full_game_summary, match_id == m)$game_year) - 1
    print(year)
    print(m)
    print(count)
    
    ### GET INFORMATION FROM THE CORRECT MATCH_ID AND YEAR ###
     gt <- dbGetQuery(con, sprintf("SELECT gameScore.match_id, gameScore.gameDate, gameScore.game_year, 
     gameScore.home_team, gameScore.home_team_score, gameScore.visit_team, gameScore.visit_team_score, 
     home, gameDetail.playerID, players.playerName, players.avg_MIN, players.avg_GP, rpm.RPM, rpm.DRPM, rpm.ORPM, 
     rpm.PER 
     FROM gameScore LEFT JOIN gameDetail ON gameScore.match_id = gameDetail.match_id 
     LEFT JOIN players ON gameDetail.playerId = players.playerId
     LEFT JOIN rpm ON players.playerName=rpm.Player AND players.SEASON=rpm.year_ AND players.team = rpm.Tm
     WHERE gameDetail.match_id = %s AND players.SEASON = %s", m, year))
 
     ### PUT THE STATS INTO THE MAIN DATAFRAME ### 
     game_train <- summaryBy(RPM + DRPM + ORPM + PER  + avg_MIN ~ match_id + gameDate + 
                               game_year + home_team + home_team_score + visit_team + 
                               visit_team_score + home + playerId + playerName, FUN=c(mean), data=gt)
   
     ### ASSIGN NULL VALUES TO 0 FOR RPM ####
     game_train[c("RPM.mean", "DRPM.mean", "ORPM.mean")][is.na(game_train[c("RPM.mean", "DRPM.mean", "ORPM.mean")])] <- 0  
    
     ## SET MISSING PER's TO 15's 
     game_train[c("PER.mean")][is.na(game_train[c("PER.mean")])] <- 15
     
     ### CONSTRUCT A WEIGHTED AVERAGE OF OFFENSIVE AND DEFENSIVE RPM FOR BOTH TEAMS ###
     total_mins <- ddply(game_train, .(home), summarise, total_mins = sum(avg_MIN.mean))
     game_train <- merge(game_train, total_mins, by.x="home", by.y="home")
     game_train <- mutate(game_train, weighted_mins = avg_MIN.mean/total_mins)
     
     ## GET weighted summary stats for each team
     weight_inputs <- summarise(group_by(game_train, home, match_id, gameDate,  
                                         game_year, home_team, home_team_score, visit_team,
                                         visit_team_score), 
                                RPM_weight = weighted.mean(RPM.mean, weighted_mins),
                                ORPM_weight = weighted.mean(ORPM.mean, weighted_mins),
                                DRPM_weight = weighted.mean(DRPM.mean, weighted_mins),
                                PER_weight = weighted.mean(PER.mean, weighted_mins)) 
     
     #### RESHAPE THE WEIGHTED GAME STATITICS INTO THE FIRST ROW ####
     final_game <- reshape(weight_inputs, timevar="home", 
                           idvar=c("match_id", "gameDate",  
                           "game_year", "home_team", "home_team_score", "visit_team",
                           "visit_team_score"), direction="wide")

    ### PUT THE FINAL GAME STATISTICS INTO THE LARGE MATRIX
    df[count,] = final_game
  }

## PUT THE COLUMN NAMES on the FILLED DF AND SAVE AS A CSV ###
  colnames(df) = names(final_game)
  write.csv(df, "C:/Users/Lee/game_simulation/scripts/rpm_dataset.csv")
  