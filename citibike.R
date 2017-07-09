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

# load all csv files
paths <- dir(pattern = "\\.csv$")
file_all = data.frame()
for (i in basename(paths)){
    temp = read.csv(i, stringsAsFactors = F, header = T)
    temp$FileDate = substr(i,4,9)
    file_all = rbind(file_all, temp)
}
write.csv(file_all, '../citibike_all.csv')

file_all = read.csv('../citibike_all.csv', row.names = NULL)
file_all = file_all[, -1]
file_all$FileDate = as.factor(file_all$FileDate)
file_all$Bike.ID = as.character(file_all$Bike.ID)
file_all$Start.Station.ID = as.character(file_all$Start.Station.ID)
file_all$End.Station.ID = as.character(file_all$End.Station.ID)
file_all$Gender = as.factor(file_all$Gender)
tail(file_all)
str(file_all)


# Trip duration
g1 = file_all %>% select(Trip.Duration, FileDate) %>% 
    filter(Trip.Duration < 3600) %>% 
    mutate(Trip.Min = Trip.Duration / 60) %>%
    ggplot(aes(x=Trip.Min)) 
g1 + geom_histogram(binwidth = 1, color='white') 


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

g3 + geom_histogram(binwidth=2, color='white') +
    facet_grid(Gender ~ .)

# How many trip per Bike ID 
g4 =file_all %>% 
    group_by(Bike.ID) %>%
    dplyr::summarise(trip_p_bike = n()) %>% 
    filter(trip_p_bike >=80)

ggplot(data=g4, aes(x=trip_p_bike)) +
    geom_histogram(binwidth = 50, color = 'white')

# bikeID vs stationID
g5 = file_all %>% select(contains('ID')) 
ggplot(data=g5, aes(x=Start.Station.ID, y = End.Station.ID)) +
    geom_point()
