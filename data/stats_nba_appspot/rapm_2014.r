## Set working directory
setwd("C:/Users/Lee/game_simulation/data/stats_nba_appspot")

## Load the XML Library 
library(XML)

## Set the url
url <- "http://stats-for-the-nba.appspot.com/ratings/2014.html"
rpm_2013 <- readHTMLTable(url[1])[[1]]

## Save the data 
write.csv(rpm_2013, "data_2013.csv")


