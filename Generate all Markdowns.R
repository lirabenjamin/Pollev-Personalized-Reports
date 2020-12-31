#Generate scripts ####

#Packages
library(rmarkdown)
library(tidyverse)

#Read all data
fulldata <- readRDS("~/Documents/GitHub/Pollev-Personalized-Reports/pollev_wide.rds")
fulldata = read_csv("Data with Moodmeter.csv")
fulldata = fulldata %>% mutate(png = paste0(No,".png"))
i = 1
j=2
#Loop through people
for (j in 1:nrow(fulldata)){
  data = slice(fulldata,j)
  write_rds(data,file = "~/Documents/GitHub/Pollev-Personalized-Reports/pollev_wide_i.rds")
  path = paste0("Moodmeter/",data$png[1])
  rmarkdown::render('Presentation.Rmd',
                    output_file = paste0("docs/",j,". Grit Lab Report ",data$firstname))
}

