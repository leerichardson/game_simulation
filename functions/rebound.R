rebound <- function(team,offensive_percentage, defensive_percentage) {
  #Determine cutoff percentage for offensive/defensive rebound
  cutoff <- ((1-offensive_percentage) + defensive_percentage)/2
  
  #Generate random variable which determines the offensive/defensive rebound
  rebound_variable <- runif(1)
  
  #Using the random variable, determine whether the rebound is secured by the offensive or Defensive team
  if(rebound_variable < cutoff) {
    print("Defensive Rebound!")
  }
  else{
    print("Offensive Rebound!")
  }
}


