library(shiny)

# Validating Input #
ui <- fluidPage(
  shinyFeedback::useShinyFeedback(),
  numericInput("n", "n", value = 10),
  textOutput("half")
)
server <- function(input, output, session) {
  half <- reactive({
    even <- input$n %% 2 == 0
    shinyFeedback::feedbackWarning("n", !even, "Please select an even number")
    input$n / 2
  })
  output$half <- renderText(half())
}
shinyApp(ui, server)
# the error message is displayed but the output is still updated.


ui <- fluidPage(
  shinyFeedback::useShinyFeedback(),
  numericInput("n", "n", value = 10),
  textOutput("half")
)
server <- function(input, output, session) {
  half <- reactive({
    even <- input$n %% 2 == 0
    shinyFeedback::feedbackWarning("n", !even, "Please select an even number")
    req(even)
    input$n / 2
  })
  output$half <- renderText(half())
}
shinyApp(ui, server)


# Canceling Execution with req() #
ui <- fluidPage(
  selectInput("language", "Language", choices = c("", "English", "Maori")),
  textInput("name", "Name"),
  textOutput("greeting")
)
server <- function(input, output, session) {
  greetings <- c(
    English = "Hello",
    Maori = "Ki ora"
  )
  output$greeting <- renderText({
    paste0(greetings[[input$language]], " ", input$name, "!")
  })
}
shinyApp(ui, server)
# If you run this app, you’ll see an error, because there’s no
#entry in the greetings vector that corresponds to the default choice of ""


ui <- fluidPage(
  selectInput("language", "Language", choices = c("", "English", "Maori")),
  textInput("name", "Name"),
  textOutput("greeting")
)
server <- function(input, output, session) {
  greetings <- c(
    English = "Hello",
    Maori = "Ki ora"
  )
  output$greeting <- renderText({
    req(input$language, input$name)
    paste0(greetings[[input$language]], " ", input$name, "!")
  })
}
# Fixing the problem


# req() and Validation #
ui <- fluidPage(
  shinyFeedback::useShinyFeedback(),
  textInput("dataset", "Dataset name"),
  tableOutput("data")
)
server <- function(input, output, session) {
  data <- reactive({
    req(input$dataset)
    exists <- exists(input$dataset, "package:datasets")
    shinyFeedback::feedbackDanger("dataset", !exists, "Unknown dataset")
    req(exists, cancelOutput = TRUE)
    get(input$dataset, "package:datasets")
  })
  output$data <- renderTable({
    head(data())
  })
}


# Validate Output #
ui <- fluidPage(
  numericInput("x", "x", value = 0),
  selectInput("trans", "transformation",
              choices = c("square", "log", "square-root")
  ),
  textOutput("out")
)
server <- function(input, output, server) {
  output$out <- renderText({
    if (input$x < 0 && input$trans %in% c("log", "square-root")) {
      validate("x can not be negative for this transformation")
    }
    switch(input$trans,
           square = input$x ^ 2,
           "square-root" = sqrt(input$x),
           log = log(input$x)
    )
  })
}
shinyApp(ui, server)


# Transient Notication #
ui <- fluidPage(
  actionButton("goodnight", "Good night")
)
server <- function(input, output, session) {
  observeEvent(input$goodnight, {
    showNotification("So long")
    Sys.sleep(1)
    showNotification("Farewell")
    Sys.sleep(1)
    showNotification("Auf Wiedersehen")
    Sys.sleep(1)
    showNotification("Adieu")
  })
}
shinyApp(ui, server)


# Adding collors
ui <- fluidPage(
  actionButton("goodnight", "Good night")
)
server <- function(input, output, session) {
  observeEvent(input$goodnight, {
    showNotification("So long")
    Sys.sleep(1)
    showNotification("Farewell", type = "message")
    Sys.sleep(1)
    showNotification("Auf Wiedersehen", type = "warning")
    Sys.sleep(1)
    showNotification("Adieu", type = "error")
  })
}
shinyApp(ui, server)
# By default, the message will disappear after five seconds, but you can override it by setting duration,


# Progressive Updates #
ui <- fluidPage(
  tableOutput("data")
)
server <- function(input, output, session) {
  notify <- function(msg, id = NULL) {
    showNotification(msg, id = id, duration = NULL, closeButton = FALSE)
  }
  data <- reactive({
    id <- notify("Reading data...")
    on.exit(removeNotification(id), add = TRUE)
    Sys.sleep(1)
    notify("Reticulating splines...", id = id)
    Sys.sleep(1)
    notify("Herding llamas...", id = id)
    Sys.sleep(1)
    notify("Orthogonalizing matrices...", id = id)
    Sys.sleep(1)
    mtcars
  })
  output$data <- renderTable(head(data()))
}
shinyApp(ui, server)


