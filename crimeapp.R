library(tidyverse)
library(DBI)
library(dbplyr)
library(dplyr)
library(bigrquery)
library(tidyverse)
library(plotly)
library(DT)
library(ggvis)
library(shiny)
library(gapminder)
library(RSocrata)
library(lubridate)


#reading data from github
crime <- read_csv("https://raw.githubusercontent.com/daraeoh/Chicago-Crime-App/master/crime.csv")


#Data Cleaning

crime$district[crime$district == "1"] <- "1 - Central"
crime$district[crime$district == "2"] <- "2 - Wentworth"
crime$district[crime$district == "3"] <- "3 Grand Crossing"
crime$district[crime$district == "4"] <- "4 - South Chicago"
crime$district[crime$district == "5"] <- "5 - Calumet"
crime$district[crime$district == "6"] <- "6 - Gresham"
crime$district[crime$district == "7"] <- "7 - Englewood"
crime$district[crime$district == "8"] <- "8 - Chicago Lawn"
crime$district[crime$district == "9"] <- "9 - Deering"
crime$district[crime$district == "10"] <- "10 - Ogden"
crime$district[crime$district == "11"] <- "11 - Harrison"
crime$district[crime$district == "12"] <- "12 - Near West"
crime$district[crime$district == "14"] <- "14 - Shakespeare"
crime$district[crime$district == "15"] <- "15 - Austin"
crime$district[crime$district == "16"] <- "16 - Jefferson Park"
crime$district[crime$district == "17"] <- "17 - Albany Park"
crime$district[crime$district == "18"] <- "18 - Near North"
crime$district[crime$district == "19"] <- "19 - Town Hall"
crime$district[crime$district == "20"] <- "20 - Lincoln"
crime$district[crime$district == "22"] <- "22 - Morgan Park"
crime$district[crime$district == "24"] <- "24 - Rogers Park"
crime$district[crime$district == "25"] <- "25 - Grand Central"


# Define UI

ui <- fluidPage(
    
    # App title
    titlePanel("Chicago Crime Visualization"),
    
    br(),
    
    h5("Author: Rebecca Oh"),
    
    br(),
    
    # Sidebar layout with input and output definitions
    ui <- fluidPage(
        
        sidebarLayout(
            
            # Inputs
            sidebarPanel(
                
                # Select district number
                selectInput(inputId = "district",
                            label = "District",
                            choices = c("1 - Central", "2 - Wentworth", "3 - Grand Crossing", "4 - South Chicago", "5 - Calumet",
                                        "6 - Gresham", "7 - Englewood", "8 - Chicago Lawn", "9 - Deering", "10 - Ogden", 
                                        "11 - Harrison", "12 - Near West", "14 - Shakespeare", "15 - Austin", 
                                        "16 - Jefferson Park", "17 - Albany Park", "18 - Near North", "19 - Town Hall", 
                                        "20 - Lincoln", "21", "22 - Morgan Park", "24 - Rogers Park", 
                                        "25 - Grand Central", "31") %>% unique(),
                            selected = "1 - Central"),
                
                # Slide year range
                sliderInput(inputId = "year",
                            label = "Range of years",
                            min = 2001,
                            max = 2019,
                            value = c(2001, 2019), 
                            sep = ""),
                
                # Select crime type
                checkboxGroupInput(inputId = "primary_type",
                                   label = "Choose a primary type of crime",
                                   choices = c("ARSON", "ASSAULT", "BATTERY", "BURGLARY", "CONCEALED CARRY LICENSE VIOLATION", 
                                               "CRIMINAL DAMAGE", "CRIMINAL TRESPASS", "CRIM SEXUAL ASSAULT", "DECEPTIVE PRACTICE", 
                                               "GAMBLING", "HOMICIDE", "INTERFERENCE WITH PUBLIC OFFICER", "INTIMIDATION", 
                                               "KIDNAPPING", "LIQUOR LAW VIOLATION", "MOTOR VEHICLE THEFT", "NARCOTICS", 
                                               "NON-CRIMINAL (SUBJECT SPECIFIED)", "OBSCENITY", "OTHER NARCOTIC VIOLATION", 
                                               "OTHER OFFENSE", "OFFENSE INVOLVING CHILDREN", "PROSTITUTION", "PUBLIC INDECENCY", 
                                               "PUBLIC PEACE VIOLATION", "ROBBERY", "SEX OFFENSE", "STALKING", "THEFT", "WEAPONS VIOLATION"),
                                   selected = "ARSON")
            ),
            
            # Outputs
            mainPanel(
                position = "left",
                plotlyOutput(outputId = "scatterplot")
            )
        )
    )
)


# Server

# Define server function
server <- function(input, output) {
    
    # Create data
    crime2 <- reactive({
        crime %>%
            filter(district == as.vector(input$district)) %>%
            filter(year >= as.integer(input$year[1]) & year <= as.integer(input$year[2])) %>%
            filter(primary_type == input$primary_type)
    })
    
    # Create scatterplot object
    output$scatterplot <- renderPlotly({
        p <- ggplot(data = crime2(), aes(x = year, y = arrests)) +
            geom_point(aes(color = primary_type)) +
            geom_smooth(method = 'loess') +
            theme_light() +
            labs(title = paste0("Chicago Crimes in District ", input$district),
                 x = "Year",
                 y = "Number of Arrests",
                 color = "Primary Type of Crime")
        ggplotly(p)
    })
}

# Run the Shiny application
shinyApp(ui = ui, server = server)