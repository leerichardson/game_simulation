## SET WORKING DIRCTORY ##
  setwd("C:/Users/Lee/game_simulation")

## LIBRARIES
  library("dplyr")
  library("e1071")
  library("randomForest")
  
## READ IN OUR FEATURE DATASETS
  data <- read.csv("scripts/rpm_dataset.csv")
  data_rpi <- read.csv("scripts/rpi.csv")

## ADD home feature and win/loss column
  data <- mutate(data, home = 1)
  data <- mutate(data, RPM_dif = RPM_weight.1 - RPM_weight.0)
  data$homeWin <- ifelse(data$home_team_score > data$visit_team_score, 1, 0)
  
## Set up datasets ##   
  years <- c(2008, 2009, 2010, 2011, 2012, 2013)
  train = filter(data, game_year %in% c(2008, 2009, 2010, 2011, 2012))
  test = filter(data, game_year == 2013)
  
  xtest = test[,9:18]
  ytest = test[,19]
  xtrain = train[,9:18]
  ytrain = train[,19]
  
## Naive Bayes  
  model <- naiveBayes(xtrain[,c(1,5) ], ytrain)
  preds <- as.data.frame(predict(model, xtest, type = c("raw"), threshold = 0.001))
  preds$class <- ifelse(preds[,2] > preds[,1], 1, 0)
  preds <- cbind(preds, ytest)
  preds$result <- abs(preds[,3] - preds[,4])
  accuracy <- 1 - sum(preds$result)/length(ytest)
  accuracy
  
## Logistic Regression  
  mylogit <- glm(homeWin ~ RPM_weight.0 + ORPM_weight.0 + PER_weight.1 + PER_weight.0 , data=train, family = "binomial")
  logit_preds <- as.data.frame(predict(mylogit, newdata=xtest, type="response"))
  logit_preds$class <- ifelse(logit_preds[,1] >= .5, 1, 0)
  logit_preds <- cbind(logit_preds, ytest)
  logit_preds$result <- abs(logit_preds[,2] - logit_preds[,3])
  logit_accurary <- 1 - sum(logit_preds$result)/length(ytest)
  logit_accurary
  
## Linear Regression
  mylinear <- lm(homeWin ~ RPM_weight.0 + ORPM_weight.0 + DRPM_weight.0 + PER_weight.0 + 
                   RPM_weight.1 + ORPM_weight.1 + DRPM_weight.1 + PER_weight.1, data=train)
  linear_preds <- as.data.frame(predict(mylinear, newdata=xtest, type="response"))
  linear_preds$class <- ifelse(linear_preds[,1] >= .5, 1, 0)
  linear_preds <- cbind(linear_preds, ytest)
  linear_preds$result <- abs(linear_preds[,2] - linear_preds[,3])
  linear_accurary <- 1 - sum(linear_preds$result)/length(ytest)
  linear_accurary
  
## Random Forest
  rf <- randomForest(homeWin ~ RPM_weight.0 + ORPM_weight.0 + DRPM_weight.0 + PER_weight.0 + 
  RPM_weight.1 + ORPM_weight.1 + DRPM_weight.1 + PER_weight.1, data=train, type="classification")
  rf_preds <- as.data.frame(predict(rf, xtest))
  rf_preds <- cbind(rf_preds, ytest)
  rf_preds$class <- ifelse(rf_preds[,1] >= .5, 1, 0)
  rf_preds$result <- abs(rf_preds[,2] - rf_preds[,3])
  rf_accurary <- 1 - sum(rf_preds$result)/length(ytest)
  rf_accurary  
  