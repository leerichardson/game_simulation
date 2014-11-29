#Load the XML Library 
library(XML)

###### URLs
url<-paste0("http://www.basketball-reference.com/players/",letters,"/")

#Set the years from which data is available
years <- 1950:2014

#Set the urls for the data we want 
totals_url <- paste0("http://www.basketball-reference.com/leagues/NBA_", years, "_totals.html")
advanced_url <- paste0("http://www.basketball-reference.com/leagues/NBA_", years, "_advanced.html")

#Set the length of the tables that we are scraping from 
totals_len<-length(totals_url)
advanced_len<-length(advanced_url)

#Initialize both the totals and advanced tables
totals_table <- readHTMLTable(totals_url[1])[[1]]
totals_table$year <- 1950

advanced_table <- readHTMLTable(advanced_url[1])[[1]]
advanced_table$year <- 1950

#Append together all of the totals data 
for (i in 2:totals_len) {
  #Create a temporary table, and then append on a variable that contains the year
  temp_table <- readHTMLTable(totals_url[i])[[1]]
  temp_table$year <- i + 1949
  totals_table<-rbind(totals_table,temp_table)
}

#Append together all of the advanced data 
for (i in 2:advanced_len) {
  #Create a temporary table, and then append on a variable that contains the year
  temp_table <- readHTMLTable(advanced_url[i])[[1]]
  temp_table$year <- i + 1949
  advanced_table<-rbind(advanced_table,temp_table)
}

#Combine the output of these two tables, and get rid of the default rows which don't 
all_table <- as.data.frame(subset(cbind(totals_table, advanced_table), Player != "Player"))
all_table_revised <- all_table[,!grepl(".1", names(all_table))]

#Write the polished data frame to a CSV
write.csv(all_table_revised, file = "data/bball_ref_data.csv")






