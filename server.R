source("utils.R")

existing_date <- (Sys.Date() - 1)

read_wdqs <- function(){
  data <- download_set("wdqs_aggregates.tsv")
  data <- data[order(data$timestamp),]
  wdqs_usage <<- data
  return(invisible())
}

shinyServer(function(input, output) {
  
  if(Sys.Date() != existing_date){
    read_wdqs()
    existing_date <<- Sys.Date()
  }
  
  output$wdqs_usage_plot <- renderDygraph({
    wdqs_usage %>%
      dplyr::filter(path == "/" & http_success) %>%
      dplyr::select(c(timestamp, events)) %>%
      { xts(dplyr::select(., -timestamp), order.by = .$timestamp) } %>%
      dygraph(main = "Daily WDQS Homepage usage", group = "wdqs_basic",
              xlab = "Date", ylab = "Events") %>%
      dyOptions(strokeWidth = 3, colors = brewer.pal(3, "Set2")[1],
                drawPoints = TRUE, pointSize = 3, labelsKMB = TRUE,
                includeZero = TRUE) %>%
      dyCSS(css = "./assets/dataviz.css")
  })
  
  output$sparql_usage_plot <- renderDygraph({
    wdqs_usage %>%
      dplyr::filter(path == "/bigdata/namespace/wdq/sparql" & http_success) %>%
      dplyr::select(c(timestamp, events)) %>%
      { xts(dplyr::select(., -timestamp), order.by = .$timestamp) } %>%
      dygraph(main = "Daily SPARQL usage", group = "wdqs_basic",
              xlab = "Date", ylab = "Events") %>%
      dyOptions(strokeWidth = 3, colors = brewer.pal(3, "Set2")[2],
                drawPoints = TRUE, pointSize = 3, labelsKMB = TRUE,
                includeZero = TRUE) %>%
      dyCSS(css = "./assets/dataviz.css")
  })
  
})