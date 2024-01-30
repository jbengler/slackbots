
library(tidyverse)
library(googlesheets4)

Sys.time()

googlesheets4::gs4_auth(email = Sys.getenv("INIMS_SHEETS_GOOGLE_MAIL"), path = "inims_sheets.json")
df <- read_sheet(Sys.getenv("INIMS_SHEETS_DUTIES"))

this_week <- lubridate::isoweek(Sys.Date())
this_year <- lubridate::year(Sys.Date())

message <-
  df %>%
  filter(week == this_week, year == this_year) %>%
  slice_head(n = 1) %>%
  mutate(message = glue::glue("This week the following people are on duty

:mouse: mouse room: *{mouse_room}*
:petri_dish: mouse cell culture: *{mouse_cell_culture}*
:coffee: coffee machine: *{coffee}*")) %>%
  pull(message)

cmd <- paste0("curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"", message ,"\"}' ",
                Sys.getenv("INIMS_SLACK_HOOK_DUTIES_TEST"))
cmd %>% system
