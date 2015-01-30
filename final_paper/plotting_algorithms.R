## Set the Working Directory
setwd("C:/Users/leeri_000/Dropbox/basketball//game_simulation/final_paper")
library(dplyr)
library(ggplot2)

results <- read.csv("algorithms.csv")
results <- filter(results, !is.na(Logistic.Regression))

compare <- read.csv("rapm_per.csv", header=TRUE)
compare_logit <- compare[1:2,2:6]
compare_nb <-  compare[3:4,3:6]

##PLOT THE COMPARISONS
par(mfrow=c(1,2))
colnames(compare_logit) = years
rownames(compare_logit) = c("PER", "RAPM")
compare_logit = as.matrix(compare_logit)
barplot(compare_logit, beside=TRUE,  col=c("darkblue","red"), ylim=c(0, .8), 
        main="Logistic Regression Test Error", ylab="Prediction Accuracy")
legend("bottomleft", 'groups', c("PER", "RAPM"), fill=c("darkblue","red"))

colnames(compare_nb) = years
rownames(compare_nb) = c("PER", "RAPM")
compare_nb = as.matrix(compare_logit)
barplot(compare_nb, beside=TRUE,  col=c("darkblue","red"), 
        main="Naive Bayes Test Error", ylim=c(0, .8), ylab="Prediction Accuracy")
legend("bottomleft", 'groups', c("PER", "RAPM"), fill=c("darkblue","red"))


## Get last years predictions 
preds_2012 <- read.csv("2012_predictions.csv", header=TRUE)
preds_2013 <- read.csv("2013_predictions.csv", header=TRUE)

RMSE_2012 <- preds_2012$RMSE
RMSE_2013 <- preds_2013$RMSE

par(mfrow=c(1,1))
hist(RMSE_2012, breaks=8, col=rgb(0,0,1,1/4), xlim=c(5, 15), main="Comparison of Prediction Accuracies in the
     2012-13 and 2013-14 seasons", xlab="RMSE")
hist(RMSE_2013, col=rgb(1,0,0,1/4), add=TRUE)
legend("topright", 'groups', c("2012", "2013"), fill=c("darkblue","red"))

setwd("C:/Users/leeri_000/Dropbox/basketball//game_simulation")
data <- read.csv("regressionTrial_chi/gameScore_rates.csv")
rpm_plot <- select(data, homeWin, RPM_weight_0, RPM_weight_1)
colnames(rpm_plot) = c("Win", "RAPM_Away", "RAPM_Home")

## Group Summaries
grouped <- group_by(rpm_plot, Win)
summarise(grouped, mean(RAPM_Home), mean(RAPM_Away))

## Plot 
qplot(RAPM_Away, RAPM_Home, colour= Win, data=rpm_plot) + geom_abline() + 
  xlab("Away Team RAPM") +
  ylab("Home Team RAPM") +
  ggtitle("Comparison of Home and Away Teams Weighted RAPM in Wins and Losses")
