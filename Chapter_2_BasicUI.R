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
