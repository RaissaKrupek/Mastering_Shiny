################### Exploration ####################
library(shiny)
library(vroom)
library(tidyverse)

##Data frames em download
# download("injuries.tsv.gz")
# download("population.tsv")
# download("products.tsv")

selected <- injuries %>% filter(prod_code == 649)
nrow(selected)
## Interpretacao: filtra as linhas do data frame injuries onde a coluna prod_code é igual 
##a 649. O resultado é atribuído a um novo data frame chamado selected.
##A segunda linha calcula o número de linhas no data frame selected usando a função nrow().

selected %>% count(location, wt = weight, sort = TRUE)

selected %>% count(body_part, wt = weight, sort = TRUE)

selected %>% count(diag, wt = weight, sort = TRUE)

## results: injuries involving toilets most often occur at home. The most
##common body parts involved possibly suggest that these are falls (since the
##head and face are not usually involved in routine toilet usage), and the 
##diagnoses seem rather varied.

summary %>% 
  ggplot(aes(age, n, colour = sex)) +
  geom_line() +
  labs(y = "Estimated number of injuries")

## One problem with interpreting this pattern is that we know that there are fewer older
##people than younger people, so the population available to be injured is smaller. We
##can control for this by comparing the number of people injured with the total popula‐
##tion and calculating an injury rate. Here I use a rate per 10,000:

summary <- selected %>%
  count(age, sex, wt = weight) %>%
  left_join(population, by = c("age", "sex")) %>%
  mutate(rate = n / population * 1e4)
summary


summary %>%
  ggplot(aes(age, rate, colour = sex)) +
  geom_line(na.rm = TRUE) +
  labs(y = "Injuries per 10,000 people")


selected %>%
  sample_n(10) %>%
  pull(narrative)

#######################Prototype######################

prod_codes <- setNames(products$prod_code, products$title)
library(shiny)
ui <- fluidPage(
  fluidRow(
    column(6,
           selectInput("code", "Product", choices = prod_codes)
    )
  ),
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  fluidRow(
    column(12, plotOutput("age_sex"))
  )
)
##No codigo anterior foi reservada uma linha para os inputs, uma linha para retornar
##3 tabelas, dado que cada tabela tem 4 colunas,e uma linha para o plot

server <- function(input, output, session) {
  selected <- reactive(injuries %>% filter(prod_code == input$code))
  output$diag <- renderTable(
    selected() %>% count(diag, wt = weight, sort = TRUE)
  )
  output$body_part <- renderTable(
    selected() %>% count(body_part, wt = weight, sort = TRUE)
  )
  output$location <- renderTable(
    selected() %>% count(location, wt = weight, sort = TRUE)
  )
  summary <- reactive({
    selected() %>%
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 1e4)
  })
  output$age_sex <- renderPlot({
    summary() %>%
      ggplot(aes(age, n, colour = sex)) +
      geom_line() +
      labs(y = "Estimated number of injuries")
  }, res = 96)
}
shinyApp(ui, server)


#####################Polish Tables#####################

injuries %>%
  mutate(diag = fct_lump(fct_infreq(diag), n = 5)) %>%
  group_by(diag) %>%
  summarise(n = as.integer(sum(weight)))
## Conversao da variavel para um fator, ordenado pela frequencia de niveis, e 
##juncao de todos os niveis a partr dos top 5

##################Rate Versus Count###################

prod_codes <- setNames(products$prod_code, products$title)
library(shiny)
ui <- fluidPage(
  fluidRow(
    column(8,
           selectInput("code", "Product",
                       choices = setNames(products$prod_code, products$title),
                       width = "100%"
           )
    ),
    column(2, selectInput("y", "Y axis", c("rate", "count")))
  ),
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  fluidRow(
    column(12, plotOutput("age_sex"))
  )
)

server <- function(input, output, session) {
  selected <- reactive(injuries %>% filter(prod_code == input$code))
  output$diag <- renderTable(
    selected() %>% count(diag, wt = weight, sort = TRUE)
  )
  output$body_part <- renderTable(
    selected() %>% count(body_part, wt = weight, sort = TRUE)
  )
  output$location <- renderTable(
    selected() %>% count(location, wt = weight, sort = TRUE)
  )
  summary <- reactive({
    selected() %>%
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 1e4)
  })
  output$age_sex <- renderPlot({
    if (input$y == "count") {
      summary() %>%
        ggplot(aes(age, n, colour = sex)) +
        geom_line() +
        labs(y = "Estimated number of injuries")
    } else {
      summary() %>%
        ggplot(aes(age, rate, colour = sex)) +
        geom_line(na.rm = TRUE) +
        labs(y = "Injuries per 10,000 people")
    }
  }, res = 96)
}
shinyApp(ui, server)
