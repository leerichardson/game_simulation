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
  train = filter(data, game_year == 2012)
  test = filter(data, game_year == 2013)
  
  xtest = test[,9:17]
  ytest = test[,18]
  xtrain = train[,9:17]
  ytrain = train[,18]
  
## Naive Bayes  
  model <- naiveBayes(xtrain, ytrain)
  preds <- as.data.frame(predict(model, xtest, type = c("raw"), threshold = 0.001))
  preds$class <- ifelse(preds[,2] > preds[,1], 1, 0)
  compare <- as.data.frame(cbind(preds[,3], ytest))
  compare$result <- abs(compare[,2] - compare[,1])
  error <- sum(compare$result/length(ytest))
  1 - error
  
## Logistic Regression  
  
## Linear Regression
  
## Support Vector Machine
  
## Non parametric regression 
  
  