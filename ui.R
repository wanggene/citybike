# shiny app for citibike
library(shiny)
library(ggplot2)
library(dplyr)

fluidPage(
    titlePanel(h2("NYC CitiBike 2015-2017")),
    sidebarLayout(
        sidebarPanel(h4("Choose Bins"),
            #1 Input Trip Duration Distribution Slide Bar
            sliderInput(inputId = "bins",
                        label = "Number of bins in histogram",
                        min = 10, max = 100, value = 30)
        ),
        
        mainPanel(
            plotOutput("TripDuration"),
            plotOutput("TripBike"),
            plotOutput("Age")
            
            #fluidRow(
            #    column(6, plotOutput("TripDuration")),  # outputID = count
            #    column(6, plotOutput("TripBike"))  # outputID = 
            #)
        )
    )
)