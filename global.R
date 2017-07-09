#global.R
library(data.table)
setwd("~/GitHub/citybike")
citibike = fread(file = "../Data/citibike_all.csv")
file_all = citibike