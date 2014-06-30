#Function that takes as an input a players two point percentage, and outputs whether the shot is made or missed. 
two_point_shot <- function(team, two_percentage) {
  shot <- runif(1)
  if (shot < two_percentage) {
    print("Made two Point Shot")
  }
  else {
    print("Missed two Point Shot")
  }
}