#set working directory
setwd("/Users/darenwang/Downloads/game_simulation-master/data/nba")
library("RSQLite")
#connect to the sqlite file
con <- dbConnect(drv="SQLite", dbname="nba.db")

# get a list of all tables
alltables<- dbListTables(con)

#get score of each game, detail of each game and player_av_year data frame
scores <- dbGetQuery(con, 'SELECT * FROM gameScore')
detail<-dbGetQuery(con, 'SELECT * FROM gameDetail')
players<- dbGetQuery(con, 'SELECT * FROM players')

nscores=length(scores$home_team_score)
results =vector(mode = "numeric", length =
nscores)

for(i in 1:nscores){
if (scores$home_team_score[i] > scores$visit_team_score[i]){
 results[i] <- 1}
 else{
 	results[i]<-0
 }
 }
 scores["result"]<- results
 





data2012<-players[which(players$SEASON=='2012'),]
score2013 <- scores[which(scores$game_year=='2013'),]


ngame2013=length(score2013$gameDate)
nplayers2012=length(data2012$SEASON)

#players in two different team shows up in the data multiple times!!!


data2012<-players[which(players$SEASON=='2012'),]
i<-1
while (i < length(data2012$SEASON))
{countj=0
	for(j in i+1:nplayers2012)
{ if ( j< 1+ length(data2012$SEASON) && data2012$playerName[i]==data2012$playerName[j])
	{countj=countj+1}}
	if(countj>0){
	data2012<-data2012[-i,]	}
	else{i=i+1}
}


#checking how many times a player show up
a<- vector(mode="numeric", length =length(data2012$SEASON))
for( i in 1:length(data2012$SEASON))
{for(j in 1:length(data2012$SEASON))
	{if(data2012$playerId[i]==data2012$playerId[j])
	{if(a[i]<2){a[i]=a[i]+1}}}
}
plot(a)






#training data frame
training2012home<-matrix(data=0,ncol=21,nrow=ngame2013)
training2012visit<-training2012home

for( i in 1:ngame2013)
{gamebox<- detail[which(detail$match_id==score2013$match_id[i]),1:3]
	#gamebox tells who is playing and what is match Id	
for(j in 1: length(gamebox$match_id))
{if(length(data2012[which(data2012$playerId ==gamebox$playerId[j]),19])!=0)
	{#print(data2012[which(data2012$playerId==gamebox$playerId[j]),])
		if(gamebox$home[j]==1){
		for( k in 1:21)
		{training2012home[i,k]=training2012home[i,k]+
		data2012[which(data2012$playerId ==gamebox$playerId[j]), k+4]}}
		if(gamebox$home[j]==0)
		{for( k in 1:21)
		{training2012visit[i,k]=training2012visit[i,k]+
		data2012[which(data2012$playerId ==gamebox$playerId[j]), k+4]}}}}}


summary(training2012home)
summary(training2012visit)


training2012=training2012home-training2012visit
training2012<-data.frame(training2012)
colnames(training2012) <-colnames(data2012[1,5:25])
summary(training2012)


result=score2013$result
training2012<-cbind(result,training2012)


#fit the model
attach(training2012)
full=glm(result~ avg_GP +avg_GS+avg_MIN+avg_FG_made +avg_FG_attempted +avg_FGpercent+avg_ThreeP_made+avg_ThreeP_attempted+avg_ThreePpercent+avg_FT_made+avg_FT_attempted +avg_FTpercent+avg_OR+avg_DR+ avg_REB+avg_AST+avg_BLK+avg_STL        +avg_PF+avg_TO+avg_PTS )
min=lm(result~1)
step(full,scopre=list(lower=min,upper=full),direction="both")
mm<-glm(formula = result ~ avg_GP + avg_GS + avg_FG_attempted + avg_FGpercent + 
    avg_ThreeP_made + avg_ThreePpercent + avg_FT_made + avg_FT_attempted + 
    avg_DR + avg_STL + avg_PF + avg_TO + avg_PTS)
predict<-vector(mode="numeric",length=ngame2013)

detach(training2012)

#finding the prediction error in te training data
error<- function(x) {
predict<-vector(mode="numeric",length(x))
for (i in 1:length(x))
{if(x[i]>0.5)
	{predict[i]<-1}
	else
	{predict[i]=0}}

a=0
for (i in 1:length(x))
{if(predict[i]==score2013$result[i])
	{a=a}
	else
	{a=a+1}}
error=1-a/ngame2013}
summary(mm)
print(error(mm$fitted))



