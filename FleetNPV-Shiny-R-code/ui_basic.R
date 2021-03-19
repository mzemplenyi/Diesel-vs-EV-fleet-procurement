#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Fleet Procurement Simulation Tool"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            #sliderInput("bins", "Number of bins:", min = 1, max = 50, value = 30),
            numericInput(inputId = "d.bus",
                         label = "Initial cost of diesel bus",
                         value = 400000,
                         min = 1,
                         max = 800000,
                         step = 50000),
            numericInput(inputId = "rate",
                         label = "Discount rate (%)",
                         value = 8,
                         min = 1,
                         max = 15,
                         step = 0.5),
            numericInput(inputId = "meanDieselPrice",
                         label = "Mean of diesel price distribution",
                         value = 3,
                         min = 0,
                         max = 10,
                         step = 0.01),
            numericInput(inputId = "sdDieselPrice",
                         label = "Standard deviation of diesel price distribution",
                         value = 0.20,
                         min = 0,
                         max = 10,
                         step = 0.01),
            numericInput(inputId = "miles",
                         label = "Annual vehicle miles traveled",
                         value = 45000,
                         min = 1,
                         max = 200000,
                         step = 1000),
            numericInput(inputId = "mpg",
                         label = "Miles / gallon of diesel",
                         value = 3,
                         min = 1,
                         max = 20,
                         step = 0.5),
            numericInput(inputId = "d.lifetime",
                         label = "Lifetime of diesel vehicle",
                         value = 12,
                         min = 1,
                         max = 20,
                         step = 1),
            numericInput(inputId = "nSims",
                         label = "No. of simulations",
                         value = 100,
                         min = 1,
                         max = 10000,
                         step = 100),
            actionButton("runsim", label = "Run simulation")
        ),


        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("densityPlot"),
            plotOutput("npvPlot")
        )
    )
))
