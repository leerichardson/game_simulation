determine_player <- function(p1_usage, p2_usage, p3_usage, p4_usage, p5_usage) {   
  #Squeeze the usage rates so they will add up to one
  players <- c(p1_usage, p2_usage, p3_usage, p4_usage, p5_usage)  
  players_normalized <- players/sum(players)
  #Generate the random number which determines which player uses the possession
  player <- runif(1)
  
  #Using a Random Number and the scaled usage rates, determine which player will use the possession
  if (player < players_normalized[1]) {
    print("Player One!")
  }
  else if ((player >= players_normalized[1]) & (player < (players_normalized[1] + players_normalized[2]))) {
    print("Player Two!")
  }
  else if (player >= (players_normalized[1] + players_normalized[2]) 
           & player < (players_normalized[1] + players_normalized[2] + players_normalized[3])) {
    print("Player Three!")
  }
  else if (player >= players_normalized[1] + players_normalized[2] + players_normalized[3] 
           & (player < players_normalized[1] + players_normalized[2] + players_normalized[3] + players_normalized[4])) {
    print("Player Four!")
  }
  else {
    print("Player Five!")
  }
}
