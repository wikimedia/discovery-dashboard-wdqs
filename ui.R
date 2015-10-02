library(shiny)
library(shinydashboard)
library(dygraphs) # optional, used for dygraphs

# Header elements for the visualization
header <- dashboardHeader(title = "Wikidata Query Service", disable = FALSE)

# Sidebar elements for the search visualizations
sidebar <- dashboardSidebar(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    tags$script(src = "custom.js")
  ),
  sidebarMenu(
    menuItem(text = "WDQS Usage", tabName = "wdqs_usage")
  ) # /sidebarMenu
) # /dashboardSidebar

#Body elements for the search visualizations.
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "wdqs_usage",
            dygraphOutput("wdqs_usage_plot", height = "200px"),
            dygraphOutput("sparql_usage_plot", height = "200px"),
            includeMarkdown("./tab_documentation/wdqs_basic.md"))
  ) # /tabItems
) # /dashboardBody

dashboardPage(header, sidebar, body, skin = "purple",
              title = "WDQS Usage Dashboard | Discovery | Engineering | Wikimedia Foundation")