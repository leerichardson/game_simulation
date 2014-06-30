free_throw <- function(team, free_throw_percentage, num_shots) {
#Initialize the number of points
  total_points <- 0
#Shoot all of the fre throws that aren't the last one.  
  while(num_shots > 1) {
    shot <- runif(1)
    if(shot < free_throw_percentage) {
      total_points <- total_points + 1 
    }
    num_shots <- num_shots - 1 
  }

#Generate variable for the last shot
  shot_final <- runif(1)
  if (shot_final < free_throw_percentage) {
    print(paste("Total Points:", total_points, ": Made final Shot"))
  }
  else {
    print(paste("Total Points:", total_points, ": Missed final Shot"))
  }
}
