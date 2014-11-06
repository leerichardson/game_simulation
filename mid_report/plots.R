#set working directory
setwd("/Users/Lee/game_simulation/mid_report")

data<-read.csv("2009_predict_2010")
#I name it training2011 becuase I dont have to change my code. It is how ever data from 2009-2010 season 
training2011 <- data
#First plot
c<-which(training2011$result==1)
par(mfrow=c(3,2))
plot(training2011$avg_REB[c],training2011$avg_PF[c],col=2,pch=2,main="Team rebounds v.s Team fouls",xlab="Team Rebounds",ylab="Team fouls")
legend("topleft",pch=c(2,1),col=c('red','blue'),legend=c("home_win","home_lose")
)
d<-which(training2011$result==0)
points(training2011$avg_REB[d],training2011$avg_PF[d],col='blue')

# box plot : Team point for home win and Team points for home lose 
boxplot(v1,v2,names=c("home win","home lose"),main="Teams stats(points) from last season v.s results in this season", ylab=" Team difference stats (points)")
summary(training2011)

#plots showing corelated data

plot(training2011$avg_PTS,training2011$avg_AST,main="Team Points v.s Team Assit  in Season 2009-2010",xlab="Team Points", ylab="Team Assist" )
cor(training2011$avg_PTS,training2011$avg_AST)
#corelation is 0.813 for assist and points

#This follwoing is your code to set up the data frame of RPM
## SET WORKING DIRCTORY ##
  setwd("/Users/darenwang/Downloads/game_simulation-master/scripts")

## Load Libraries
  library("dplyr")
  library("e1071")
  
## READ IN dataset 
  data <- read.csv("rpm_dataset.csv")
  
## ADD IN win/loss column
  data <- mutate(data, home = 1)
  data$homeWin <- ifelse(data$home_team_score > data$visit_team_score, 1, 0)
  
## Set up datasets ##   
  train = filter(data, game_year == 2009)
  test = filter(data, game_year == 2010)
  
  
  xtest = test[,9:17]
  ytest = test[,18]
  xtrain = train[,9:17]
  ytrain = train[,18]
  
  w<-which(ytest==1)
  l<-which(ytest==0)
  v_0<-xtest[w,1]
  v_1<-xtest[l,1]
 
#boxplot for RPM 
  boxplot(v_0,v_1, main=" boxplot RPM for home team win and home team lose",names=c("home lose","home win"), ylab="RPM")
  
#plot for RPM vs ORPM with indication which team is winning

cc<-which(ytest==1)
plot(xtest$RPM_weight.0[cc],xtest$ORPM_weight.0[cc],col=2,pch=2,main="RPM v.s ORPM for season 2009",xlab="RPM",ylab="ORPM")
legend("topleft",pch=c(2,1),col=c('red','blue'),legend=c("home_win","home_lose")
)
dd<-which(ytest==0)
points(xtest$RPM_weight.0[dd],xtest$ORPM_weight.0[dd],col='blue')

  
  
  
  