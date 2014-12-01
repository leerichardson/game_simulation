#########################################################################
## Purpose: Using probabilities for each game result, simulate the season
## to compute a distribution of wins ####################################
#########################################################################

## SET WORKING DIRCTORY ##
setwd("C:/Users/leeri_000/basketball_stats/game_simulation")

## LIBRARIES
library("dplyr")
library("e1071")

## READ IN OUR FEATURE DATASETS
data <- read.csv("scripts/rpm_dataset.csv")

## ADD home feature and win/loss column
data <- mutate(data, home = 1)
data$homeWin <- ifelse(data$home_team_score > data$visit_team_score, 1, 0)

## Set up datasets ##   
years <- c(2008, 2009, 2010, 2011, 2012, 2013)
train = filter(data, game_year %in% c(2008, 2009, 2010, 2011))
test = filter(data, game_year == 2012)

xtest = test[,9:17]
ytest = test[,18]
xtrain = train[,9:17]
ytrain = train[,18]

## Naive Bayes to get probabilities
model <- naiveBayes(xtrain, ytrain)
preds <- as.data.frame(predict(model, xtest, type = c("raw"), threshold = 0.001))
preds$class <- ifelse(preds[,2] > preds[,1], 1, 0)
preds <- cbind(preds, ytest)

## Save dataset with the correct probabilities
probs <- cbind(test, preds)[, c(2:8, 17:22)]

## Rename home and away columns
names(probs)[names(probs) == "0"] <- "away_prob"
names(probs)[names(probs) == "1"] <- "home_prob"

##Create the dataset for simulation
num_seasons <- 1000
season_df <- data.frame(matrix(0, nrow=length(unique(probs$home_team)), ncol= num_seasons))
row.names(season_df) <- unique(probs$home_team)
colnames(season_df) = paste("season_", 1:1000, sep="")

## Get the unique match Id's for a given season
match_ids <- unique(probs$match_id)

## Get random number for each_row
random_outcomes <- runif(length(probs[,1]))
probs <- cbind(probs, random_outcomes)

## Loop through each season
for(i in 1:1000){

  print(paste("season", i))

  ## Loop through each match and probability of a season
  for(match in match_ids){

    # Generate uniform random number
    res <- runif(1)
    
    # Pull the relevant game 
    game <- probs[probs$match_id == match,]
    
    # Using the random number, assign the winner of the game to the data frame
    if(res <= game$away_prob){
      ## Iterate the season data frame for the away team

      season_df[as.character(game$visit_team), i] = season_df[as.character(game$visit_team), i] + 1
      
    } else{
      season_df[as.character(game$home_team), i] = season_df[as.character(game$home_team), i] + 1
    } 
  }
}

### Check out the results 
  means <- apply(season_df, 1, mean) 
  ses <- apply(season_df, 1, sd)

## Save the outcomes 
  write.csv(cbind(means, ses), "scripts/sim_2012.csv")





