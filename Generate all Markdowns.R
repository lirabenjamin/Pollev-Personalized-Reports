#Generate scripts ####

#Packages
library(rmarkdown)
library(tidyverse)

#Read all data
fulldata <- readRDS("~/Documents/GitHub/Pollev-Personalized-Reports/pollev_wide.rds")

i = 1
#Loop through people
for (j in 1:nrow(fulldata)){
  data = slice(fulldata,j)
  write_rds(data,file = "~/Documents/GitHub/Pollev-Personalized-Reports/pollev_wide_i.rds")
  path = paste0("Moodmeter/",j,".pdf")
  rmarkdown::render('UntitledPres.Rmd',output_file = paste0("Markdowns/",j,". Grit Lab Report ",data$firstname))
}


