#Load the XML Library 
library(XML)

#Set the years for which the Website has data
years <- 1991:2013

#Set the urls for the data we want 
url <- paste0("http://stats-for-the-nba.appspot.com/ratings/", years,".html")

