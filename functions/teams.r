#Load all of the Necesary Packages
require(plyr)

#Read in the Dataset with all of the individual Player Data
all_seasons <- read.csv("data/all_data.csv", header=TRUE)
season_2013 <- read.csv("data/2013_season.csv", header=TRUE)
rpm_data <- read.csv("data/RPM_data.csv", header=TRUE)

#Merge the rpm data onto all of the Player Data
merged_data <- merge(all_seasons, rpm_data, by = c("Player", "year"), all.x = TRUE)

#Create the Minutes Per Game Variable
merged_data$MPG <- merged_data$MP/merged_data$G

#Create individual Player Offensive distributions
merged_data$total_pos <- merged_data$X3PA + merged_data$X2PA + .44*merged_data$FTA + merged_data$TOV
merged_data$three_dist <- merged_data$X3PA/merged_data$total_pos
merged_data$two_dist <- merged_data$X2PA/merged_data$total_pos
merged_data$ft_dist <- .44*merged_data$FTA/merged_data$total_pos
merged_data$tov_dist <- merged_data$TOV/merged_data$total_pos
merged_data <- rename(merged_data, replace=c("X3P."= "three_perc",
                                             "X2P."= "two_perc","FT."= "ft_perc",
                                             "DRB."="indv_drb","ORB."= "indv_orb", "USG."="usage"))

#Grab the names of the variables to scale, and then scale them by 100
df <- merged_data[,c("indv_orb", "indv_drb", "TRB.", "AST.", "STL.", "BLK.", "TOV.", "usage")]
for(i in names(df)){
  merged_data[[i]] <- merged_data[[i]]/100
}

#Set up the Dataset where all Game's will pull from
write.csv(merged_data, file = "data/input_data.csv")

#Create a team that represents the 2014 Lakers and 2014 Heat
team1 <- "LAL"
team2 <- "MIA"
year_of_game <- 2013

team1 <- subset(merged_data, Tm == team1 & year == year_of_game & MP >= 500)
totals_min <- sum(team1$MPG)
team1$possession_probability <- team1$MPG/totals_min
possession_five_team1 <- team1[sample(nrow(team1), size=5, prob=team1$possession_probability),]

team2 <- subset(merged_data, Tm == team2 & year == year_of_game & MP >= 500)
totals_min <- sum(team2$MPG)
team2$possession_probability <- team2$MPG/totals_min
possession_five_team2 <- team2[sample(nrow(team2), size=5, prob=team2$possession_probability),]

#Create a dataset of just the individual teams and order the players by minutes played
# lakers <- subset(season_2013, Tm == "LAL")
# lakers_ordered <- lakers[order(lakers[,"MP"], decreasing=TRUE),]
# heat <- subset(season_2013, Tm == "MIA")
# heat_ordered <- heat[order(heat[,"MP"], decreasing=TRUE),]
# rm(lakers, heat)
# 
# Sort the teams by the top 5 players
# lakers_five <- lakers_ordered[1:5,]
# heat_five <- heat_ordered[1:5,]

# #Keep only the inputs that will matter in the game 
# lakers_input <- possession_five_team1[,c("Player", "three_perc", "two_perc", "ft_perc", 
#                               "usage", "indv_drb", "indv_orb", "three_dist", 
#                                 "two_dist", "ft_dist", "tov_dist")]
# heat_input <- possession_five_team2[,c("Player", "three_perc", "two_perc", "ft_perc", 
#                            "usage", "indv_drb", "indv_orb", "three_dist", 
#                             "two_dist", "ft_dist", "tov_dist")]


