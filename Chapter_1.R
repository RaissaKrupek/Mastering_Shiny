#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

##########################################################################################
install.packages(c("gapminder", "ggforce", "gh", "globals", "openintro", "profvis",
                   "RSQLite", "shiny", "shinycssloaders", "shinyFeedback", "shinythemes",
                   "testthat", "thematic", "tidyverse", "vroom", "waiter", "xml2", "zeallot"
))

install.packages("shiny")
library(shiny)
ui <- fluidPage ( 
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
  verbatimTextOutput("summary"),
  tableOutput("table")
)
server <- function(input, output, session) {
    dataset <- reactive({
      get (input$dataset, "package:datasets")
    })
  output$summary <- renderPrint({
    summary(dataset())
  }) 
  
  output$table <- renderTable ({
    dataset()
  })
}
shinyApp(ui, server)                                 



#Exercise 1: Create an app that greets the user by name.

library(shiny)
ui <- fluidPage( 
  textInput("name", "What is your name"),
  textOutput("greeting")
  )
server <- function(input, output, session) {
  output$greeting <- renderText({
    paste0("Hello", input$name)
  })
}
shinyApp(ui, server)  

#Exercise 2:find and correct the error -> solution

library(shiny)
ui <- fluidPage(
  sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
  "then x times 5 is",
  textOutput("product")
)
server <- function(input, output, session) {
  output$product <- renderText({
    input$x * 5
  })
}
shinyApp(ui, server)

#Exercise 3: Extend the app from the previous exercise to allow the user to set the value of the multiplier, y,
#so that the app yields the value of x * y -> solution

library(shiny)
ui <- fluidPage(
  sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", label = "If y is", min = 1, max = 50, value = 30),
  "then x times y is",
  textOutput("product")
)
server <- function(input, output, session) {
  output$product <- renderText({
    input$x * input$y
  })
}
shinyApp(ui, server)

#Exercise 4: reduce the amount of duplicated code in the app by using a reactive expression -> solution

library(shiny)
ui <- fluidPage(
  sliderInput("x", "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", "and y is", min = 1, max = 50, value = 5),
  "then, (x * y) is", textOutput("product"),
  "and, (x * y) + 5 is", textOutput("product_plus5"),
  "and (x * y) + 10 is", textOutput("product_plus10")
)
server <- function(input, output, session) {
  product <- reactive({input$x * input$y})
  
  output$product <- renderText( product() )
  output$product_plus5 <- renderText( product() + 5)
  output$product_plus10 <- renderText( product() + 10)
}
shinyApp(ui, server)

#Exercise 5: In the following app you select a dataset from a package (this time 
#we're using the ggplot2 package) and the app prints out a summary and plot of the data. 
#It also follows good practice and makes use of reactive expressions to avoid redundancy of code.
#However there are 2 bugs in the code provided below. Can you find and fix them?

library(shiny)
library(ggplot2)
datasets <- c("economics", "faithfuld", "seals")
ui <- fluidPage(
  selectInput("dataset", "Dataset", choices = datasets),
  verbatimTextOutput("summary"),
  tableOutput("plot")
)
server <- function(input, output, session) {
  dataset <- reactive({
    get(input$dataset, "package:ggplot2")
  })
  output$summary <- renderPrint({
    summary(dataset())
  })
  output$plot <- renderPlot({
    plot(dataset)
  }, res = 96)
}
shinyApp(ui, server)

#------------solution------------
# 1. In the UI, the `tableOutput` object should really be a `plotOutput`.  
# 2. In the server, the `plot` function in the `output$plot should call dataset()

library(shiny)
library(ggplot2)
datasets <- c("economics", "faithfuld", "seals")

ui <- fluidPage(
  selectInput("dataset", "Dataset", choices = datasets),
  verbatimTextOutput("summary"),
  plotOutput("plot")
)
server <- function(input, output, session) {
  
  dataset <- reactive({get(input$dataset, "package:ggplot2")})
  
  output$summary <- renderPrint(summary(dataset()))
  
  output$plot <- renderPlot(plot(dataset()), res = 96)
}
shinyApp(ui, server)

