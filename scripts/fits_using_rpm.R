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
  train = filter(data, game_year %in% c(2008))
  test = filter(data, game_year == 2009)
  
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
  
## Linear Regression
  
## Support Vector Machine
  
## Non parametric regression 
  
  
  
  