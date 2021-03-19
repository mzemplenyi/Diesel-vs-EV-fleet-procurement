######################################################################
# This is the server logic of a Shiny web application. 
### ACCESS APP HERE https://michele-zemplenyi.shinyapps.io/fleetnpv_shiny/

library(shiny)
library(shinydashboard)
source("npv.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$densityPlot <- renderPlot({
        if(input$tabset1 == "Diesel"){
            plot(function(x) dnorm(x, mean = input$meanDieselPrice, sd = input$sdDieselPrice), 
                 0, 5,
                 #input$meanDieselPrice-4*input$sdDieselPrice, 
                 #input$meanDieselPrice+4*input$sdDieselPrice,
                 type = "l", main = "Diesel price distribution", 
                 xlab = "Diesel price ($US)", ylab = "Density", col = "orange", lwd = 2)
            
        }else{
            plot(function(x) dnorm(x, mean = input$meanElecRate, sd = input$sdElecRate), 
                 0, 0.25,
                 #input$meanDieselPrice-4*input$sdDieselPrice, 
                 #input$meanDieselPrice+4*input$sdDieselPrice,
                 type = "l", main = "Electricity rate distribution", 
                 xlab = "Electricity rate ($ / kWh)", ylab = "Density", col = "blue", lwd = 2)
        }
        

    })
    
    observeEvent(input$runsim, {
        print("Starting simulation.")
        d.npv <- vector(mode = "numeric", length = input$nSims)
        e.npv <- vector(mode = "numeric", length = input$nSims)
        diff.npv <- vector(mode = "numeric", length = input$nSims)
        
        sim.fuelprices <- vector(mode = "numeric", length = input$nSims)
        sim.elecrates <- vector(mode = "numeric", length = input$nSims)
        ## BEGIN SIMULATION
        for(i in 1:input$nSims){
            ## diesel bus generate fuel cost
            d.fuelprice <- rnorm(1, mean = input$meanDieselPrice, sd = input$sdDieselPrice)
            sim.fuelprices[i] <- d.fuelprice
            d.annualfuel <- d.fuelprice * input$miles / input$mpg
            
            d.inflows <- rep(0, times = input$d.lifetime)
            d.outflows <- rep(d.annualfuel, times = input$d.lifetime)
            
            # note that input$d.bus needs to be negated 
            d.npv[i] <- npv(input$rate, -input$d.bus, d.inflows, d.outflows)
            
            
            ## electric bus generate electricity rate
            e.elecrate <- rnorm(1, mean = input$meanElecRate, sd = input$sdElecRate)
            sim.elecrates[i] <- e.elecrate
            # annual cost of charging [annual miles traveled] * [kWh / mile] * [elec rate in $ per kWh]
            e.annualfuel <-  input$miles * input$kwhpermile * e.elecrate
            
            e.inflows <- rep(0, times = input$e.lifetime)
            e.outflows <- rep(e.annualfuel, times = input$e.lifetime)
            
            # note that input$d.bus needs to be negated 
            e.npv[i] <- npv(input$rate, -input$e.bus, e.inflows, e.outflows)
            
            # store difference in npv between diesel - electric
            diff.npv[i] <- abs(d.npv[i]) - abs(e.npv[i])
            
            
        }
        print("Finished simulation.")
        
        
        print(head(d.npv))
        print(head(e.npv))
        print(head(diff.npv))
        
        
        output$npvPlot <- renderPlot({
            
            # # generate bins based on input$bins from ui.R
            # x    <- faithful[, 2]
            # bins <- seq(min(x), max(x), length.out = input$bins + 1)
            
            # # draw the histogram with the specified number of bins
            # hist(d.npv, main = "Net Present Value Distribution", 
            #      xlab = "Net Present Value ($US)", col = "purple", border = "white")
            
            # draw the histogram with the specified number of bins
            hist(diff.npv, main = "Distribution of Difference in NPV Cost (Diesel - Electric)", 
                 xlab = "Net Present Value ($US)", col = "purple", border = "white")
            
        })
        output$procurementComparison <- renderText({
            dieselHigherCost <- 100* sum(diff.npv >= 0) / input$nSims
            paste("The diesel procurement had the higher cost in ", dieselHigherCost, "% of simulations. Negative values indicate higher costs for the electric bus procurement.")
        })
        
    })
    

    

})
