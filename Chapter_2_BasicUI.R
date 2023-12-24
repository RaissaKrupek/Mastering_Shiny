########################INPUTS##############################

library(shiny)
ui <- fluidPage(
  )
server<- function (input, output, session){}
shinyApp(ui, server)

#FREE TEXT
textInput("name", "What's your name?"),
passwordInput("password", "What's your password?"),
textAreaInput("story", "Tell me about yourself", rows = 3)

#NUMERIC INPUTS
numericInput("num", "Number one", value = 0, min = 0, max = 100),
sliderInput("num2", "Number two", value = 50, min = 0, max = 100),
sliderInput("rng", "Range", value = c(10, 20), min = 0, max = 100)

#DATES
dateInput("dob", "When were you born?"), #dob = ID para date of birth
dateRangeInput("holiday", "When do you want to go on vacation next?")

#LIMITED CHOICES
selectInput("state", "What's your favourite state?", state.name),
radioButtons("animal", "What's your favourite animal?", animals)
#---------------------------------------------------------------
radioButtons("rb", "Choose one:",
             choiceNames = list(
               icon("angry"),
               icon("smile"),
               icon("sad-tear")
             ),
             choiceValues = list("angry", "happy", "sad")
)
#---------------------------------------------------------------
selectInput("state", "What's your favourite state?", state.name,
            multiple = TRUE)
#---------------------------------------------------------------
checkboxGroupInput("states", "What states do you like?", state.name)
#---------------------------------------------------------------
checkboxInput("cleanup", "Clean up?", value = FALSE),
checkboxInput("shutdown", "Shutdown?")

#FILE UPLOADS
fileInput("upload", NULL)

#ACTION BUTTONS
actionButton("click", "Click me!"),
actionButton("drink", "Drink me!", icon = icon("cocktail"))
##To costumize the appearance: "btn-primary", "btn-success", "btn-info", "btn-warning", or "btn-danger".
##To change the size: "btn-lg", "btn-sm", or "btn-xs".
##To span the entire width of the element "btn-block"


#Exercise 1: When space is at a premium, it’s useful to label text boxes using a placeholder
#that appears inside the text entry area. How do you call textInput() to generate
#the following UI? -> solution 

library(shiny)
ui <- fluidPage(
  textInput("name", "", "", placeholder = "Your name")
)
server <- function(input, output, session){
}
shinyApp(ui, server)
  
#Exercise 2: Carefully read the documentation for sliderInput() to figure out how to create a date slider

library(shiny)
ui <- fluidPage(
  sliderInput("dates", "When should we deliver?", 
              value = as.Date("2020-09-17"), 
              min = as.Date("2020-09-16"), 
              max = as.Date("2020-09-23"))
)
server <- function(input, output, session){
}
shinyApp(ui, server)

#Exercise 3: Create a slider input to select values between 0 and 100 where the interval
# between each selectable value on the slider is 5. Then, add animation to the input
# widget so when the user presses play, the input widget scrolls through the range
# automatically.

library(shiny)
ui <- fluidPage(
  sliderInput("values", "select a number", 
              value = 50, 
              min = 0, 
              max = 100,
              step = 5,
              animate = TRUE)
)
server <- function(input, output, session){
}
shinyApp(ui, server)


########################OUTPUTS##############################

#TEXT
ui <- fluidPage(
  textOutput("text"),
  verbatimTextOutput("code")
)
server <- function(input, output, session) {
  output$text <- renderText({
    "Hello friend!"
  })
  output$code <- renderPrint({
    summary(1:10)
  })
}
shinyApp(ui, server)

##with {} omitted
server <- function(input, output, session) {
  output$text <- renderText("Hello friend!")
  output$code <- renderPrint(summary(1:10))
}

#TABLES
ui <- fluidPage(
  tableOutput("static"),
  dataTableOutput("dynamic")
)
server <- function(input, output, session) {
  output$static <- renderTable(head(mtcars))
  output$dynamic <- renderDataTable(mtcars, options = list(pageLength = 5))
}
shinyApp(ui, server)

#PLOTS
ui <- fluidPage(
  plotOutput("plot", width = "400px")
)
server <- function(input, output, session) {
  output$plot <- renderPlot(plot(1:5), res = 96)
}
shinyApp(ui, server)


# Exercise 1: Which of textOutput() and verbatimTextOutput() should each of the follow‐
#ing render functions be paired with?

#renderPrint(summary(mtcars)) --> verbatimTextOutput()
#renderText("Good morning!") --> textOutput()
#renderPrint(t.test(1:5, 2:6)) --> verbatimTextOutput()
#renderText(str(lm(mpg ~ wt, data = mtcars))) --> textOutput()

# Exercise 2: Re-create the Shiny app from “Plots” on page 25, this time setting height to 300px
#and width to 700px. Set the plot “alt” text so that a visually impaired user can tell
#that it’s a scatterplot of five random numbers.

library(shiny)
ui <- fluidPage(
  plotOutput("plot", width = "700px", height = "300px", alt = "Scatterplot of numbers from 1 to 5")
)
server <- function(input, output, session) {
  output$plot <- renderPlot(plot(1:5), res = 96)
}
shinyApp(ui, server)

# Exercise 3: Update the options in the call to renderDataTable() so that the data is displayed
#but all other controls are suppressed (i.e., remove the search, ordering, and filtering commands).

library(shiny)
ui <- fluidPage(
dataTableOutput("table")
)
server <- function(input, output, session) {
  output$table <- renderDataTable(mtcars, options = list(pageLength = 5,
                                                         searching = FALSE,  # Suppress search bar
                                                         ordering = FALSE,   # Disable ordering
                                                         filtering = FALSE)) # Suppress filtering
}
shinyApp(ui, server)

