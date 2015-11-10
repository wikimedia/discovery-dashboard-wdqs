#Dependent libs
library(reshape2)
library(polloi)
library(dplyr)

read_wdqs <- function() {
  data <- polloi::read_dataset("wdqs/wdqs_aggregates.tsv") %>%
    dplyr::rename(date = timestamp) %>%
    dplyr::arrange(date)
  
  wdqs_usage <<- data %>%
    dplyr::filter(path == "/" & http_success) %>%
    dplyr::select(c(date, events)) %>% as.data.frame
  
  sparql_usage <<- data %>%
    dplyr::filter(path == "/bigdata/namespace/wdq/sparql" & http_success) %>%
    dplyr::select(c(date, events)) %>% as.data.frame
    
  return(invisible())
}
