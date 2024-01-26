################ Layout #################
# Tabsets quebram a pagina horizontalmente

library(shiny)
ui <- fluidPage(
  tabsetPanel(
    tabPanel("Import data",
             fileInput("file", "Data", buttonLabel = "Upload..."),
             textInput("delim", "Delimiter (leave blank to guess)", ""),
             numericInput("skip", "Rows to skip", 0, min = 0),
             numericInput("rows", "Rows to preview", 10, min = 1)
    ),
    tabPanel("Set parameters"),
    tabPanel("Visualise results")
  )
)
server <- function(input, output, session){}
shinyApp(ui, server)


library(shiny)
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textOutput("panel")
    ),
    mainPanel(
      tabsetPanel(
        id = "tabset",
        tabPanel("panel 1", "one"),
        tabPanel("panel 2", "two"),
        tabPanel("panel 3", "three")
      )
    )
  )
)
server <- function(input, output, session){
  output$panel <- renderText ({
    paste ("Current panel: ", input$tabset)
  })
}
shinyApp(ui, server)

#Navlists and Navbars quebram a pagina verticalmente 

library(shiny)
ui <- fluidPage(
  navlistPanel(
    id = "tabset",
    "Heading 1",
    tabPanel("panel 1", "Panel one contents"),
    "Heading 2",
    tabPanel("panel 2", "Panel two contents"),
    tabPanel("panel 3", "Panel three contents")
  )
)
server <- function(input, output, session){}
shinyApp(ui, server)

# adicionalmente a funcao navbarMenu() coloca um outro nivel hierarquico

library(shiny)
ui <- navbarPage(
  "Page title",
  tabPanel("panel 1", "one"),
  tabPanel("panel 2", "two"),
  tabPanel("panel 3", "three"),
  navbarMenu("subpanels",
             tabPanel("panel 4a", "four-a"),
             tabPanel("panel 4b", "four-b"),
             tabPanel("panel 4c", "four-c")
  )
)
server <- function(input, output, session){}
shinyApp(ui, server)

############### Shiny Themes ###############

library(shiny)
ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "darkly"),
  sidebarLayout(
    sidebarPanel(
      textInput("txt", "Text input:", "text here"),
      sliderInput("slider", "Slider input:", 1, 100, 30)
    ),
    mainPanel(
      h1(paste0("Theme: darkly")),
      h2("Header 2"),
      p("Some text")
    )
  )
)
server <- function(input, output, session){}
shinyApp(ui, server)

# Construindo seu proprio tema
# theme <- bslib::bs_theme(
#   bg = "#0b3d91",
#   fg = "white",
#   base_font = "Source Sans Pro"
# )

# Plot Themes: thematic::thematic_shiny() configura o plot de acordo com o tema do app

library(shiny)
library(ggplot2)
ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "darkly"),
  titlePanel("A themed plot"),
  plotOutput("plot"),
)
server <- function(input, output, session) {
  thematic::thematic_shiny()
  output$plot <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) +
      geom_point() +
      geom_smooth()
  }, res = 96)
}
server <- function(input, output, session){}
shinyApp(ui, server)
