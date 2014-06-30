determine_player <- function(team, p1_usage, p2_usage, p3_usage, p4_usage, p5_usage) {   
  #Squeeze the usage rates so they will add up to one
  players <- c(p1_usage, p2_usage, p3_usage, p4_usage, p5_usage)  
  players_normalized <- players/sum(players)
  print(team)
  
  #Generate the random number which determines which player uses the possession
  player <- runif(1)
  
  #Using a Random Number and the scaled usage rates, determine which player will use the possession
  if (player < players_normalized[1]) {
    print("ONE")
    selected_player <- "p1"
    determine_event(team, selected_player, team[1,"tov_dist"], team[1,"two_dist"], team[1,"ft_dist"], team[1,"three_dist"])
  }
  else if ((player >= players_normalized[1]) & (player < (players_normalized[1] + players_normalized[2]))) {
    print("TWO")
    selected_player <- "p2"
    determine_event(team, selected_player, team[2,"tov_dist"], team[2,"two_dist"], team[2,"ft_dist"], team[2,"three_dist"])
  }
  else if (player >= (players_normalized[1] + players_normalized[2]) 
           & player < (players_normalized[1] + players_normalized[2] + players_normalized[3])) {
    print("THREE")
    selected_player <- "p3"
    determine_event(team, selected_player, team[3,"tov_dist"], team[3,"two_dist"], team[3,"ft_dist"], team[3,"three_dist"])
  }
  else if (player >= players_normalized[1] + players_normalized[2] + players_normalized[3] 
           & (player < players_normalized[1] + players_normalized[2] + players_normalized[3] + players_normalized[4])) {
    print("FOUR")
    selected_player <- "p4"
    determine_event(team, selected_player, team[4,"tov_dist"], team[4,"two_dist"], team[4,"ft_dist"], team[4,"three_dist"])
  }
  else {
    print("FIVE")
    selected_player <- "p5"
    determine_event(team, selected_player, team[5,"tov_dist"], team[5,"two_dist"], team[5,"ft_dist"], team[5,"three_dist"])
  }
}
