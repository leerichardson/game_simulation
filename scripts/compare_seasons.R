## Purpose: Compare simulated season to actual results for 2012 and 2013 
library(dplyr)

## SET WORKING DIRCTORY ##
setwd("C:/Users/leeri_000/basketball_stats/game_simulation")

## Get dataset with the results 
results <- read.csv("data/espn_data/team_wins.csv")[,2:4]
results_2013 <- filter(results, year == 2013)
results_2013_sorted <- results_2013[order(results_2013$team),]

## Get the dataset with simulation output 
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
