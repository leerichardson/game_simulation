player_possession <- function(to_percentage, two_percentage, ft_percentage, three_percentage) {
  #Normalize the four different outcomes, and Generate a random number which will determine the outcome 
  #of the individual possession
  outcomes <- c(to_percentage, two_percentage, ft_percentage, three_percentage)  
  outcomes_normalized <- outcomes/sum(outcomes)
  #Generate the random number which determines the first event of the possession
  event <- runif(1)
  
  #Using the random number, determine the outcome of the game 
  if (event < outcomes_normalized[1]) {
    print("Turnover!")
  }
  else if(event >= outcomes_normalized[1] & event < outcomes_normalized[1] + outcomes_normalized[2]) {
    print("Two Point Shot")
  }
  else if(event >= outcomes_normalized[1] + outcomes_normalized[2] & event < outcomes_normalized[1] 
          + outcomes_normalized[2] + outcomes_normalized[3]) {
    print("Three Point Shot!")
  }
  else {
    print("Free Throws!")
  }
}