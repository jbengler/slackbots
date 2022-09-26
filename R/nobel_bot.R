
library(tidyverse)
library(stringi)

Sys.time()

# nobel_winners <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-05-14/nobel_winners.csv")
# nobel_winner_all_pubs <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-05-14/nobel_winner_all_pubs.csv")

nobel_winners <- read_csv("nobel_winners.csv")

win <-
  nobel_winners %>%
  filter(category == "Medicine") %>%
  distinct(full_name, prize, motivation) %>%
  group_by(prize, motivation) %>%
  summarise(
    names = paste(full_name, collapse = "*, *"),
    prize = unique(prize),
    motivation = unique(motivation)
  ) %>%
  ungroup() %>%
  mutate(
    names = paste0("*",names,"*"),
    names = stri_replace_last_fixed(names, "*, *", "* and *")
  ) %>%
  slice_sample(n = 1)

message <- paste0(win$names,
" received _",win$prize,"_ ",str_replace_all(win$motivation, "\"", ""),".")
cmd <- paste0("curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"", message ,"\"}' ",
              Sys.getenv("INIMS_SLACK_HOOK_NOBEL_NOBEL"))
cmd
cmd %>% system
