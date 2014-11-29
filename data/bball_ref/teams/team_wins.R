## Purpose: Pull actual standings from different seasons in order to 
## compare our simulated seasons against and compute RMSE

## SET WORKING DIRCTORY ##
setwd("C:/Users/leeri_000/basketball_stats/game_simulation")

## Load in the library package
library(XML)

# Set up connection to our database
con <- dbConnect(drv="SQLite", dbname="nba_rRegression_chi/nba.db")
teams <- dbGetQuery(con, 'SELECT * FROM teams')

## Set up years
years <- 2013:2014

## Set up initial dataframe
win_vector <- as.data.frame(matrix(0, nrow=0, ncol=3))

for(j in years){
  ## Set up the URL for extraction
  url <- paste("http://espn.go.com/nba/standings/_/year/", j, sep="")
  standings <- readHTMLTable(url[1], header=T)[[1]][c(2:9, 11:17, 20:27, 29:35),c(2:3)]
  colnames(standings) <- c("name", "wins")
  standings[,1] <- as.character(standings[,1])
  
    ## Merge these standings with the teams 
    for(i in 1:length(standings[,1])){
      standings[i,1] <- gsub("x - ", "", standings[i,1])
      standings[i,1] <- gsub("y - ", "", standings[i,1])
      standings[i,1] <- gsub("z - ", "", standings[i,1])
    }
  
  standings <- standings[order(standings$name),] 
  teams <- teams[order(teams$fullName),]
  team_wins <- cbind(standings, teams)
  team_wins$year <- j - 1
  team_wins <- team_wins[, c(2, 3, 5)]
  win_vector <- rbind(win_vector, team_wins)
}

## Clean and save 
rownames(win_vector) <- NULL
write.csv(win_vector, "data/espn_data/team_wins.csv")


