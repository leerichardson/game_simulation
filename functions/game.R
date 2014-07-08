#Read in all of the functions that will be needed for the game
source("functions/teams.R")
source("functions/two_point_shot.R")
source("functions/determine_event.R")
source("functions/determine_player.R")
source("functions/free_throw.R")
source("functions/rebound.R")
source("functions/three_point_shot.R")
source("functions/possession.R")

#Read in the input data which sets the parameters for the game 
team1 <- lakers_input
team2 <- heat_input

#Generate home and away team's rebounding percentages
team1_oreb <- sum(team1[,"indv_orb"])
team1_dreb <- sum(team1[,"indv_drb"])
team2_oreb <- sum(team2[,"indv_orb"])
team2_dreb <- sum(team2[,"indv_drb"])

#Initialize the Box Score to all 0's
box_score <- as.data.frame(matrix(0, nrow=9, ncol=10))

#Name the data frame that will be collecting all of the results
colnames(box_score) <- c("team1_1", "team1_2", "team1_3", "team1_4", "team1_5", 
                         "team2_1", "team2_2", "team2_3", "team2_4", "team2_5")
rownames(box_score) <- c("2M", "2A", "3M", "3A", "FTM", "FTA", "TO", "OREB", "DREB")

#Determine the number of possessions
num_pos <- 100

#Simulate Home Team's Possessions
for(i in 1:num_pos) {
  #Set the team and team name (for the box score iteration) in the Global Environment
  team <- team1
  team_name <- "team1"
    
  #The Start of the possession triggers from determining which player will use the possession
  #Determine which Player will use the possession based on Individual Usage Rates
  determine_player(team[1,"usage"], team[2,"usage"], team[3,"usage"], team[4,"usage"], team[5,"usage"])
}

#Simulate Away Team's Possessions
for(i in 1:num_pos) {
  #Set the team and team name (for the box score iteration) in the Global Environment
  team <- team2
  team_name <- "team2"
  
  #Determine which Player will use the possession based on Individual Usage Rates  
  determine_player(team2[1,"usage"], team2[2,"usage"], team2[3,"usage"], team2[4,"usage"], team2[5,"usage"])
}





