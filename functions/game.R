game <- function(team_one, team_two, year_one, year_two) {
  
  #Read in all of the functions that will be needed for the game
  #source("functions/teams.R")
  source("functions/determine_event.R")
  source("functions/determine_player.R")
  source("functions/free_throw.R")
  source("functions/two_point_shot.R")
  source("functions/three_point_shot.R")
  source("functions/rebound.R")
  source("functions/determine_rebounder.R")
  
  #Using inputs, read in the players who will be on each team
  team1 <- subset(merged_data, Tm == team_one & year == year_one & MP >= 500)
  team2 <- subset(merged_data, Tm == team_two & year == year_two & MP >= 500)
  
  #Based on the number of players on each team, count how many players will be in the box score
  num_rows <- nrow(team1) + nrow(team2)
  print(c(team1$Player, team2$Player))
  
  #Initialize the Box Score to all 0's
  box_score <- as.data.frame(matrix(0, nrow=num_rows, ncol=10))
  
#   #Name the data frame that will be collecting all of the results
#   colnames(box_score) <- c("team1_1", "team1_2", "team1_3", "team1_4", "team1_5", 
#                            "team2_1", "team2_2", "team2_3", "team2_4", "team2_5")
#   rownames(box_score) <- c("2M", "2A", "3M", "3A", "FTM", "FTA", "TO", "OREB", "DREB")  
#   totals_min <- sum(team1$MPG)
#   team1$possession_probability <- team1$MPG/totals_min
#   possession_five_team1 <- team1[sample(nrow(team1), size=5, prob=team1$possession_probability),]
}

#Testing the game
game("LAL", "MIA", 2013, 2013)



#Read in all of the functions that will be needed for the game
source("functions/teams.R")
source("functions/two_point_shot.R")
source("functions/determine_event.R")
source("functions/determine_player.R")
source("functions/free_throw.R")
source("functions/rebound.R")
source("functions/three_point_shot.R")
source("functions/determine_rebounder.R")

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
num_pos <- 90

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









