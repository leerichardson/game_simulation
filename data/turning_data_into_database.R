# The purpose of this script is to turn the dataset scraped from Baskebtall Reference and Stats for the NBA
# Appspot into an SQL database so it will be easier to interact with during the simulations. 

#Set the appropriate working directory
setwd("C:/Users/leeri_000/basketball_stats/game_simulation")

#Installing the Necessary Packages (includes DBI, and RSQLite)
install.packages("sqldf")
install.packages("XLConnect")

#Loading in the required Packages
library(sqldf)

#Read in the data I'm trying to turn into an SQL database
dataset <- read.csv("data//input_data.csv")

#Creating the initial Basketball database!
db <- dbConnect(SQLite(), dbname="Basketball.sqlite")

