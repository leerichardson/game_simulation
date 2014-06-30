#Read in all of the functions that will be needed for the game
source("functions/teams.R")
source("functions/two_point_shot.R")
source("functions/determine_event.R")
source("functions/determine_player.R")
source("functions/free_throw.R")
source("functions/rebound.R")
source("functions/three_point_shot.R")
source("functions/possession.R")

#Initialize the Box Score to all 0's
box_score <- as.data.frame(matrix(0, nrow=9, ncol=10))

#Name the data frame that will be collecting all of the results
colnames(box_score) <- c("team1_p1", "team1_p2", "team1_p3", "team1_p4", "team1_p5", 
                         "team2_p1", "team2_p2", "team2_p3", "team2_p4", "team2_p5")
rownames(box_score) <- c("2M", "2A", "3M", "3A", "FTM", "FTA", "TO", "OREB", "DREB")

#Read in the input data which sets the parameters for the game 
team1 <- lakers_input
team2 <- heat_input

#Generate home and away team's rebounding percentages
team1_oreb <- sum(team1[,"indv_orb"])
team1_dreb <- sum(team1[,"indv_drb"])
team2_oreb <- sum(team2[,"indv_orb"])
team2_dreb <- sum(team2[,"indv_drb"])

#Determine the number of possessions
num_pos <- 20

#Simulate Home Team's Possessions
for(i in 1:num_pos) {
  
  #The Start of the possession triggers from determining which player will use the possession
  #Determine which Player will use the possession based on Individual Usage Rates
  determine_player(team1, team1[1,"usage"], team1[2,"usage"], team1[3,"usage"], team1[4,"usage"], team1[5,"usage"])
}

#Simulate Away Team's Possessions
for(i in 1:num_pos) {
  
  #Determine which Player will use the possession based on Individual Usage Rates  
  determine_player(team2, team2[1,"usage"], team2[2,"usage"], team2[3,"usage"], team2[4,"usage"], team2[5,"usage"])
}





