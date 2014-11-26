# Set to directory with SQLite database
############# THIS IS A LINE YOU MUST CHANGE ##########################
  setwd("C:/Users/Lee/game_simulation/nba_rRegression_chi")

# Read in the appropriate packages. Might have to do install.packages("RSQLite") the first time 
# install.packages("RSQLite")
  library("RSQLite")                                                                                                                                                                                            
  library("plyr")
  library("dplyr")

# connect to the sqlite file
  con <- dbConnect(drv="SQLite", dbname="nba.db")

# Check the tables
  alltables <- dbListTables(con)
  check <- dbGetQuery(con, "SELECT * FROM gameYearPlayer")

# Get large dataset 
  data <- read.csv("regTable.csv")
