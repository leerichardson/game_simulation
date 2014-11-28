## SET WORKING DIRCTORY ##
  setwd("C:/Users/Lee/game_simulation")

## LIBRARIES
  library("dplyr")
  library("e1071")
  
## READ IN OUR FEATURE DATASETS
  large_data <- read.csv("C:/Users/Lee/game_simulation/nba_rRegression_chi//regTable.csv")
  data <- read.csv("scripts/rpm_dataset.csv")
  
## ADD home feature and win/loss column
  data <- mutate(data, home = 1)
  data$homeWin <- ifelse(data$home_team_score > data$visit_team_score, 1, 0)
  
## Set up datasets ##   
  years <- c(2008, 2009, 2010, 2011, 2012, 2013)
  train = filter(data, game_year %in% c(2008, 2009, 2010, 2011, 2012))
  test = filter(data, game_year == 2013)
  
  xtest = test[,9:17]
  ytest = test[,18]
  xtrain = train[,9:17]
  ytrain = train[,18]
  
## Naive Bayes  
  model <- naiveBayes(xtrain, ytrain)
  preds <- as.data.frame(predict(model, xtest, type = c("raw"), threshold = 0.001))
  preds$class <- ifelse(preds[,2] > preds[,1], 1, 0)
  preds <- cbind(preds, ytest)
  preds$result <- abs(preds[,3] - preds[,4])
  accuracy <- 1 - sum(preds$result)/length(ytest)
  accuracy
  
## Logistic Regression  
  mylogit <- glm(homeWin ~ RPM_weight.0 + ORPM_weight.0 + DRPM_weight.0 + PER_weight.0 + 
                   RPM_weight.1 + ORPM_weight.1 + DRPM_weight.1 + PER_weight.1 + home, data=train,
                 family = "binomial")
  
  logit_preds <- as.data.frame(predict(mylogit, newdata=xtest, type="response"))
  logit_preds$class <- ifelse(logit_preds[,1] >= .5, 1, 0)
  logit_preds <- cbind(logit_preds, ytest)
  logit_preds$result <- abs(logit_preds[,2] - logit_preds[,3])
  logit_accurary <- 1 - sum(logit_preds$result)/length(ytest)
  logit_accurary
  
## Linear Regression
  mylinear <- lm(homeWin ~ RPM_weight.0 + ORPM_weight.0 + DRPM_weight.0 + PER_weight.0 + 
                   RPM_weight.1 + ORPM_weight.1 + DRPM_weight.1 + PER_weight.1 + home, data=train)
  linear_preds <- as.data.frame(predict(mylinear, newdata=xtest, type="response"))
  linear_preds$class <- ifelse(linear_preds[,1] >= .5, 1, 0)
  linear_preds <- cbind(linear_preds, ytest)
  linear_preds$result <- abs(linear_preds[,2] - linear_preds[,3])
  linear_accurary <- 1 - sum(linear_preds$result)/length(ytest)
  linear_accurary
  
## Support Vector Machine
  
  
## Non parametric regression
  
  
  
  
  