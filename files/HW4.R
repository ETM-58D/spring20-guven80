# Include libraries
library("data.table")
library("shiny")

# Create the user interface for the app
ui = fluidPage(
  headerPanel("Electricity Consumption"),
  column(4, mainPanel(
    # Ask for dates to be filted
    dateRangeInput("date_range_input",
                   "Please select a date range; and click \"Display\" to see consumption and temperature values as a table, and click \"Plot\" to see the statistics of consumption and temperature as a plot. Please note that for forecasting plot; end date should be on or before December 27, 2019.",
                   start = "2017-01-01",
                   end = "2019-12-29",
                   min = "2017-01-01",
                   max = "2019-12-29",
                   weekstart = 1,
                   width = "400px",),
    actionButton("button_display", "Display"),
    actionButton("button_plot", "Plot"),
    textOutput("warning"),
  )),
  
  # Create table for data display
  column(4, tableOutput("table")),
  
  # Create plot for graphing
  column(4, plotOutput("plot_consumption"),
            plotOutput("plot_temperature"),
            plotOutput("plot_forecast"))
)

# Create the server for the app
server = function(input, output)
{
  # Store data to be displayed
  data = fread("ETM58D_Spring20 HW 4_electricity_load_Turkey.csv")
  
  # Convert "Date" to "Date" type
  data_date = data
  data_date[, Date:=as.Date(Date, format = '%d-%m-%y')]
  
  # Filter data for table
  data_table_output = eventReactive(input$button_display, {
    
    shiny::validate(
      shiny::need(input$date_range_input[2]>input$date_range_input[1],"Warning: End date must be on or after start date!")
    )
    
    # if (as.integer(input$date_range_input[2]) < as.integer(input$date_range_input[1]))
    #   output$warning =  renderText("Warning: End date must be on or after start date!")
    # else
    {
      output$warning =  renderText("")
      filtered_data = data_date[data_date$Date >= input$date_range_input[1] &
                                  data_date$Date <= input$date_range_input[2]]
      
      data_table = filtered_data[, 1:3]
      data_table = data_table[, "Avg Temp":=((filtered_data$T_1 +
                                                filtered_data$T_2 +
                                                filtered_data$T_3 +
                                                filtered_data$T_4 +
                                                filtered_data$T_5 +
                                                filtered_data$T_6 +
                                                filtered_data$T_7)/7)]
      
      # Convert back "Date" to "Character" type
      data_display = data_table
      data_display[, Date:=as.character(Date)]
    }
  })
  
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
      data_plot_t = data_plot_t[, Avg_T1 := 0]
      data_plot_t = data_plot_t[, Avg_T2 := 0]
      data_plot_t = data_plot_t[, Avg_T3 := 0]
      data_plot_t = data_plot_t[, Avg_T4 := 0]
      data_plot_t = data_plot_t[, Avg_T5 := 0]
      data_plot_t = data_plot_t[, Avg_T6 := 0]
      data_plot_t = data_plot_t[, Avg_T7 := 0]
      data_plot_t = data_plot_t[, Avg_Temperature := 0]
      for(i in 0:23)
      {
        data_plot_t[i + 1, 2] = mean(filtered_data$T_1[filtered_data$Hour == i])
        data_plot_t[i + 1, 3] = mean(filtered_data$T_2[filtered_data$Hour == i])
        data_plot_t[i + 1, 4] = mean(filtered_data$T_3[filtered_data$Hour == i])
        data_plot_t[i + 1, 5] = mean(filtered_data$T_4[filtered_data$Hour == i])
        data_plot_t[i + 1, 6] = mean(filtered_data$T_5[filtered_data$Hour == i])
        data_plot_t[i + 1, 7] = mean(filtered_data$T_6[filtered_data$Hour == i])
        data_plot_t[i + 1, 8] = mean(filtered_data$T_7[filtered_data$Hour == i])
        data_plot_t[i + 1, 9] = mean(c(filtered_data$T_1[filtered_data$Hour == i],
                                       filtered_data$T_2[filtered_data$Hour == i],
                                       filtered_data$T_3[filtered_data$Hour == i],
                                       filtered_data$T_4[filtered_data$Hour == i],
                                       filtered_data$T_5[filtered_data$Hour == i],
                                       filtered_data$T_6[filtered_data$Hour == i],
                                       filtered_data$T_7[filtered_data$Hour == i]))
      }
      y_min = min(data_plot_t$Avg_Temperature,
                  data_plot_t$Avg_T1,
                  data_plot_t$Avg_T2,
                  data_plot_t$Avg_T3,
                  data_plot_t$Avg_T4,
                  data_plot_t$Avg_T5,
                  data_plot_t$Avg_T6,
                  data_plot_t$Avg_T7)
      y_max = max(data_plot_t$Avg_Temperature,
                  data_plot_t$Avg_T1,
                  data_plot_t$Avg_T2,
                  data_plot_t$Avg_T3,
                  data_plot_t$Avg_T4,
                  data_plot_t$Avg_T5,
                  data_plot_t$Avg_T6,
                  data_plot_t$Avg_T7)
      
      plot(data_plot_t$Hour, data_plot_t$Avg_Temperature, type = "b", col = 1, xlab = "Hours", ylab = "Average Temperature", main = "Temperature Plot", ylim = c(y_min, y_max))
      points(data_plot_t$Hour, data_plot_t$Avg_T1, type = "l", col = 2)
      lines(data_plot_t$Hour, data_plot_t$Avg_T1, type = "l", col = 2)
      points(data_plot_t$Hour, data_plot_t$Avg_T2, type = "l", col = 3)
      lines(data_plot_t$Hour, data_plot_t$Avg_T2, type = "l", col = 3)
      points(data_plot_t$Hour, data_plot_t$Avg_T3, type = "l", col = 4)
      lines(data_plot_t$Hour, data_plot_t$Avg_T3, type = "l", col = 4)
      points(data_plot_t$Hour, data_plot_t$Avg_T4, type = "l", col = 5)
      lines(data_plot_t$Hour, data_plot_t$Avg_T4, type = "l", col = 5)
      points(data_plot_t$Hour, data_plot_t$Avg_T5, type = "l", col = 6)
      lines(data_plot_t$Hour, data_plot_t$Avg_T5, type = "l", col = 6)
      points(data_plot_t$Hour, data_plot_t$Avg_T6, type = "l", col = 7)
      lines(data_plot_t$Hour, data_plot_t$Avg_T6, type = "l", col = 7)
      points(data_plot_t$Hour, data_plot_t$Avg_T7, type = "l", col = 8)
      lines(data_plot_t$Hour, data_plot_t$Avg_T7, type = "l", col = 8)
      legend("topleft", legend = c("Avg","T1","T2","T3","T4","T5","T6","T7"), col=1:8, pch=1)
    }
  })
  
  # Filter data for forecast plot
  data_plot_forecast = eventReactive(input$button_plot, {
    if (as.integer(input$date_range_input[2]) > as.Date("2019-12-27"))
      output$warning =  renderText("Warning: For forecasting; please pick a date on or before December 27, 2019!")
    else if (as.integer(input$date_range_input[2]) < as.integer(input$date_range_input[1]))
      output$warning =  renderText("Warning: End date must be on or after start date!")
    else
    {
      output$warning =  renderText("")
      
      # Add forecast data and remove N/A's
      data_date = data_date[, lag_48:=shift(data_date[,3],48)]
      data_date = data_date[complete.cases(data_date)]
      
      filtered_data = data_date[data_date$Date == as.character(input$date_range_input[2] + 2)]
      
      plot(filtered_data$Hour, filtered_data$lag_48, type = "b", col = "green", xlab = "Hours", ylab = "Forecast", main = "Lag 48 Forecast Plot")
    }
  })
  
  # Display data
  output$table = renderTable({input$button_display
    data_table_output()
  })
  
  output$plot_consumption = renderPlot({input$button_plot
    data_plot_consumption()
  })
  
  output$plot_temperature = renderPlot({input$button_plot
    data_plot_temperature()
  })
  
  output$plot_forecast = renderPlot({input$button_plot
    data_plot_forecast()
  })
}

# Call shiny
shinyApp(ui = ui, server = server)
