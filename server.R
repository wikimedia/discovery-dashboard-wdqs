source("utils.R")

existing_date <- Sys.Date() - 1

shinyServer(function(input, output) {
  
  if(Sys.Date() != existing_date){
    read_wdqs()
    existing_date <<- Sys.Date()
  }
  
  # Wrap time_frame_range to provide global settings
  time_frame_range <- function(input_local_timeframe, input_local_daterange) {
    return(polloi::time_frame_range(input_local_timeframe, input_local_daterange, input$timeframe_global, input$daterange_global))
  }
  
  output$wdqs_usage_plot <- renderDygraph(
    wdqs_usage %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_usage)) %>%
      polloi::subset_by_date_range(time_frame_range(input$usage_timeframe, input$usage_timeframe_daterange)) %>%
      spider_subset(val = input$include_automata) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Events", title = "Daily WDQS Homepage usage", group = "usage") %>%
      dyLegend(labelsDiv = "usage_legend") %>%
      dyAnnotation(as.Date("2015-09-07"), text = "A", tooltip = "WDQS Announced Publically")
  )
  
  output$sparql_usage_plot <- renderDygraph(
    sparql_usage %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_usage)) %>%
      polloi::subset_by_date_range(time_frame_range(input$usage_timeframe, input$usage_timeframe_daterange)) %>%
      spider_subset(val = input$include_automata) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Events", title = "Daily SPARQL usage", group = "usage") %>%
      dyLegend(labelsDiv = "usage_legend") %>%
      dyAnnotation(as.Date("2015-09-07"), text = "A", tooltip = "WDQS Announced Publically") %>%
      dyAnnotation(as.Date("2015-11-05"), text = "B", tooltip = "Possible Broken Bot on Labs")
  )
  
  # Check datasets for missing data and notify user which datasets are missing data (if any)
  output$message_menu <- renderMenu({
    notifications <- list(
      polloi::check_yesterday(sparql_usage, "SPARQL usage data"),
      polloi::check_past_week(sparql_usage, "SPARQL usage data"))
    notifications <- notifications[!sapply(notifications, is.null)]
    return(dropdownMenu(type = "notifications", .list = notifications))
  })
  
})