# Progress Bars #
ui <- fluidPage(
  numericInput("steps", "How many steps?", 10),
  actionButton("go", "go"),
  textOutput("result")
)
server <- function(input, output, session) {
  data <- eventReactive(input$go, {
    withProgress(message = "Computing random number", {
      for (i in seq_len(input$steps)) {
        Sys.sleep(0.5)
        incProgress(1 / input$steps)
      }
      runif(1)
    })
  })
  output$result <- renderText(round(data(), 2))
}
shinyApp(ui,server)


# Waiter #
ui <- fluidPage(
  waiter::use_waitress(),
  numericInput("steps", "How many steps?", 10),
  actionButton("go", "go"),
  textOutput("result")
)
# Create a new progress bar
waitress <- waiter::Waitress$new(max = input$steps)
# Automatically close it when done
on.exit(waitress$close())
for (i in seq_len(input$steps)) {
  Sys.sleep(0.5)
  # increment one step
  waitress$inc(1)
}
server <- function(input, output, session) {
  data <- eventReactive(input$go, {
    waitress <- waiter::Waitress$new(max = input$steps)
    on.exit(waitress$close())
    for (i in seq_len(input$steps)) {
      Sys.sleep(0.5)
      waitress$inc(1)
    }
    runif(1)
  })
  output$result <- renderText(round(data(), 2))
}
shinyApp(ui,server)


# Spinners #
ui <- fluidPage(
  waiter::use_waiter(),
  actionButton("go", "go"),
  textOutput("result")
)
server <- function(input, output, session) {
  data <- eventReactive(input$go, {
    waiter <- waiter::Waiter$new()
    waiter$show()
    on.exit(waiter$hide())
    Sys.sleep(sample(5, 1))
    runif(1)
  })
  output$result <- renderText(round(data(), 2))
}
shinyApp(ui,server)


# automatically remove the spinner when the output updates:
ui <- fluidPage(
  waiter::use_waiter(),
  actionButton("go", "go"),
  plotOutput("plot"),
)
server <- function(input, output, session) {
  data <- eventReactive(input$go, {
    waiter::Waiter$new(id = "plot")$show()
    Sys.sleep(3)
    data.frame(x = runif(50), y = runif(50))
  })
  output$plot <- renderPlot(plot(data()), res = 96)
}
shinyApp(ui,server)


# Using shinycssloaders package by Dean Attali
library(shinycssloaders)
ui <- fluidPage(
  actionButton("go", "go"),
  withSpinner(plotOutput("plot")),
)
server <- function(input, output, session) {
  data <- eventReactive(input$go, {
    Sys.sleep(3)
    data.frame(x = runif(50), y = runif(50))
  })
  output$plot <- renderPlot(plot(data()), res = 96)
}
shinyApp(ui,server)


# Conrming and Undoing: Explicit Conrmation #
modal_confirm <- modalDialog(
  "Are you sure you want to continue?",
  title = "Deleting files",
  footer = tagList(
    actionButton("cancel", "Cancel"),
    actionButton("ok", "Delete", class = "btn btn-danger")
  )
)
ui <- fluidPage(
  actionButton("delete", "Delete all files?")
)
server <- function(input, output, session) {
  observeEvent(input$delete, {
    showModal(modal_confirm)
  })
  observeEvent(input$ok, {
    showNotification("Files deleted")
    removeModal()
  })
  observeEvent(input$cancel, {
    removeModal()
  })
}
shinyApp(ui,server)


# Conrming and Undoing: Undoing an Action #
ui <- fluidPage(
  textAreaInput("message",
                label = NULL,
                placeholder = "What's happening?",
                rows = 3
  ),
  actionButton("tweet", "Tweet")
)
runLater <- function(action, seconds = 3) {
  observeEvent(
    invalidateLater(seconds * 1000), action,
    ignoreInit = TRUE,
    once = TRUE,
    ignoreNULL = FALSE,
    autoDestroy = FALSE
  )
}
server <- function(input, output, session) {
  waiting <- NULL
  last_message <- NULL
  observeEvent(input$tweet, {
    notification <- glue::glue("Tweeted '{input$message}'")
    last_message <<- input$message
    updateTextAreaInput(session, "message", value = "")
    showNotification(
      notification,
      action = actionButton("undo", "Undo?"),
      duration = NULL,
      closeButton = FALSE,
      id = "tweeted",
      type = "warning"
    )
    waiting <<- runLater({
      cat("Actually sending tweet...\n")
      removeNotification("tweeted")
    })
  })
  observeEvent(input$undo, {
    waiting$destroy()
    showNotification("Tweet retracted", id = "tweeted")
    updateTextAreaInput(session, "message", value = last_message)
  })
}
shinyApp(ui, server)
