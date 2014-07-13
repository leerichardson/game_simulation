determine_event <- function(player, to_percentage, two_percentage, ft_percentage, three_percentage) {
  
  #Normalize the four different outcomes, and Generate a random number which will determine the outcome 
  #of the individual possession
  outcomes <- c(to_percentage, two_percentage, ft_percentage, three_percentage)  
  outcomes_normalized <- outcomes/sum(outcomes)

  #Test what the function is recieving as an input
  player_box_score <- paste(team_name, player, sep="_")
                              
  #Generate the random number which determines the first event of the possession
  event <- runif(1)
  
  #Using the random number, determine the outcome of the game 
  if (event < outcomes_normalized[1]) {
    print("Turnover!")
    
    #Iterate the global box score (with <<-) to add a turnover to this player's statistics
    box_score["TO", player_box_score] <<- box_score["TO", player_box_score] + 1
  }
  else if(event >= outcomes_normalized[1] & event < outcomes_normalized[1] + outcomes_normalized[2]) {
    print("Two Point Shot")
    
    #Iterate the global box score (with <<-) to add a Two point Shot Attempt to this player's statistics
    box_score["2A", player_box_score] <<- box_score["2A", player_box_score] + 1
    
    #Call the function which determines the outcome of the Two Point Attempt 
    two_point_shot(player_box_score, team[as.numeric(player),"two_perc"])
  }
  else if(event >= outcomes_normalized[1] + outcomes_normalized[2] & event < outcomes_normalized[1] 
          + outcomes_normalized[2] + outcomes_normalized[3]) {
    print("Three Point Shot!")
    
    #Iterate the global box score (with <<-) to add a Three Point shot Attempt to this player's statistics
    box_score["3A", player_box_score] <<- box_score["3A", player_box_score] + 1
    
    #Call the function which determines the outcome of the Three Point Attempt 
    three_point_shot(player_box_score, team[as.numeric(player),"three_perc"])  
  }
  else {
    print("Free Throws!")
    
    #Iterate the global box score (with <<-) to add two Free throw Attempts to this player's statistics
    box_score["FTA", player_box_score] <<- box_score["FTA", player_box_score] + 2
    
    #Call the function which determines the outcome of the two free throws
    free_throw(player_box_score, team[as.numeric(player), "ft_perc"], 2)
  }
}


