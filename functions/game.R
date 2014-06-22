#Read in the Teams Dataset
source("teams.R")

#Initialize the Box Score to all 0's
box_score <- as.data.frame(matrix(0, nrow=9, ncol=10))

#Name the data frame that will be collecting all of the results
colnames(box_score) <- c("HP1", "HP2", "HP3", "HP4", "HP5", "AP1", "AP2", "AP3", "AP4", "AP5")
rownames(box_score) <- c("2M", "2A", "3M", "3A", "FTM", "FTA", "TO", "OREB", "DREB")

#Read in the input data which sets the parameters for the game 
team1 <- lakers_input
team2 <- heat_input

#Generate home and away team's rebounding percentages
team1_oreb <- sum(team1[,"ORB."])
team1_dreb <-sum(team1[,"DRB."])
team2_oreb <- sum(team2[,"ORB."])
team2_dreb <-sum(team2[,"DRB."])

#Determine the number of possessions
num_pos <- 100

#Simulate Home Team's Possessions

#Simulate Away Team's Possessions


