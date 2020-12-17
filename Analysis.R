#Libraries
library(readr)
library(tidyverse)
library(lubridate)
devtools::install_github("lirabenjamin/Ben")
library(Ben)

#Data Load
pewide <- readRDS("~/Documents/GitHub/Pollev-Personalized-Reports/Pollev-Personalized-Reports/pollev_wide.rds")
pe <- read.csv("Grit Lab PollEv Report.csv")

#Inspect

pe = pe %>% select(
  
  date = `Received.at..CST.`,
  firstname = First.name,
  lastname = Last.name,
  email = Email,
  Custom.report.ID,
  response = Response,
  Activity.title,
  Activity.type,
  Group.survey.name,
  act_name
) %>% 
  mutate(timestamp = mdy_hm(date),
         date = date(timestamp))

pe = pe %>% 
  group_by(firstname,lastname,email,Activity.title,Activity.type,Group.survey.name,act_name) %>% 
  filter(timestamp == max(timestamp)) %>% 
  ungroup() %>% #n = 3790, drops,125 people who repeated themselves, 3 on different days
  filter(firstname != "") %>%  # n = 3624 Drops 166 empty named people
  group_by(firstname,lastname,email,Activity.title,Activity.type,Group.survey.name,act_name) %>% 
  filter(row_number()==n()) %>% # n = 3572, drops 52 people who replied more than once.
  ungroup
  
pewide = pe %>% 
  pivot_wider(.,
                                      id_cols = c("firstname", "lastname"),
                                      names_from = "act_name",
                                      values_from = "response")
pewide %>% write_rds("pollev_wide.rds")
