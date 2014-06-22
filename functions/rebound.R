rebound <- function(offensive_percentage, defensive_percentage) {
  #Determine cutoff percentage for offensive/defensive rebound
  cutoff <- sum(offensive_percentage, (1-defensive_percentage))/2
  #Generate random variable which determines the offensive/defensive rebound
  rebound_variable <- runif(1)
  if(rebound_variable < cutoff) {
    print("Offensive Rebound!")
  }
  else{
    print("Defensive Rebound!")
  }
}


