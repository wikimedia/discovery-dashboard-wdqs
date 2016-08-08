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
      spider_subset(val = input$include_automata) %>%
      # The next few lines make for better smoothing because the data is first log-transformed:
      conditional_transform(input$usage_logscale && polloi::smooth_switch(input$smoothing_global, input$smoothing_usage) != "day", log10) %>%
      # ...THEN smoothed:
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_usage), rename = FALSE) %>%
      # ...and then exp-transformed back to the original scale:
      conditional_transform(input$usage_logscale && polloi::smooth_switch(input$smoothing_global, input$smoothing_usage) != "day", exp) %>%
      polloi::subset_by_date_range(time_frame_range(input$usage_timeframe, input$usage_timeframe_daterange)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Events", title = "Daily WDQS Homepage usage", group = "usage") %>%
      # ...because we're using dygraphs' native log-scaling:
      dyAxis("y", logscale = input$usage_logscale) %>%
      dyLegend(labelsDiv = "usage_legend") %>%
      dyEvent(as.Date("2015-09-07"), "A (Announcement)", labelLoc = "bottom")
  )
  
  output$sparql_usage_plot <- renderDygraph(
    sparql_usage %>%
      spider_subset(val = input$include_automata) %>%
      # See above for why we're conditional_transform'ing here.
      conditional_transform(input$usage_logscale && polloi::smooth_switch(input$smoothing_global, input$smoothing_usage) != "day", log10) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_usage), rename = FALSE) %>%
      conditional_transform(input$usage_logscale && polloi::smooth_switch(input$smoothing_global, input$smoothing_usage) != "day", exp) %>%
      polloi::subset_by_date_range(time_frame_range(input$usage_timeframe, input$usage_timeframe_daterange)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Events", title = "Daily SPARQL usage", group = "usage") %>%
      dyLegend(labelsDiv = "usage_legend") %>%
      dyAxis("y", logscale = input$usage_logscale) %>%
      dyRangeSelector %>%
      dyEvent(as.Date("2015-09-07"), "A (Announcement)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2015-11-05"), "B (Labs bot)", labelLoc = "bottom")
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
