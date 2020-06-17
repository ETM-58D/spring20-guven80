# Include libraries
library("data.table")
library("shiny")

# Create the user interface for the app
ui = fluidPage(
  headerPanel("Electricity Consumption"),
  column(4, mainPanel(
    # Ask for dates to be filted
    dateRangeInput("date_range_input",
                   "Please select date range to be displayed and click \"Display\".",
                   start = "2017-01-01",
                   end = "2019-12-29",
                   min = "2017-01-01",
                   max = "2019-12-29",
                   weekstart = 1,
                   width = "400px",),
    actionButton("button_display", "Display"),
    textOutput("warning"),
  )),
  # Create table for data display
  column(8, tableOutput("table"))
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
    if (as.integer(input$date_range_input[2]) < as.integer(input$date_range_input[1]))
      output$warning =  renderText("Warning: End date must be on or after start date!")
    else
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
  
  # Display data
  output$table = renderTable({input$button_display
    data_table_output()
  })
}

# Call shiny
shinyApp(ui = ui, server = server)
