library(shiny)
library(vroom)
library(tidyverse)

##Data frames em download

selected <- injuries %>% filter(prod_code == 649)
nrow(selected)

selected %>% count(location, wt = weight, sort = TRUE)

selected %>% count(body_part, wt = weight, sort = TRUE)

selected %>% count(diag, wt = weight, sort = TRUE)

## injuries involving toilets most often occur at home. The most
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

