#server.R
library(shiny)
library(ggplot2)
library(dplyr)

function(input, output) {
    # attach output object (id is TripDuration) to output
    output$TripDuration = renderPlot({
        bins = input$bins     # bins is the input object
        g1 = file_all %>% select(Trip.Duration, FileDate) %>% 
            filter(Trip.Duration < 3600) %>% 
            mutate(Trip.Min = Trip.Duration / 60) %>%
            ggplot(aes(x=Trip.Min)) 
        g1 + geom_histogram(bins = bins, color='white') 
    })
    
    # attach output object (id is TripBike) to output
    output$TripBike = renderPlot({ 
        bins = input$bins     # bins is the input object
        g4 = file_all %>% 
            group_by(Bike.ID) %>%
            dplyr::summarise(trip_p_bike = n()) %>% 
            filter(trip_p_bike >= 5) %>%
            ggplot(aes(x=trip_p_bike)) 
        g4 +geom_histogram(bins = bins, color = 'white')   
    })   
    
    # attach out object (id is Age) to output
    output$Age = renderPlot({
        bins = input$bins     # bins is the input object
        g3 = file_all %>% 
            filter(User.Type == "Subscriber") %>% 
            mutate(Age=2017-Birth.Year) %>% 
            filter(Age >= 13 & Age <= 69) %>% 
            filter(Gender %in% c(1,2)) %>%
            ggplot(aes(x=Age))
        g3 + geom_histogram(bins = bins, color='white') +
            facet_grid(Gender ~ .)
    })

} 