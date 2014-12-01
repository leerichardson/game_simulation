## Purpose: Compare simulated season to actual results for 2012 and 2013 
library(dplyr)

## SET WORKING DIRCTORY ##
setwd("C:/Users/leeri_000/basketball_stats/game_simulation")

## Get dataset with the results 
results <- read.csv("data/espn_data/team_wins.csv")[,2:4]

############################################################
################# 2013 LOGIT ###############################
############################################################
## Get 2013 Results 
results_2013 <- filter(results, year == 2013)
results_2013_sorted <- results_2013[order(results_2013$team),]

## Get the dataset with simulation output for 2013
simulation <- read.csv("scripts/sim_2013.csv")
sim_sort <- simulation[order(simulation$X),]

## Get comparison dataframe and mean and absolute error losses
compare <- cbind(results_2013_sorted, sim_sort)
compare$squared <- (compare$means - compare$wins)^2
rmse <- sqrt(mean(compare$squared))
rmse

compare$absolute <- abs(compare$means - compare$wins)
mae <- mean(compare$absolute)
mae


############################################################
################# 2013 NAIVE BAYES##########################
############################################################

## Get 2013 Results 
results_2013 <- filter(results, year == 2013)
results_2013_sorted <- results_2013[order(results_2013$team),]

## Get the dataset with simulation output for 2013
simulation <- read.csv("scripts/sim_2013.csv")
sim_sort <- simulation[order(simulation$X),]
                       
## Get comparison dataframe and mean and absolute error losses
compare <- cbind(results_2013_sorted, sim_sort)
compare$squared <- (compare$means - compare$wins)^2
rmse <- sqrt(mean(compare$squared))
rmse

compare$absolute <- abs(compare$means - compare$wins)
mae <- mean(compare$absolute)
mae

#######################################################
################# 2012 LOGIT ##########################
#######################################################

## Get 2012 results 
results_2012 <- filter(results, year == 2012)
results_2012_sorted <- results_2012[order(results_2012$team),]

## Get the dataset with simulation output for 2012
simulation <- read.csv("scripts/sim_2012_logit.csv")
sim_sort_logit <- simulation[order(simulation$X),]

## Get comparison dataframe and mean and absolute error losses
compare_2012_logit <- cbind(results_2012_sorted, sim_sort_logit)
compare_2012_logit$squared <- (compare_2012_logit$means - compare_2012_logit$wins)^2
rmse <- sqrt(mean(compare_2012_logit$squared))
rmse

compare_2012_logit$absolute <- abs(compare_2012_logit$means - compare_2012_logit$wins)
mae <- mean(compare_2012_logit$absolute)
mae

#############################################################
################# 2012 NAIVE BAYES ##########################
#############################################################

## Get 2012 results 
results_2012 <- filter(results, year == 2012)
results_2012_sorted <- results_2012[order(results_2012$team),]

## Get the dataset with simulation output for 2012
simulation <- read.csv("scripts/sim_2012.csv")
sim_sort <- simulation[order(simulation$X),]

## Get comparison dataframe and mean and absolute error losses
compare_2012 <- cbind(results_2012_sorted, sim_sort)
compare_2012$squared <- (compare_2012$means - compare_2012$wins)^2
rmse <- sqrt(mean(compare_2012$squared))
rmse

compare_2012$absolute <- abs(compare_2012$means - compare_2012$wins)
mae <- mean(compare_2012$absolute)
mae



