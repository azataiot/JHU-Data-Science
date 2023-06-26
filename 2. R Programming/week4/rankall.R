# The function reads the outcome-of-care-measures.csv file and 
# returns a 2-column data frame containing the hospital in each state 
# that has the ranking specified in num.

rankall <- function(outcome, num = "best") {
  ## Read outcome data
  outcome_data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  ## Check that outcome is valid
  valid_outcomes <- c("heart attack" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
                      "heart failure" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
                      "pneumonia" = "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia")
  
  if (!(outcome %in% names(valid_outcomes))) {
    stop("invalid outcome")
  }
  
  ## Get list of states
  states <- unique(outcome_data$State)
  
  ## Initialize an empty data frame to hold results
  results <- data.frame(hospital = character(length(states)), state = states, stringsAsFactors = FALSE)
  
  ## For each state, find the hospital of the given rank
  for (i in seq_along(states)) {
    state_data <- subset(outcome_data, State == states[i])
    state_data <- state_data[!is.na(state_data[[valid_outcomes[outcome]]]), ]
    state_data[[valid_outcomes[outcome]]] <- as.numeric(state_data[[valid_outcomes[outcome]]])
    
    ## Order the data
    state_data <- state_data[order(state_data[[valid_outcomes[outcome]]], state_data$Hospital.Name), ]
    
    ## Handle num argument
    if (num == "best") {
      rank = 1
    } else if (num == "worst") {
      rank = nrow(state_data)
    } else if (is.numeric(num)) {
      if (num > nrow(state_data)) {
        rank = NA
      } else {
        rank = num
      }
    } else {
      stop("invalid num argument")
    }
    
    ## Add hospital name of the given rank to the results data frame
    results$hospital[i] <- state_data$Hospital.Name[rank]
  }
  
  ## Drop the rows with NA in the hospital column
  results <- na.omit(results)
  
  ## Sort the results by state
  results <- results[order(results$state), ]
  
  ## Return a data frame with the hospital names and the (abbreviated) state name
  return(results)
}