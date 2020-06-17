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
  # Create plot for graphing
  column(8, plotOutput("plot_consumption"),
            plotOutput("plot_temperature"))
)

# Create the server for the app
server = function(input, output)
{
  # Store data to be displayed
  data = fread("ETM58D_Spring20 HW 4_electricity_load_Turkey.csv")
  
  # Convert "Date" to "Date" type
  data_date = data
  data_date[, Date:=as.Date(Date, format = '%d-%m-%y')]
  
  # Filter data for consumption plot
  data_plot_consumption = eventReactive(input$button_plot, {
    if (as.integer(input$date_range_input[2]) < as.integer(input$date_range_input[1]))
      output$warning =  renderText("Warning: End date must be on or after start date!")
    else
    {
      output$warning =  renderText("")
      filtered_data = data_date[data_date$Date >= input$date_range_input[1] &
                                data_date$Date <= input$date_range_input[2]]
      
      # Calculate data for consumption plot
      data_plot_c = unique(filtered_data[,list(Hour)])
      data_plot_c = data_plot_c[, Avg_Consumption := 0]
      for(i in 0:23)
        data_plot_c[i + 1, 2] = mean(filtered_data$Consumption[filtered_data$Hour == i])
      
      plot(data_plot_c$Hour, data_plot_c$Avg_Consumption, type = "b", col = "blue", xlab = "Hours", ylab = "Average Consumption", main = "Consumption Plot")
    }
  })

  # Filter data for temperature plot
  data_plot_temperature = eventReactive(input$button_plot, {
    if (as.integer(input$date_range_input[2]) < as.integer(input$date_range_input[1]))
      output$warning =  renderText("Warning: End date must be on or after start date!")
    else
    {
      output$warning =  renderText("")
      filtered_data = data_date[data_date$Date >= input$date_range_input[1] &
                                data_date$Date <= input$date_range_input[2]]
      
      # Calculate data for temperature plot
      data_plot_t = unique(filtered_data[,list(Hour)])
      data_plot_t = data_plot_t[, Avg_Temperature := 0]
      for(i in 0:23)
        data_plot_t[i + 1, 2] = mean(c(filtered_data$T_1[filtered_data$Hour == i],
                                       filtered_data$T_2[filtered_data$Hour == i],
                                       filtered_data$T_3[filtered_data$Hour == i],
                                       filtered_data$T_4[filtered_data$Hour == i],
                                       filtered_data$T_5[filtered_data$Hour == i],
                                       filtered_data$T_6[filtered_data$Hour == i],
                                       filtered_data$T_7[filtered_data$Hour == i]))
      
      observeEvent(input$button_plot, {
        cat("Start Date: ", as.character(input$date_range_input[1]), "\n")
        cat("End Date: ", as.character(input$date_range_input[2]), "\n")
        str(data_plot_t)
      })
      
      plot(data_plot_t$Hour, data_plot_t$Avg_Temperature, type = "b", col = "red", xlab = "Hours", ylab = "Average Temperature", main = "Temperature Plot")
    }
  })
  
  # Display data
  output$plot_consumption = renderPlot({input$button_plot
    data_plot_consumption()
    })
  output$plot_temperature = renderPlot({input$button_plot
    data_plot_temperature()
    })
}

# Call shiny
shinyApp(ui = ui, server = server)
