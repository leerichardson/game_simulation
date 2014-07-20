#Load all of the Necesary Packages
require(plyr)

#Read in the Dataset with all of the individual Player Data
all_seasons <- read.csv("data/all_data.csv", header=TRUE)
season_2013 <- read.csv("data/2013_season.csv", header=TRUE)

#Create the Minutes Per Game Variable
all_seasons$MPG <- all_seasons$MP/all_seasons$G

#Create individual Player Offensive distributions
all_seasons$total_pos <- all_seasons$X3PA + all_seasons$X2PA + .44*all_seasons$FTA + all_seasons$TOV
all_seasons$three_dist <- all_seasons$X3PA/all_seasons$total_pos
all_seasons$two_dist <- all_seasons$X2PA/all_seasons$total_pos
all_seasons$ft_dist <- .44*all_seasons$FTA/all_seasons$total_pos
all_seasons$tov_dist <- all_seasons$TOV/all_seasons$total_pos
all_seasons <- rename(all_seasons, replace=c("X3P."= "three_perc",
                                             "X2P."= "two_perc","FT."= "ft_perc",
                                             "DRB."="indv_drb","ORB."= "indv_orb", "USG."="usage"))

#Scale the Oreb, Dreb, and Usage rate percentages to one
#season_2013[,"indv_orb"] = season_2013[,"indv_orb"]/100
#season_2013[,"indv_drb"] = season_2013[,"indv_drb"]/100
#season_2013[,"usage"] = season_2013[,"usage"]/100

#Create individual Player Offensive distributions
#total_pos <- X3PA + X2PA + .44*FTA + TOV
#three_dist <- X3PA/total_pos
#two_dist <- X2PA/total_pos
#ft_dist <- .44*FTA/total_pos
#tov_dist <- TOV/total_pos
#season_2013 <- cbind(season_2013, total_pos, three_dist, two_dist, ft_dist, tov_dist)
#season_2013 <- rename(season_2013, replace=c("X3P."= "three_perc",
#                                             "X2P."= "two_perc","FT."= "ft_perc",
#                                             "DRB."="indv_drb","ORB."= "indv_orb", "USG."="usage"))

#Scale the Oreb, Dreb, and Usage rate Percentages by 100 
#season_2013[,"indv_orb"] = season_2013[,"indv_orb"]/100
#season_2013[,"indv_drb"] = season_2013[,"indv_drb"]/100
#season_2013[,"usage"] = season_2013[,"usage"]/100

#Grab the names of the variables to scale, and then scale them by 100
df <- all_seasons[,c("indv_orb", "indv_drb", "TRB.", "AST.", "STL.", "BLK.", "TOV.", "usage")]
for(i in names(df)){
  all_seasons[[i]] <- all_seasons[[i]]/100
}

#Create a team that represents the 2014 Lakers and 2014 Heat
team1 <- "LAL"
team2 <- "MIA"
year_of_game <- 2013

team1 <- subset(all_seasons, Tm == team1 & year == year_of_game & MP >= 500)
totals_min <- sum(team1$MPG)
team1$possession_probability <- team1$MPG/totals_min
possession_five_team1 <- team1[sample(nrow(team1), size=5, prob=team1$possession_probability),]

team2 <- subset(all_seasons, Tm == team2 & year == year_of_game & MP >= 500)
totals_min <- sum(team2$MPG)
team2$possession_probability <- team2$MPG/totals_min
possession_five_team2 <- team2[sample(nrow(team2), size=5, prob=team2$possession_probability),]


#Create a dataset of just the individual teams and order the players by minutes played
#lakers <- subset(season_2013, Tm == "LAL")
#lakers_ordered <- lakers[order(lakers[,"MP"], decreasing=TRUE),]
#heat <- subset(season_2013, Tm == "MIA")
#heat_ordered <- heat[order(heat[,"MP"], decreasing=TRUE),]
#rm(lakers, heat)

#Sort the teams by the top 5 players
#lakers_five <- lakers_ordered[1:5,]
#heat_five <- heat_ordered[1:5,]

#Keep only the inputs that will matter in the game 
#lakers_input <- lakers_five[,c("Player", "three_perc", "two_perc", "ft_perc", 
                 #              "usage", "indv_drb", "indv_orb", "three_dist", 
                 #               "two_dist", "ft_dist", "tov_dist")]
#heat_input <- heat_five[,c("Player", "three_perc", "two_perc", "ft_perc", 
                 #          "usage", "indv_drb", "indv_orb", "three_dist", 
                 #           "two_dist", "ft_dist", "tov_dist")]


