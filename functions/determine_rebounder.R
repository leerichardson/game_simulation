determine_rebounder <- function(p1_rebound, p2_rebound, p3_rebound, p4_rebound, p5_rebound, offense_defense) {
  #Squeeze the input rebound rates to one, 
  players <- c(p1_rebound, p2_rebound, p3_rebound, p4_rebound, p5_rebound)  
  players_normalized <- players/sum(players) 
  
  #Generate the random number to determine which player get's the rebound
  player <- runif(1)
  
  #Based on the team_name and offense_defense input, determine which team, box score statistic should get the credit
  if (team_name == "team1" & offense_defense == "offense") {
    #Based on the combination, set the appropriate team and metric to be iterated
    reb_team = "team1"
    metric = "OREB"
    
  }
  else if (team_name == "team1" & offense_defense == "defense") {   
    #Based on the combination, set the appropriate team and metric to be iterated
    reb_team = "team2"
    metric = "DREB"
  }
  else if (team_name == "team2" & offense_defense == "offense"){
    #Based on the combination, set the appropriate team and metric to be iterated
    reb_team = "team2"
    metric = "OREB"    
  }
  else {
    #Based on the combination, set the appropriate team and metric to be iterated
    reb_team = "team1"
    metric = "DREB"    
  }
  
  #Using a Random Number and the scaled usage rates, determine which player will use the possession
  if (player < players_normalized[1]) {
    #If this player is chosen, create the appropriate box score input and give player credit in the global box score
    selected_player <- "1"
    player_box_score <- paste(reb_team, selected_player, sep="_")
    box_score[metric, player_box_score] <<- box_score[metric, player_box_score] + 1
  }
  else if ((player >= players_normalized[1]) & (player < (players_normalized[1] + players_normalized[2]))) {
    #If this player is chosen, create the appropriate box score input and give player credit in the global box score
    selected_player <- "2"
    player_box_score <- paste(reb_team, selected_player, sep="_")
    box_score[metric, player_box_score] <<- box_score[metric, player_box_score] + 1
  }
  else if (player >= (players_normalized[1] + players_normalized[2]) 
           & player < (players_normalized[1] + players_normalized[2] + players_normalized[3])) {
    #If this player is chosen, create the appropriate box score input and give player credit in the global box score
    selected_player <- "3" 
    player_box_score <- paste(reb_team, selected_player, sep="_")
    box_score[metric, player_box_score] <<- box_score[metric, player_box_score] + 1
  }
  else if (player >= players_normalized[1] + players_normalized[2] + players_normalized[3] 
           & (player < players_normalized[1] + players_normalized[2] + players_normalized[3] + players_normalized[4])) {
    #If this player is chosen, create the appropriate box score input and give player credit in the global box score
    selected_player <- "4"
    player_box_score <- paste(reb_team, selected_player, sep="_")
    box_score[metric, player_box_score] <<- box_score[metric, player_box_score] + 1
  }
  else {
    #If this player is chosen, create the appropriate box score input and give player credit in the global box score
    selected_player <- "5"
    player_box_score <- paste(reb_team, selected_player, sep="_")
    box_score[metric, player_box_score] <<- box_score[metric, player_box_score] + 1
    
  }
  
  #After the individual rebounding credit is in place, restart the possession if it was an offensive rebound
  
}

