library(shiny)
library(shinydashboard)
library(dygraphs)

spider_checkbox <- function(input_id) {
  shiny::checkboxInput(input_id, "Include automata", value = TRUE, width = NULL)
}

function(request) {
  dashboardPage(

    dashboardHeader(title = "Wikidata Query Service", dropdownMenuOutput("message_menu"), disable = FALSE),

    dashboardSidebar(
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
        tags$script(src = "custom.js")
      ),
      sidebarMenu(id = "tabs",
                  menuItem(text = "Endpoint Usage", tabName = "endpoint_usage"),
                  menuItem(text = "WDQS Visits", tabName = "wdqs_visits"),
                  menuItem(text = "Global Settings",
                           selectInput(inputId = "smoothing_global", label = "Smoothing", selectize = TRUE, selected = "day",
                                       choices = c("No Smoothing" = "day", "Weekly Median" = "week", "Monthly Median" = "month", "Splines" = "gam")),
                           icon = icon("cog", lib = "glyphicon"))
      ),
      div(icon("info-sign", lib = "glyphicon"), HTML("<strong>Tip</strong>: you can drag on the graphs with your mouse to zoom in on a particular date range."), style = "padding: 10px; color: white;"),
      div(bookmarkButton(), style = "text-align: center;")
    ),

    dashboardBody(
      tabItems(
        tabItem(tabName = "endpoint_usage",
                fluidRow(
                  column(polloi::smooth_select("smoothing_usage"), width = 4),
                  column(checkboxInput("usage_logscale", "Use Log scale", TRUE), width = 4),
                  column(spider_checkbox("include_automata_usage"), width = 4)),
                dygraphOutput("sparql_usage_plot", height = "200px"),
                dygraphOutput("ldf_usage_plot", height = "200px"),
                fluidRow(div(id = "usage_legend"), style = "padding-top: 10px; height: 20px; text-align: center;"),
                includeMarkdown("./tab_documentation/wdqs_usage.md")),
        tabItem(tabName = "wdqs_visits",
                fluidRow(
                  column(polloi::smooth_select("smoothing_visits"), width = 4),
                  column(checkboxInput("visits_logscale", "Use Log scale", TRUE), width = 4),
                  column(spider_checkbox("include_automata_visits"), width = 4)),
                dygraphOutput("wdqs_visits_plot", height = "400px"),
                fluidRow(div(id = "wdqs_visits_legend"), style = "padding-top: 10px; height: 20px; text-align: center;"),
                includeMarkdown("./tab_documentation/wdqs_visits.md"))
      )
    ),

    skin = "purple", title = "WDQS Usage Dashboard | Discovery | Engineering | Wikimedia Foundation")
}
