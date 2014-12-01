##################################################################
## Download all of the raw game play by play files from NBA.com ##
##################################################################
library(XML)

first_date <- "http://www.nba.com/gameline/20091001/"


nba_one <- "http://www.nba.com/games/20101201/CHANOH/gameinfo.html"
sample_game <- readLines(nba_one)
doc <- htmlParse(sample_game)
