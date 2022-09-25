
# this is needed to allow special characters in names in Rscript execution
# Sys.setlocale(category = "LC_CTYPE", locale = "de_DE.UTF-8")

library(tidyverse)
library(googlesheets4)

googlesheets4::gs4_auth(email = Sys.getenv("INIMS_SHEETS_GOOGLE_MAIL"), path = "inims_sheets.json")

df <- read_sheet(Sys.getenv("INIMS_SHEETS_BIRTHDAYS"))

today <- paste0(as.numeric(format(Sys.Date(), "%m")),"_",as.numeric(format(Sys.Date(), "%d")))

name <-
  df %>%
  filter(Date == today) %>%
  pull(Name)

for (i in name) {
  message <- paste0("Today is the birthday of *",i,"* :tada:")
  cmd <- paste0("curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"", message ,"\"}' ",
                Sys.getenv("INIMS_SLACK_TEST_HOOK_BIRTHDAY"))
  cmd %>% system
}
