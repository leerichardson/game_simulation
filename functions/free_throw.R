free_throw <- function(player, free_throw_percentage, num_shots) {

  #Shoot all of the fre throws that aren't the last one.  
  while(num_shots > 1) {
    
    #Generate a random variable that will determine the outcome of the free throw
    shot <- runif(1)
    
    #Based on the random number, determine if the free throw is made
    if (shot < free_throw_percentage) {
      print("Made Free Throw!")
      
      #Iterate the box score to indicate a made free throw
      box_score["FTM", player] <<- box_score["FTM", player] + 1
    }
    else {
      print("Missed Free Throw")  
    }
    num_shots <- num_shots - 1 
  }

  #Generate variable for the last shot
  shot_final <- runif(1)
  
  #Based on the random number, determine whether the final free throw is made
  if (shot_final < free_throw_percentage) {
    print("Made final Shot")
    
    #Iterate the box score to indicate a made free throw
    box_score["FTM", player] <<- box_score["FTM", player] + 1
  }
  else {
    print("Missed final Shot")
    
    #Call the rebound function to determine if the possession ends or the offense gets another play
    rebound()
  }
}
