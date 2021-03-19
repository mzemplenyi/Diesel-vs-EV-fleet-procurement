# Diesel-vs-EV-fleet-procurement
This is a working-version of a tool that can be used to compare the net present value (NPV) cost of bus procurement options (e.g. diesel bus vs. electric bus). The Shiny app can be viewed at: https://michele-zemplenyi.shinyapps.io/fleetnpv_shiny/.

The tool uses a simulation approach to perform sensitivity analyses for the diesel price ($/gallon) and the electricity rate ($/kWh); for each simulation, unique values are generated from normal distributions with mean and standard deviation specified by the user on the 'Diesel' and 'Electric' tabs.

To use this tool, enter global inputs and procurement inputs in the tabs above. After clicking 'Run simulation,' a histogram displaying the difference in NPV costs across all simulations will appear below.

Note that the current version of this tool only accounts for a small subset of the costs of purchasing and operating a bus; future updates will include additional cost inputs (e.g. maintenance, financing) and the ability to specify other distributions for the diesel and electricity prices.
