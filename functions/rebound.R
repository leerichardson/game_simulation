rebound <- function() {
  
  #Based on the team name, pull the offensive and defensive rebounding numbers
  if (team_name == "team1"){
    offensive_percentage = team1_oreb
    defensive_percentage = team2_dreb
  }
  else {
    offensive_percentage = team2_oreb
    defensive_percentage = team1_dreb
  }
  
  #Determine cutoff percentage for offensive/defensive rebound
  cutoff <- ((1-offensive_percentage) + defensive_percentage)/2
  
  #Generate random variable which determines the offensive/defensive rebound
  rebound_variable <- runif(1)
  
  #Using the random variable, determine whether the rebound is secured by the offensive or Defensive team
  if(rebound_variable < cutoff) {
    print("Defensive Rebound!")
    
    #Based on the team name, call the appropriate determine rebounder function
    if (team_name == "team1") {
        #Call the determine rebounder function to give individual credit for the rebound
        determine_rebounder(team2[1,"indv_drb"], team2[2,"indv_drb"], team2[3,"indv_drb"], 
                            team2[4,"indv_drb"], team2[5,"indv_drb"], "defense")
    }
    else {
        #Call the determine rebounder function to give individual credit for the rebound
        determine_rebounder(team1[1,"indv_drb"], team1[2,"indv_drb"], team1[3,"indv_drb"], 
                            team1[4,"indv_drb"], team1[5,"indv_drb"], "defense")
    }
  }
  else{
    print("Offensive Rebound!")
    
    #Based on the team name, call the appropriate determine rebounder function
    if (team_name == "team1") {
        #Call the determine rebounder function to give individual credit for the rebound
        determine_rebounder(team1[1,"indv_orb"], team1[2,"indv_orb"], team1[3,"indv_orb"], 
                            team1[4,"indv_orb"], team1[5,"indv_orb"], "offense")      
    }
    else {
        #Call the determine rebounder function to give individual credit for the rebound
        determine_rebounder(team2[1,"indv_orb"], team2[2,"indv_orb"], team2[3,"indv_orb"], 
                            team2[4,"indv_orb"], team2[5,"indv_orb"], "offense")      
    }
  }
}


