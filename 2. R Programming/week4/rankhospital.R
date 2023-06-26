# The function reads the outcome-of-care-measures.csv file and 
# returns a character vector with the name of the hospital 
# that has the ranking specified by the num argument.

rankhospital <- function(state, outcome, num = "best") {
  ## Read outcome data
  outcome_data <-
    read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  ## Check that state and outcome are valid
  valid_states <- unique(outcome_data$State)
  valid_outcomes <-
    c(
      "heart attack" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
      "heart failure" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
      "pneumonia" = "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
    )
  
  if (!(state %in% valid_states)) {
    stop("invalid state")
  }
  
  if (!(outcome %in% names(valid_outcomes))) {
    stop("invalid outcome")
  }
  
  ## Select data for the specific state and outcome
  state_data <- subset(outcome_data, State == state)
  state_data <-
    state_data[!is.na(state_data[[valid_outcomes[outcome]]]),]
  state_data[[valid_outcomes[outcome]]] <-
    as.numeric(state_data[[valid_outcomes[outcome]]])
  
  ## Order the data
  state_data <-
    state_data[order(state_data[[valid_outcomes[outcome]]], state_data$Hospital.Name),]
  
  ## Handle num argument
  if (num == "best") {
    rank = 1
  } else if (num == "worst") {
    rank = nrow(state_data)
  } else if (is.numeric(num)) {
    if (num > nrow(state_data)) {
      return(NA)
    } else {
      rank = num
    }
  } else {
    stop("invalid num argument")
  }
  
  ## Return hospital name in that state with the given rank 30-day death rate
  return(state_data$Hospital.Name[rank])
}
