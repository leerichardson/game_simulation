# Set to directory with SQLite database
############# THIS IS A LINE YOU MUST CHANGE ##########################
setwd("C:/Users/Lee/game_simulation/data/nba")

# Read in the appropriate packages. Might have to do install.packages("RSQLite") the first time 
# install.packages("RSQLite")
library("RSQLite")
library("dplyr")
library("e1071")

# connect to the sqlite file
con <- dbConnect(drv="SQLite", dbname="nba.db")

# Pull the results from the gameScore table
scores <- dbGetQuery(con, 'SELECT match_id, game_year, home_team_score,
                         visit_team_score FROM gameScore')

# Create the X and Y features
scores$result <- ifelse(scores$home_team_score > scores$visit_team_score, 1, 0)
scores$home <- 1
scores$away <- 0

# Set up the Features and Labels
feats <- select(scores, home)
labels <- select(scores, result)

# Set up the training model
classifier<-naiveBayes(feats, labels)


