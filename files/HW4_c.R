# Include libraries
library("data.table")
library("shiny")

# Create the user interface for the app
ui = fluidPage(
  headerPanel("Electricity Consumption"),
  column(4, mainPanel(
    # Ask for dates to be filted
    dateRangeInput("date_range_input",
                   "Please select date range to be plotted and click \"Plot\".",
                   start = "2017-01-01",
                   end = "2019-12-29",
                   min = "2017-01-01",
                   max = "2019-12-29",
                   weekstart = 1,
                   width = "400px",),
    actionButton("button_plot", "Plot"),
    textOutput("warning"),
  )),
  # Create plot for forecast
  column(8, plotOutput("plot_forecast"),
))

# Create the server for the app
server = function(input, output)
{
  # Store data to be displayed
  data = fread("ETM58D_Spring20 HW 4_electricity_load_Turkey.csv")
  
  # Convert "Date" to "Date" type
  data_date = data
  data_date[, Date:=as.Date(Date, format = '%d-%m-%y')]
  
  # Add forecast data and remove N/A's
  data_date = data_date[, lag_48:=shift(data_date[,3],48)]
  data_date = data_date[complete.cases(data_date)]
  
  # Filter data for forecast plot
  data_plot_forecast = eventReactive(input$button_plot, {
    if (as.integer(input$date_range_input[2]) > as.Date("2019-12-27"))
      output$warning =  renderText("Warning: For forecasting; please pick a date on or before December 27, 2019!")
    else
    {
      output$warning =  renderText("")
      filtered_data = data_date[data_date$Date == as.character(input$date_range_input[2] + 2)]
      
      plot(filtered_data$Hour, filtered_data$lag_48, type = "b", col = "green", xlab = "Hours", ylab = "Forecast", main = "Lag 48 Forecast Plot")
    }
  })
  
  # Display plot
  output$plot_forecast = renderPlot({input$button_plot
    data_plot_forecast()
  })
}

# Call shiny
shinyApp(ui = ui, server = server)
