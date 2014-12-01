## Purpose: Figure out most important covariates for prediction
library(dplyr)
library(lars)

## SET WORKING DIRCTORY ##
setwd("C:/Users/leeri_000/basketball_stats/game_simulation")

# Read in the full feature matrix 
full_matrix <- read.csv("featuresAll.csv")

## Set up full and null models 
null_mod <- glm(formula = homeWin ~ 1, family = "binomial", data = full_matrix)

full_mod <- glm(homeWin ~ RPM_weight_0 + ORPM_weight_0 + DRPM_weight_0 + PER_weight_0 + 
RPM_weight_1 + ORPM_weight_1 + DRPM_weight_1 + PER_weight_1 + avg_scoreDiff +
avg_scoreDiff_home + avg_win_home + avg_scoreDiff_visit + avg_win_visit + home_rpi +
away_rpi + avg_GP + avg_GS+avg_MIN + avg_FG_made + avg_FG_attempted +    
avg_FGpercent + avg_ThreeP_made + avg_ThreeP_attempted + avg_ThreePpercent + avg_FT_made +
avg_FT_attempted+ avg_FTpercent+ avg_OR+ avg_DR+ avg_REB+ avg_AST + avg_BLK+
avg_STL+ avg_PF +avg_TO+ avg_PTS, family="binomial", data=full_matrix)

## Stepwise model selection
stepwise_mod <- step(null_mod, scope=list(lower=null_mod, upper=full_mod), direction="both")

## Lasso
train = filter(full_matrix, game_year %in% c(2008, 2009, 2010, 2011, 2012))
test = filter(full_matrix, game_year == 2013)

xtest = as.matrix(test[,8:44])
ytest = as.matrix(test[,2])
xtrain = as.matrix(train[,8:44])
ytrain = as.matrix(train[,2])

# Fit a LARS object 
lasso_mod <- lars(xtrain, ytrain, type="lasso")
fits <- predict.lars(lasso_mod, xtest, type="fit")
p <- as.data.frame(fits[4])
lasso_probs <- as.data.frame(p[,56])
lasso_probs$class <- ifelse(lasso_probs[,1] >= .5, 1, 0)
lasso_probs <- cbind(lasso_probs, ytest)
lasso_probs$result <- abs(lasso_probs[,2] - lasso_probs[,3])
accuracy <- 1 - sum(lasso_probs$result)/length(ytest)
accuracy

