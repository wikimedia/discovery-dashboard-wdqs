library(shiny)
library(shinydashboard)
library(dygraphs)

source("utils.R")

existing_date <- Sys.Date() - 1

shinyServer(function(input, output, session) {

  if(Sys.Date() != existing_date){
    read_wdqs()
    existing_date <<- Sys.Date()
  }

  output$ldf_usage_plot <- renderDygraph(
    ldf_usage %>%
      spider_subset(val = input$include_automata_usage) %>%
      # The next few lines make for better smoothing because the data is first log-transformed:
      conditional_transform(input$usage_logscale && polloi::smooth_switch(input$smoothing_global, input$smoothing_usage) != "day", log10) %>%
      # ...THEN smoothed:
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_usage), rename = FALSE) %>%
      # ...and then exp10-transformed back to the original scale:
      conditional_transform(input$usage_logscale && polloi::smooth_switch(input$smoothing_global, input$smoothing_usage) != "day", exp10) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Requests", title = "Daily LDF usage", group = "usage") %>%
      # ...because we're using dygraphs' native log-scaling:
      dyAxis("y", logscale = input$usage_logscale) %>%
      dyLegend(labelsDiv = "usage_legend") %>%
      dyRangeSelector %>%
      dyEvent(as.Date("2017-01-01"), "D (Started tracking LDF usage)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
  )

  output$sparql_usage_plot <- renderDygraph(
    sparql_usage %>%
      spider_subset(val = input$include_automata_usage) %>%
      # See above for why we're conditional_transform'ing here.
      conditional_transform(input$usage_logscale && polloi::smooth_switch(input$smoothing_global, input$smoothing_usage) != "day", log10) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_usage), rename = FALSE) %>%
      conditional_transform(input$usage_logscale && polloi::smooth_switch(input$smoothing_global, input$smoothing_usage) != "day", exp10) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Requests", title = "Daily SPARQL usage", group = "usage") %>%
      dyLegend(labelsDiv = "usage_legend") %>%
      dyAxis("y", logscale = input$usage_logscale) %>%
      dyRangeSelector %>%
      dyEvent(as.Date("2015-09-07"), "A (Announcement)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2015-11-05"), "B (Labs bot)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-12-28"), "C (Bot ruleset)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
  )

  output$wdqs_visits_plot <- renderDygraph(
    wdqs_visits %>%
      spider_subset(val = input$include_automata_visits) %>%
      # The next few lines make for better smoothing because the data is first log-transformed:
      conditional_transform(input$visits_logscale && polloi::smooth_switch(input$smoothing_global, input$smoothing_visits) != "day", log10) %>%
      # ...THEN smoothed:
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_visits), rename = FALSE) %>%
      # ...and then exp10-transformed back to the original scale:
      conditional_transform(input$visits_logscale && polloi::smooth_switch(input$smoothing_global, input$smoothing_visits) != "day", exp10) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Pageviews", title = "Daily WDQS Homepage Traffic") %>%
      # ...because we're using dygraphs' native log-scaling:
      dyAxis("y", logscale = input$visits_logscale) %>%
      dyLegend(labelsDiv = "wdqs_visits_legend") %>%
      dyEvent(as.Date("2015-09-07"), "A (Announcement)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
  )

  # Check datasets for missing data and notify user which datasets are missing data (if any)
  output$message_menu <- renderMenu({
    notifications <- list(
      polloi::check_yesterday(sparql_usage, "WDQS usage data"),
      polloi::check_past_week(sparql_usage, "WDQS usage data"))
    notifications <- notifications[!sapply(notifications, is.null)]
    return(dropdownMenu(type = "notifications", .list = notifications))
  })

})
