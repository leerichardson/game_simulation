####################################################################
## Download all of the raw game play by play files from NBA.com ####
####################################################################
library(XML)
library(RCurl)

## Read in the first date
first_date <- "http://www.nba.com/gameline/20091027/"

## Extract all Game links from this home link
doc <- htmlParse(first_date, isHTML=TRUE)
game_links <- unique(getHTMLLinks(doc))
game_urls <- paste("http://www.nba.com/", game_links[grep('gameinfo', game_links)], sep="")

## Loop through each game to get the play by play data
for(g in game_urls){
 print(g) 
}

