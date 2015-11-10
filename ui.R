library(shiny)
library(shinydashboard)
library(dygraphs)

# Header elements for the visualization
header <- dashboardHeader(title = "Wikidata Query Service", disable = FALSE)

# Sidebar elements for the search visualizations
sidebar <- dashboardSidebar(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    tags$script(src = "custom.js")
  ),
  sidebarMenu(
    menuItem(text = "WDQS Usage", tabName = "wdqs_usage"),
    menuItem(text = "Global Settings",
             selectInput(inputId = "smoothing_global", label = "Smoothing", selectize = TRUE, selected = "day",
                         choices = c("No Smoothing" = "day", "Weekly Median" = "week", "Monthly Median" = "month")),
             selectInput(inputId = "timeframe_global", label = "Time Frame", selectize = TRUE, selected = "",
                         choices = c("All available data" = "all", "Last 7 days" = "week", "Last 30 days" = "month",
                                     "Last 90 days" = "quarter", "Custom" = "custom")),
             conditionalPanel("input.timeframe_global == 'custom'",
                              dateRangeInput("daterange_global", label = "Custom Date Range",
                                             start = Sys.Date()-11, end = Sys.Date()-1, min = "2015-04-14")),
             icon = icon("cog", lib = "glyphicon"))
  )
)

#Body elements for the search visualizations.
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "wdqs_usage",
            fluidRow(
              column(polloi::smooth_select("smoothing_usage"), width = 3),
              column(polloi::timeframe_select("usage_timeframe"), width = 3),
              column(polloi::timeframe_daterange("usage_timeframe"), width = 3),
              column(div(id = "usage_legend"), width = 3)),
            dygraphOutput("wdqs_usage_plot", height = "200px"),
            dygraphOutput("sparql_usage_plot", height = "200px"),
            includeMarkdown("./tab_documentation/wdqs_basic.md"))
  )
)

dashboardPage(header, sidebar, body, skin = "purple",
              title = "WDQS Usage Dashboard | Discovery | Engineering | Wikimedia Foundation")
