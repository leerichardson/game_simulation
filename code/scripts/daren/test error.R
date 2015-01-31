data2013<-players[which(players$SEASON=='2013'),]
score2014 <- scores[which(scores$game_year=='2014'),]


ngame2014=length(score2014$gameDate)
nplayers2013=length(data2013$SEASON)

#players in two different team shows up in the data multiple times!!!


i<-1
while (i < length(data2013$SEASON))
{countj=0
	for(j in i+1:nplayers2013)
{ if ( j< 1+ length(data2013$SEASON) && data2013$playerName[i]==data2013$playerName[j])
	{countj=countj+1}}
	if(countj>0){
	data2013<-data2013[-i,]	}
	else{i=i+1}
}


#checking how many times a player show up
a<- vector(mode="numeric", length =length(data2013$SEASON))
for( i in 1:length(data2013$SEASON))
{for(j in 1:length(data2013$SEASON))
	{if(data2013$playerId[i]==data2013$playerId[j])
	{if(a[i]<2){a[i]=a[i]+1}}}
}
plot(a)

#getting Xtest
test2013home<-matrix(data=0,ncol=21,nrow=ngame2014)
test2013visit<-test2013home

for( i in 1:ngame2014)
{gamebox<- detail[which(detail$match_id==score2014$match_id[i]),1:3]
	#gamebox tells who is playing and what is match Id	
for(j in 1: length(gamebox$match_id))
{if(length(data2013[which(data2013$playerId ==gamebox$playerId[j]),19])!=0)
	{#print(data2012[which(data2012$playerId==gamebox$playerId[j]),])
		if(gamebox$home[j]==1){
		for( k in 1:21)
		{test2013home[i,k]=test2013home[i,k]+
		data2013[which(data2013$playerId ==gamebox$playerId[j]), k+4]}}
		if(gamebox$home[j]==0)
		{for( k in 1:21)
		{test2013visit[i,k]=test2013visit[i,k]+
		data2013[which(data2013$playerId ==gamebox$playerId[j]), k+4]}}}}}


summary(test2013home)
summary(test2013visit)





test2013=test2013home-test2013visit
test2013<-data.frame(test2013)
colnames(test2013)<-colnames(training2012[,2:22])
fitted=predict(mm,test2013,type="response")
 
error<- function(x) {
predict<-vector(mode="numeric",length(x))
for (i in 1:length(x))
{if(x[i]>0.5)
	{predict[i]<-1}
	else
	{predict[i]=0}}

a=0
for (i in 1:length(x))
{if(predict[i]==score2014$result[i])
	{a=a}
	else
	{a=a+1}}
error=1-a/ngame2014}
summary(mm)
print(error(fitted))