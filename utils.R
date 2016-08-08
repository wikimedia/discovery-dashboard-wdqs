#Dependent libs
library(reshape2)
library(polloi)
library(dplyr)

read_wdqs <- function() {
  data <- polloi::read_dataset("wdqs/wdqs_aggregates_new.tsv") %>%
    dplyr::arrange(date)
  
  wdqs_usage <<- data %>%
    dplyr::filter(path == "/" & http_success) %>%
    dplyr::select(c(date, is_automata, events)) %>% as.data.frame
  
  sparql_usage <<- data %>%
    dplyr::filter(path == "/bigdata/namespace/wdq/sparql" & http_success) %>%
    dplyr::select(c(date, is_automata, events)) %>% as.data.frame
    
  return(invisible())
}

spider_checkbox <- function(input_id){
  checkboxInput(input_id, "Include automata", value = TRUE, width = NULL)
}

spider_subset <- function(data, val){
  
  if(!val){
    data <- data[!data$is_automata,]
  }
  
  return({
    data %>% group_by(date) %>%
      summarise(events = sum(events))
  })
}

conditional_transform <- function(x, cond, .f, ...) {
  if (cond) {
    return(data_transform(x, .f, ...))
  } else {
    return(x)
  }
}

data_transform <- function(x, .f = identity, ...) {
  col_names <- setdiff(colnames(x), c("Date", "date", "timestamp"))
  x[, col_names] <- .f(x[, col_names], ...)
  return(x)
}
