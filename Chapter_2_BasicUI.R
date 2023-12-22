########################INPUTS##############################

library(shiny)
ui <- fluidPage(
  )
server<- function (input, output, session){}
shinyApp(ui, server)

#Free Text
textInput("name", "What's your name?"),
passwordInput("password", "What's your password?"),
textAreaInput("story", "Tell me about yourself", rows = 3)

#Numeric Imputs
numericInput("num", "Number one", value = 0, min = 0, max = 100),
sliderInput("num2", "Number two", value = 50, min = 0, max = 100),
sliderInput("rng", "Range", value = c(10, 20), min = 0, max = 100)

#Dates
dateInput("dob", "When were you born?"), #dob = ID para date of birth
dateRangeInput("holiday", "When do you want to go on vacation next?")

#Limited Choices 
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

#File Uploads
fileInput("upload", NULL)

#Action Buttons
actionButton("click", "Click me!"),
actionButton("drink", "Drink me!", icon = icon("cocktail"))
##To costumize the appearance: "btn-primary", "btn-success", "btn-info", "btn-warning", or "btn-danger".
##To change the size: "btn-lg", "btn-sm", or "btn-xs".
##To span the entire width of the element "btn-block"


########################OUTPUTS#############################
