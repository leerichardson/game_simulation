#Load the XML Library 
library(XML)

#Set the years for which the Website has data
years <- 1991:2013

#Set the urls for the data we want 
url <- paste0("http://stats-for-the-nba.appspot.com/ratings/", years,".html")

#Set the number of URL's 
len<-length(url)

#Initiate the table we will be appending all of the other pages to
tab <- readHTMLTable(url[1])[[1]]
tab$year <- 1991

#Append together all of the totals data 
for (i in 2:len) {
  #Create a temporary table, and then append on a variable that contains the year
  temp_table <- readHTMLTable(url[i])[[1]]
  
  #Something weird going on with tables after 2008. Put a conditional in here to fix. 
  if (i >= 18) {
    temp_table <- temp_table[,-which(names(temp_table) == "V6")]
    temp_table$year <- i + 1990
    colnames(temp_table) <- names(tab)
  }
  else {
    temp_table$year <- i + 1990
  }

  tab<-rbind(tab,temp_table)
}

#Fix up and write the CSV to be merged with the BBall Ref data
colnames(tab) <- c("Player", "ORPM", "DRPM", "RPM", "Possessions", "year") 

#Change all of the factor columns into Numerics
write.csv(tab, file = "data/RPM_data.csv")






