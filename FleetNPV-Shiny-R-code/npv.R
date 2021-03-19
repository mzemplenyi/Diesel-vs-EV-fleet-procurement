####################
# NPV for electrification
####################

library("FinancialMath")

# discount rate 
rate <- 0.08
d.lifetime <- 12
e.lifetime <- 12 

# fuels
d.fuelprice <- 2.75
e.fuelprice <- 0.10

## Initial costs
n.bus <- 1
d.bus <- -400000
e.bus <- -700000


d.chargeinfra <- -50000
d.battsize <- 250 # in kWh

# annual mileage
miles <- 45000
d.mpg <- 3


## diesel bus fuel cost
d.annualfuel <- d.fuelprice * miles / d.mpg


d.inflows <- rep(0, times = d.lifetime)
d.outflows <- rep(d.annualfuel, times = d.lifetime )

#### FUNCTION TO CALCULATE NPV
## inflows and outflows must be the same length and should record
## annual cash inflows and outflows respectively, excluding year 0
npv <- function(discountrate, cf0, inflows, outflows){
  netcf <- inflows - outflows
  times <- c(1:length(netcf))
  presvalue <- netcf / (1+discountrate)^times
  #print(presvalue)
  return(cf0 - sum(presvalue))
}

npv(rate, d.bus, d.inflows, d.outflows )

## doublecheck that my npv function works by comparing it to the one from the FinancialMath package
# https://www.rdocumentation.org/packages/FinancialMath/versions/0.1.1/topics/NPV
NPV(d.bus, d.outflows, times = c(1:12), i = rate, plot = T)


############### 
# Simplified example for diesel bus
# Only consider initial cost and annual costs of fuel
# Draw diesel prices from a distribution
#####################



plot(function(x) dnorm(x, mean = 2.80, sd = 0.25), 1, 4, 
     type = "l", main = "Diesel price distribution", 
     xlab = "Diesel price ($US)", ylab = "Density")

NSIMS <- 1000
d.npv <- vector(mode = "numeric", length = NSIMS)
sim.fuelprices <- vector(mode = "numeric", length = NSIMS)
## BEGIN SIMULATION
for(i in 1:NSIMS){
  ## diesel bus fuel cost
  d.fuelprice <- rnorm(1, mean = 2.80, sd = 0.25)
  sim.fuelprices[i] <- d.fuelprice
  d.annualfuel <- d.fuelprice * miles / d.mpg
  
  d.inflows <- rep(0, times = d.lifetime)
  d.outflows <- rep(d.annualfuel, times = d.lifetime)
  
  d.npv[i] <- npv(rate, d.bus, d.inflows, d.outflows)
}

hist(d.npv, main = "Net Present Value Distribution", xlab = "Net Present Value", col = "purple")
