# Okan Güven Progress Journel

## Week 0 (March 02)

[Here](files/Example_Homework_0.html) is my 5 interesting R examples

## Homework 1 (May 04)
You can find the answers of homework 1, which we prepared as a group with Ceren Demirkol and Sevgican Varol.

* [Question 1](files/H1Q1.html)
* [Question 2](files/H1Q2.html)
* [Question 3](files/H1Q3.html)

## Homework 2 & 3 (June 07)
You can find the answers of homework 2 & 3, which we prepared as a group with Ceren Demirkol and Sevgican Varol.

* [Part A](files/H23Pa.html)
* [Part B](files/H23Pb.html)
* [Part C](files/H23Pc.html)
* [Part D](files/H23Pd.html)

## Homework 4 (June 21)
You can find the answers of homework 4, which we prepared as a group with Ceren Demirkol and Sevgican Varol.

For [Homework 4](files/HW4.html), we developed a shiny app to visualize the electricity consumption. 

In this app:

- User can filter the data by selecting a beginning and an end date.

- With display button, user can display the filtered data as a table; this summary table includes the date, hour, consumption and average temperature values.

- With plot button, user can reach 3 plots; 
    
    1- Average hourly consumption over the filtered time period
    
    2- Average hourly temperature values for multiple cities
    
    3- (BONUS) Two days ahead forecasted consumption values

- Since we user lag-48 approach for forecasting, to see the forecasting plot; the selected end date should be no later than December 27, 2019. If user selects an end date after this date, a warning is displayed below the date range selection component. 

- If user selects an end date before the starting date, a warning message is displayed for the use; stating that the end date should be on or after the start date.

Note: Live application can be accessed from [here](https://spring20-guven80.shinyapps.io/HW_4).
