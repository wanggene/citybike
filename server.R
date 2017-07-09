#server.R
library(shiny)
library(ggplot2)
library(dplyr)

function(input, output) {
    g1 = reactive({
        AgeMin = input$Age[1]
        AgeMax = input$Age[2]
        file_all %>% select(Trip.Duration, Age, FileDate) %>% 
            filter(Trip.Duration < 3600) %>% 
            filter(Age >= AgeMin & Age <= AgeMax) %>%
            mutate(Trip.Min = Trip.Duration / 60) %>%
            ggplot(aes(x=Trip.Min)) 
    })
    
    g2 = reactive({
        AgeMin = input$Age[1]
        AgeMax = input$Age[2]
        file_all %>% select(User.Type, Age, Gender) %>%
        filter(User.Type == "Subscriber") %>% 
            filter(Age >= AgeMin & Age <= AgeMax) %>%
            ggplot(aes(x=Age))
    })
    
    g3 = reactive({
        file_all %>% select(Bike.ID) %>%
            group_by(Bike.ID) %>%
            dplyr::summarise(trip_p_bike = n()) %>% 
            filter(trip_p_bike >= 5) %>%
            ggplot(aes(x=trip_p_bike)) 
    })
    
    # attach output object (id is TripDuration) to output
    output$TripDuration = renderPlot({
        bins = input$bins     # bins is the input object
        g1() + geom_histogram(bins = bins, color='white') 
    })
    
    # attach out object (id is Age) to output
    output$Age = renderPlot({
        bins = input$bins     # bins is the input object
        g2() + geom_histogram(bins = bins, color='white') +
        facet_grid(. ~ Gender)
    }) 
    
    # attach output object (id is TripBike) to output
    output$TripBike = renderPlot({ 
        bins = input$bins     # bins is the input object
        g3() +geom_histogram(bins = bins, color = 'white')
    }) 
    
    output$TakeTrip = renderPlot({ })
    
} 