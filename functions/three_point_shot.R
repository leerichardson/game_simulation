three_point_shot <- function(player, three_percentage) {
  #Generate a random variable which will determine the outcome of a three point shot
  shot <- runif(1)
  
  #Based on the generated random vairable, determine the outcome of the shot and update the box score accordingly
  if (shot < three_percentage) {
    print("Made Three Point Shot")
    
    #Iterate the box score to show that the player made the two point shor
    box_score["3M", player] <<- box_score["3M", player] + 1
  }
  else {
    print("Missed Three Point Shot")
    
    #Call the rebound function to determine if the possession ends or the offense gets another play
    rebound()
  }
}