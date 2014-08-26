#########################################################################################
## CLEAN THE DATA SCRAPED FROM THE WEB AND SAVE IT INTO A CSV ###########################
#########################################################################################

#Load all of the Necesary Packages
require(plyr)
require(dplyr)

#Read in the Dataset with all of the individual Player Data
all_seasons <- read.csv("data/all_data.csv", header=TRUE)
season_2013 <- read.csv("data/2013_season.csv", header=TRUE)
rpm_data <- read.csv("data/RPM_data.csv", header=TRUE)

#Merge the rpm data onto all of the Player Data
merged_data <- merge(all_seasons, rpm_data, by = c("Player", "year"), all.x = TRUE)

#Remove the double Merges which happened because player sin the same year have the same name :0
dup_test <- select(merged_data, Player, year, Tm)
possesssion_comparison <- select(merged_data, Player, year, Tm, G, MP, Possessions, RPM)
possesssion_comparison[(duplicated(dup_test, fromLast = FALSE) == TRUE | duplicated(dup_test, fromLast = TRUE)),]

#Based on these results, drop the rows that merged incorrectly. Then Remove the Incorrect
merged_data_clean <- merged_data[-c(3540, 3541, 3548, 3549, 3551, 3553, 15580, 15583),]

#Create new COlumns for Minutes Per Game, and all of the necessary columns for Individual Player Distributions. 
merged_data_clean <- mutate(merged_data_clean, 
                            MPG = MP/G, 
                            indv_possession = X3PA + X2PA + .44*FTA + TOV,
                            three_dist = X3PA/indv_possession,
                            two_dist = X2PA/indv_possession,
                            ft_dist = (.44*FTA)/indv_possession,
                            tov_dist = TOV/indv_possession,)

 merged_data_clean <- rename(merged_data_clean, replace=c("X3P."= "three_perc",
                                              "X2P."= "two_perc","FT."= "ft_perc",
                                              "DRB."="indv_drb","ORB."= "indv_orb", 
                                              "USG."="usage", "Possessions" = "team_possession"))

#Grab the names of the variables to scale, and then scale them by 100
df <- merged_data_clean[,c("indv_orb", "indv_drb", "TRB.", "AST.", "STL.", "BLK.", "TOV.", "usage")]
for(i in names(df)){
  merged_data_clean[[i]] <- merged_data_clean[[i]]/100
}

#Drop the unnecessary Vatiables and write the CSV to a file in the Data directory!
dataset_revised <- select(merged_data_clean, -X.x, -X.y, -Rk)
write.csv(dataset_revised, file = "data/input_data.csv")

######################################################################################################
## THE END! ##########################################################################################
######################################################################################################



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


