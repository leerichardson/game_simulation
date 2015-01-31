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
train = filter(data, game_year %in% c(2008, 2009, 2010, 2011, 2012))
test = filter(data, game_year == 2013)

xtest = test[,9:17]
ytest = test[,18]
xtrain = train[,9:17]
ytrain = train[,18]

## Logistic regression to get probabilities
mylogit <- glm(homeWin ~ RPM_weight.0 + ORPM_weight.0 + DRPM_weight.0 + PER_weight.0 + 
                 RPM_weight.1 + ORPM_weight.1 + DRPM_weight.1 + PER_weight.1 + home, data=train,
               family = "binomial")
logit_preds <- as.data.frame(predict(mylogit, newdata=xtest, type="response"))
logit_preds$class <- ifelse(logit_preds[,1] >= .5, 1, 0)
logit_preds <- cbind(logit_preds, ytest)
logit_preds$result <- abs(logit_preds[,2] - logit_preds[,3])
logit_probs <- cbind(test, logit_preds)[, c(2:8, 17:22)]
names(logit_probs)[10] = "home_prob"

##Create the dataset for simulation
num_seasons <- 1000
season_df <- data.frame(matrix(0, nrow=length(unique(logit_probs$home_team)), ncol= num_seasons))
row.names(season_df) <- unique(logit_probs$home_team)
colnames(season_df) = paste("season_", 1:1000, sep="")

## Get the unique match Id's for a given season
match_ids <- unique(logit_probs$match_id)

### Loop through each Season
for(i in 1:1000){
  print(paste("season", i))
  
  ## Generate the random outcomes
  random_outcomes <- runif(length(logit_probs[,1]))
  logit_probs <- cbind(logit_probs, random_outcomes)
  
  ## Loop through each match ID
  for(match in match_ids){
    
    # Using the random number, assign the winner of the game to the data frame
    if(logit_probs[logit_probs$match_id == match,]$random_outcomes <= logit_probs[logit_probs$match_id == match,]$home_prob){
      ## Iterate the season data frame for the Home Team
      season_df[as.character(logit_probs[logit_probs$match_id == match,]$home_team), i] = season_df[as.character(logit_probs[logit_probs$match_id == match,]$home_team), i] + 1
    } 
    else{
      season_df[as.character(logit_probs[logit_probs$match_id == match,]$visit_team), i] = season_df[as.character(logit_probs[logit_probs$match_id == match,]$visit_team), i] + 1
    } 
  }
  ## Remove the random outcomes
  logit_probs <- logit_probs[,-14]
}

### Check out the results 
means <- apply(season_df, 1, mean) 
ses <- apply(season_df, 1, sd)

## Save the outcomes 
write.csv(season_df, "scripts/sim_2013_logit_df.csv")
write.csv(cbind(means, ses), "scripts/sim_2013_logit.csv")
