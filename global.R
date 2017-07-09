#global.R
library(data.table)
setwd("~/GitHub/citybike")
citibike = fread(file = "../Data/citibike_all.csv")
file_all = citibike %>% 
    filter(Gender %in% c(1, 2)) %>%
    mutate(Age=2017-Birth.Year) 
