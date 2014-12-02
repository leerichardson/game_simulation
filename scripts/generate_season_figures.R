## SET WORKING DIRCTORY ##
setwd("C:/Users/leeri_000/basketball_stats/game_simulation")

## Read in the logit sims 
simulation <- read.csv("scripts/sim_2013_logit.csv")
means <- as.vector(simulation$means)
ses <- as.vector(simulation$ses)
season_df <- read.csv("scripts/sim_2013_logit_df.csv") 

## Get dataset with the results 
results <- read.csv("data/espn_data/team_wins.csv")[,2:4]
results_2013 <- filter(results, year == 2013)
results_2013 <- filter(results, year == 2013)[order(results_2013$team),]

## Add in the confidence interval
results_2013 <- cbind(results_2013, means[order(simulation$X)])
results_2013 <- cbind(results_2013, ses[order(simulation$X)])
names(results_2013)[4] = "estimate"
names(results_2013)[5] = "se"
results_2013$lower <- results_2013$estimate - 2*results_2013$se
results_2013$upper <- results_2013$estimate + 2*results_2013$se
results_2013$trapped <- ifelse(results_2013$wins >= results_2013$lower & 
                                 results_2013$wins <= results_2013$upper, 1, 0)

## Plot the outcomes 
par(mfrow=c(6, 5))
team_names <- unique(results_2013$team)
for(name in team_names){
  season_result <- as.numeric(season_df[season_df$X == name,])
  hist(season_result, main=paste("Wins for", toupper(name), sep=" "), xlab="Wins"
       , breaks=10)
  abline(v=results_2013[results_2013$team == name, "wins"], col="red")
  abline(v=results_2013[results_2013$team == name, "lower"], col="blue")
  abline(v=results_2013[results_2013$team == name, "upper"], col="blue")
}