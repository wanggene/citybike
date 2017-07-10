# Citibike
library(plyr)
library(ggplot2)
library(dplyr)
setwd("~/Downloads/citibike")
JC1510 = read.csv("JC-201510-citibike-tripdata.csv",
      stringsAsFactors = F)

JC1703 = read.csv("JC-201703-citibike-tripdata.csv",
                 stringsAsFactors = F)

# X <- read.csv("201509-citibike-tripdata.csv", stringsAsFactors = F)

# combine all csv files
paths <- dir(pattern = "\\.csv$")
file_all = data.frame()
for (i in basename(paths)){
    temp = read.csv(i, stringsAsFactors = F, header = T)
    temp$File.Year = substr(i,4,7)
    temp$File.Month = substr(i,8,9)
    file_all = rbind(file_all, temp)}

write.csv(file_all, '../citibike_all.csv')

# read file
setwd("~/GitHub/citybike")
file_all = read.csv('../Data/citibike_all.csv', stringsAsFactors = F)
file_all = file_all[, -1]

file_all$Bike.ID = as.character(file_all$Bike.ID)
file_all$Start.Station.ID = as.character(file_all$Start.Station.ID)
file_all$End.Station.ID = as.character(file_all$End.Station.ID)
file_all$Gender = as.factor(file_all$Gender)
file_all$User.Type = as.factor(file_all$User.Type)
file_all$FileDate = as.factor(file_all$FileDate)
tail(file_all)
glimpse(file_all)

#write.csv(file_all, '../Data/citibike_all.csv')
save(file_all, file= '../Data/citibike_all.Rda')

load('citibike_all.Rda')
glimpse(file_all)


load file
library(data.table)
setwd("~/GitHub/citybike")
citibike <- fread(file = "../Data/citibike_all.csv", header = T)
file_all = citibike

# Trip duration
g1 = file_all %>% select(Trip.Duration, FileDate) %>% 
    filter(Trip.Duration < 3600) %>% 
    mutate(Trip.Min = Trip.Duration / 60) %>%
    ggplot(aes(x=Trip.Min)) 
g1 + geom_histogram(bins = 50, color='white') 


# User rent type (24Hr/3Day Custormer vs. Annual Subscriber)
g2 = file_all %>% 
    filter(User.Type %in% c("Customer", "Subscriber")) %>% 
    select(User.Type, FileDate) %>% 
    ggplot(aes(x=FileDate))

g2 + geom_bar( aes(fill = User.Type), position = 'dodge')

# Subscriber age distributioin (1=male, 2=female)
g3 = file_all %>% 
    filter(User.Type == "Subscriber") %>% 
    mutate(Age=2017-Birth.Year) %>% 
    filter(Age >= 13 & Age <= 69) %>% 
    filter(Gender %in% c(1,2)) %>%
    ggplot(aes(x=Age)) 

g3 + geom_histogram(bins=50, color='white') +
    facet_grid(Gender ~ .)

# How many trip per Bike ID 
g4 =file_all %>% 
    group_by(Bike.ID) %>%
    dplyr::summarise(trip_p_bike = n()) %>% 
    filter(trip_p_bike >=80)

ggplot(data=g4, aes(x=trip_p_bike)) +
    geom_histogram(bins = 50, color = 'white')

# bikeID vs stationID ???
g5 = file_all %>% select(contains('ID')) 
ggplot(data=g5, aes(x=Start.Station.ID, y = End.Station.ID)) +
    geom_point()
