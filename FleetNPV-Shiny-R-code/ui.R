########################################################################
# This is the user-interface definition of a Shiny web application. 
### ACCESS APP HERE https://michele-zemplenyi.shinyapps.io/fleetnpv_shiny/

library(shiny)
library(shinydashboard)
#library(htmlwidgets)

body <- dashboardBody(
    fluidRow(
        column(width = 4,
               box(
                   title = "Global inputs", height = "455px", width = NULL, solidHeader = TRUE, status = "primary",
                   numericInput(inputId = "rate",
                                label = "Discount rate (%)",
                                value = 8,
                                min = 1,
                                max = 15,
                                step = 0.5),
                   numericInput(inputId = "miles",
                                label = "Annual vehicle miles traveled",
                                value = 70000,
                                min = 1,
                                max = 200000,
                                step = 1000),
                    numericInput(inputId = "nSims",
                                label = "No. of simulations",
                                value = 1000,
                                            min = 1,
                                            max = 10000,
                                            step = 100),
                   actionButton("runsim", label = "Run simulation")
               )
               
        ),
        column(width = 8,
               tabBox(
                   title = "Procurement Inputs",
                   # The id lets us use input$tabset1 on the server to find the current tab
                   id = "tabset1", width = "80px",
                   tabPanel("Description", 
                   
                   HTML(paste("This is a working-version of a tool that can be used to compare the net 
                   present value (NPV) cost of bus procurement options (e.g. diesel bus vs. electric bus). The tool 
                   uses a simulation approach to perform sensitivity analyses for the diesel price ($/gallon) and the 
                   electricity rate ($/kWh); for each simulation, unique values are generated from normal distributions
                   with mean and standard deviation specified by the user on the 'Diesel' and 'Electric' tabs. <br/>
                   <br/>
                   To use this tool, enter global inputs 
                   and procurement inputs in the tabs above. After clicking 'Run simulation,' a histogram displaying
                   the difference in NPV costs across all simulations will appear below. <br/> <br/>
                   
                   Note that the current version of this tool only accounts for a small subset of the costs of purchasing 
                   and operating a bus; future updates will include additional cost inputs (e.g. maintenance, financing) and 
                   the ability to specify other distributions for the diesel and electricity prices. 
                   <br/> <br/>
                   
                   The source code for this project was written in R. For additional information, contact Michele 
                            Zemplenyi at mzemplenyi@gmail.com. " ))
                                    ),
                   tabPanel("Diesel",
                                                   #sliderInput("bins", "Number of bins:", min = 1, max = 50, value = 30),
                                                    numericInput(inputId = "d.lifetime",
                                                            label = "Lifetime of diesel bus",
                                                            value = 12,
                                                            min = 1,
                                                            max = 20,
                                                            step = 1),
                                                    numericInput(inputId = "d.bus",
                                                                label = "Initial cost of diesel bus ($)",
                                                                value = 400000,
                                                                min = 1,
                                                                max = 900000,
                                                                                    step = 50000),
                                                numericInput(inputId = "mpg",
                                                             label = "Miles / gallon of diesel",
                                                             value = 3,
                                                             min = 1,
                                                             max = 20,
                                                             step = 0.5),
                                                   numericInput(inputId = "meanDieselPrice",
                                                                label = "Mean of diesel price distribution ($)",
                                                                value = 3,
                                                                min = 0,
                                                                max = 10,
                                                                step = 0.01),
                                                   numericInput(inputId = "sdDieselPrice",
                                                                label = "Standard deviation of diesel price distribution ($)",
                                                                value = 0.20,
                                                                min = 0,
                                                                max = 10,
                                                                step = 0.01),
                            
    
                            
                            
                            ), # end Diesel tabPanel content
                   tabPanel("Electric", 
                            #sliderInput("bins", "Number of bins:", min = 1, max = 50, value = 30),
                            numericInput(inputId = "e.lifetime",
                                         label = "Lifetime of electric bus",
                                         value = 12,
                                         min = 1,
                                         max = 20,
                                         step = 1),
                            numericInput(inputId = "e.bus",
                                         label = "Initial costs of electric bus (bus, batteries, infrastructure) ($)",
                                         value = 700000,
                                         min = 1,
                                         max = 800000,
                                         step = 50000),
                            # numericInput(inputId = "e.battery",
                            #              label = "Battery capacity (kWh)",
                            #              value = 240,
                            #              min = 50,
                            #              max = 400,
                            #              step = 10),
                            numericInput(inputId = "kwhpermile",
                                         label = "kWh / mile",
                                         value = 2,
                                         min = 1,
                                         max = 10,
                                         step = 0.5),
                            numericInput(inputId = "meanElecRate",
                                         label = "Mean of electricity rate dist. ($/kWh)",
                                         value = 0.08,
                                         min = 0,
                                         max = 2,
                                         step = 0.01),
                            numericInput(inputId = "sdElecRate",
                                         label = "Standard deviation of electricity rate dist. ($/kWh)",
                                         value = 0.02,
                                         min = 0,
                                         max = 2,
                                         step = 0.01),

                            ) # end Electric tabPanel content

               )# end tabBox
          ) # end column (width 8)


    ),
    fluidRow(
        column(width = 6,
               box(width = "50px",
                  plotOutput("densityPlot") 
               )),
        column(width = 6,
               box(width = "50px",
                   plotOutput("npvPlot"),
                   textOutput("procurementComparison")
               ))
    
) # end fluidRow
) # end body

ui <- dashboardPage(
    dashboardHeader(title = "Fleet Procurement Simulation Tool",
                    titleWidth = 425),
    # if you want to remove the toggle sidebar icon from the header see 
    # https://stackoverflow.com/questions/41939346/hide-main-header-toggle-in-r-shiny-app
    # dashboardSidebar(
    #     # Remove the sidebar toggle element
    #     tags$script(JS("document.getElementsByClassName('sidebar-toggle')[0].style.visibility = 'hidden';"))
    # ),
    dashboardSidebar(width = 0),
    body
)

