#Function that takes as an input a players two point percentage, and outputs whether the shot is made or missed. 
two_point_shot <- function(player, two_percentage) {
  
  #Generate a random variable which will determine the outcome of the shot
  shot <- runif(1)
  
  #Print the inputs that made it into this function
  print(player)
  
  #Based on the Shot variable, determine whether the input player makes or misses their two point shot!
  if (shot < two_percentage) {
    print("Made two Point Shot")
    
    #Iterate the box score to show that the player made the two point shor
    box_score["2M", player] <<- box_score["2M", player] + 1
  }
  else {
    
    print("Missed two Point Shot")
  }
}