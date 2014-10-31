#install.packages("RSQLite")
#install.packages("dplyr")
#install.packages("foreach")
#install.packages('e1071')
#install.packages('rpart')
#install.packages("LiblineaR")
#install.packages("glmnet")
#library("RSQLite")
library(e1071)
library(rpart)
library(LiblineaR)
library(glmnet)
library(foreach)
setwd("D:\\vlis\\machineLearning\\nba\\rRegression")
regTable <- read.csv("regTable.csv",sep=",",head=TRUE)

#prepare data
train=sample(1:dim(regTable)[1],round(dim(regTable)[1]*0.7))
columns <- names(regTable)
xColumnsToDelete = c('match_id','gameDate','homeTeam','visitTeam','homeScore','visitScore','homeWin')
xColumns = columns[ - which(columns %in% xColumnsToDelete)]
yLabel = c('homeWin')
xTrain=regTable[train,xColumns]
yTrain=regTable[train,yLabel]
xTest=regTable[-train,xColumns]
yTest=regTable[-train,yLabel]




#lasso
s=scale(xTrain,center=TRUE,scale=TRUE)
Fit <- cv.glmnet(s, yTrain,alpha=0.1)
for(pmx in c(20,50,80,100,150,200,250,300,350,400)){
    model <- cv.glmnet(s, yTrain,family="binomial",type.measure="auc",pmax=pmx,parallel=TRUE)
    model$lambda.1se
    model.final <- model$glmnet.fit
    model.coef <- coef(model$glmnet.fit, s = model$lambda.1se)
    all.coef <- coef(model$glmnet.fit, s =  min(model.final$lambda))
    s2=scale(xTest,attr(s,"scaled:center"),attr(s,"scaled:scale"))
    p=predict(model,newx=s2,type="response")
    yText_predict = apply(p,1, function(x) if (x>0.5) 1 else 0)
    accuracy = sum(1 - abs(c(yTest-yText_predict)))/length(yTest)
    cat('pmax: ',pmx,' accuracy: ',accuracy,'\n')
}








# LR
# Find the best model with the best cost parameter via 10-fold cross-validations
tryTypes=c(0:7)
tryCosts=c(1000,100,10,1,0.1,0.01,0.001)
bestCost=NA
bestAcc=0
bestType=NA
for(ty in tryTypes){
  for(co in tryCosts){
    acc=LiblineaR(data=s,labels=yTrain,type=ty,cost=co,bias=TRUE,cross=10,verbose=FALSE)
    cat("Results for C=",co," : ",acc," accuracy.\n",sep="")
    if(acc>bestAcc){
      bestCost=co
      bestAcc=acc
      bestType=ty
    }
  }
}
cat("Best model type is:",bestType,"\n")
cat("Best cost is:",bestCost,"\n")
cat("Best accuracy is:",bestAcc,"\n")



#svm
