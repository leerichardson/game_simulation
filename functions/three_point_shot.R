three_point_shot <- function(three_percentage) {
  shot <- runif(1)
  if (shot < three_percentage) {
    print("Made Three Point Shot")
  }
  else {
    print("Missed Three Point Shot")
  }
}