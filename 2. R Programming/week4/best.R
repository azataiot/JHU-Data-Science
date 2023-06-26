# The function reads the outcome-of-care-measures.csv file and
# returns a character vector with the name of the hospital
# that has the best (i.e. lowest) 30-day mortality
# for the specified outcome in that state.

best <- function(state, outcome) {
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
  
  # validate state
  if (!(state %in% valid_states)) {
    stop("invalid state")
  }
  # validate outcome
  if (!(outcome %in% names(valid_outcomes))) {
    stop("invalid outcome")
  }
  
  ## Select data for the specific state and outcome
  state_data <- subset(outcome_data, State == state)
  state_data <-
    state_data[!is.na(state_data[[valid_outcomes[outcome]]]),]
  state_data[[valid_outcomes[outcome]]] <-
    as.numeric(state_data[[valid_outcomes[outcome]]])
  
  ## Return hospital name in that state with lowest 30-day death
  best_hospital <-
    state_data[which.min(state_data[[valid_outcomes[outcome]]]), "Hospital.Name"]
  return(best_hospital)
}