source("utils.R")

existing_date <- (Sys.Date() - 1)

read_wdqs <- function(){
  data <- polloi::read_dataset("wdqs/wdqs_aggregates.tsv")
  data <- data[order(data$timestamp),]
  wdqs_usage <<- dplyr::filter(data, path == "/" & http_success) %>%
    dplyr::select(c(timestamp, events))
  
  sparql_usage <<- dplyr::filter(data, path == "/bigdata/namespace/wdq/sparql" & http_success) %>%
    dplyr::select(c(timestamp, events))
  return(invisible())
}

shinyServer(function(input, output) {
  
  if(Sys.Date() != existing_date){
    read_wdqs()
    existing_date <<- Sys.Date()
  }
  
  output$wdqs_usage_plot <- renderDygraph(
    polloi::make_dygraph(data = as.data.frame(wdqs_usage), xlab = "Date", ylab = "Events",
                         title = "Daily WDQS Homepage usage")
  )
  
  output$sparql_usage_plot <- renderDygraph(
    polloi::make_dygraph(data = as.data.frame(sparql_usage), xlab = "Date", ylab = "Events",
                         title = "Daily SPARQL usage")
  )
  
})