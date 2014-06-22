#Read in the Dataset with all of the individual Player Data
season_2013 <- read.csv("C:/Users/leeri_000/basketball_stats/game_simulation/data/2013_season.csv", header=TRUE)
attach(season_2013)

#Create individual Player Offensive distributions
total_pos <- X3PA + X2PA + .44*FTA + TOV
three_dist <- X3PA/total_pos
two_dist <- X2PA/total_pos
ft_dist <- .44*FTA/total_pos
tov_dist <- TOV/total_pos
season_2013 <- cbind(season_2013, total_pos, three_dist, two_dist, ft_dist, tov_dist)
game_inputs <- season_2013[,c("MP", "")]


#Create a dataset of just the individual teams and order the players by minutes played
lakers <- subset(season_2013, Tm == "LAL")
lakers_ordered <- lakers[order(lakers[,"MP"], decreasing=TRUE),]
heat <- subset(season_2013, Tm == "MIA")
heat_ordered <- heat[order(heat[,"MP"], decreasing=TRUE),]

#Sort the teams by the top 5 players
lakers_five <- lakers_ordered[1:5,]
heat_five <- heat_ordered[1:5,]

#Keep only the inputs that will matter in the game 
lakers_input <- lakers_five[,c("Player", "X3P.", "X2P.", "FT.", "USG.", "DRB.", "ORB.", "three_dist", "two_dist", "ft_dist", "tov_dist")]
heat_input <- heat_five[,c("Player", "X3P.", "X2P.", "FT.", "USG.", "DRB.", "ORB.", "three_dist", "two_dist", "ft_dist", "tov_dist")]







