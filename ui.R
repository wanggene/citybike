# shiny app for citibike
library(shiny)
library(ggplot2)
library(dplyr)

fluidPage(
    titlePanel(h2("NYC CitiBike 2015-2017")),
    sidebarLayout(
        sidebarPanel(h4("Choose Bins"),
            
            sliderInput(inputId = "bins",
                label = "Number of bins in histogram",
                min=20, max=100, step=20, value=40),
            
            tags$hr(),
            sliderInput(inputId = "Age", 
                label = "Age Range:",
                min = 13, max = 99, value = c(21,69)),
            
            tags$hr(),
            selectInput(inputId = "Sex", "Chosse Gender :", 
                choices = c(1, 2)),
            
            tags$hr(),
            selectizeInput(inputId = "BikeStation",
                           label = "Citi Bike Station",
                           choices = unique(file_all$Start.Station.Name))
        ),
        mainPanel(
            #plotOutput("TripDuration"),
            #plotOutput("TripBike"),
            #plotOutput("Age")
            
            #fluidRow(
            #    column(6, plotOutput("TripDuration")),  # outputID = count
            #    column(6, plotOutput("TripBike"))  # outputID = 
            #)
            tabsetPanel(type = "tabs", 
                tabPanel(h4("Trip Duration"), plotOutput("TripDuration")), 
                tabPanel(h4("User Age"), plotOutput("Age")),
                tabPanel(h4("Trips per Bike"),plotOutput("TripBike")),
                tabPanel(h4("Take a Trip"), 
                    selectizeInput(inputId = "BikeStation",
                    label = "Citi Bike Station",
                    choices = unique(file_all$Start.Station.Name)),
                    plotOutput("TakeTrip"))
                )
        )
    )
)