two_point_shot <- function(two_percentage) {
  shot <- runif(1)
  if (shot < two_percentage) {
    print("Made two Point Shot")
  }
  else {
    print("Missed two Point Shot")
  }
}