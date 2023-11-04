# Import libraries
library(shiny)
library(httr)

ui <- pageWithSidebar(
  # Page header
  headerPanel(''),
  
  # Input values
  sidebarPanel(
    HTML("<h3>Input parameters</h4>"),
    sliderInput("Distance_Mi", label = "Distance (Mi)", value = 1.04092843, min = 0.002, max = 336.570007),
    sliderInput("Humidity", label = "Humidity", value = 61.6816, min = 1.0, max = 100.0),
    sliderInput("Pressure_In", label = "Pressure (In)", value = 29.3758623, min = 0.0, max = 58.63),
    sliderInput("Visibility_Mi", label = "Visibility (Mi)", value = 9.1585846961, min = 0.0, max = 90.0),
    sliderInput("Wind_Speed_Mph", label = "Wind Speed (MPH)", value = 7.74101097781, min = 0.0, max = 190.0),
    sliderInput("Precipitation_In", label = "Precipitation (In)", value = 0.0054714150478, min = 0.0, max = 3.0),
    sliderInput("StartHr", label = "Start Hour", value = 13, min = 0, max = 23),
    sliderInput("Temperature_C", label = "Temperature (C)", value = 17.371791908, min = -42.8, max = 77.8),
    
    radioButtons("Amenity", label="Amenity", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("Bump", label="Bump", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("Crossing", label="Crossing", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("Give_Way", label="Give Way", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("Junction", label="Junction", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("No_Exit", label="No Exit", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("Railway", label="Railway", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("Station", label="Station", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("Stop", label="Stop", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("Traffic_Signal", label="Traffic Signal", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("Sunrise_Sunset", label="Sunrise_Sunset", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    
    selectInput("DayOfWk", label="Day of Week", choices = c("Mon", "Tues", "Wed", "Thu", "Fri", "Sat", "Sun")),
    selectInput("TimeOfDay", label="Time of Day", choices = c("Morning", "Afternoon", "Evening", "Night")),
    selectInput("Weather_Condition_New", label="Weather Condition", choices = c("Fair", "Cloudy", "Heavy Rain", "Rainy", "Windy", "Heavy Snow", "Snow", "Fog/Haze/Smoke/Mist", "Freezing Rain", "Hail/Dust/Sand/Tornado")),
    
    actionButton("submitbutton", "Submit", class = "btn btn-primary")
  ),
  
  mainPanel(
    HTML("Please remember to run <b>Lines 718-721</b> in <b>all-code.rmd</b> to start a local server to get predictions from our trained classifier. <br>"), 
    tags$label(h3('Status/Output')), # Status/Output Text Box
    verbatimTextOutput('contents'),
    h2(textOutput("output_text"))
  )
)

# Server                           
server <- function(input, output, session) {
  
  observeEvent(input$submitbutton, {
    # Get the user input
    user_input <- input$input_param
    
    # Create a request body
    request_body <- list(Distance_Mi = input$Distance_Mi,
                         Humidity = input$Humidity,
                         Pressure_In = input$Pressure_In,
                         Visibility_Mi = input$Visibility_Mi,
                         Wind_Speed_Mph = input$Wind_Speed_Mph,
                         Precipitation_In = input$Precipitation_In,
                         StartHr = input$StartHr,
                         Temperature_C = input$Temperature_C,
                         Amenity = input$Amenity,
                         Bump = input$Bump,
                         Crossing = input$Crossing,
                         Give_Way = input$Give_Way,
                         Junction = input$Junction,
                         No_Exit = input$No_Exit,
                         Railway = input$Railway,
                         Station = input$Station,
                         Stop = input$Stop,
                         Traffic_Signal = input$Traffic_Signal,
                         Sunrise_Sunset = input$Sunrise_Sunset,
                         DayOfWk = input$DayOfWk,
                         TimeOfDay = input$TimeOfDay,
                         Weather_Condition_New = input$Weather_Condition_New)
    
    # Make POST request to the API
    response <- POST(url = "http://127.0.0.1:8000/predict", body = request_body, encode = "json")
    
    # Extract and display API response
    api_result <- content(response, "text")
    output$output_text <- renderText({
      if (input$submitbutton>0) { 
        ans <- ""
        if (api_result == 0){
          ans <- "Not Severe"
        } else{
          ans <- "Severe"
        }
        paste("This accident is", ans)
      } 
    })
  })
    
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Prediction complete.") 
    } else {
      return("Server is ready for prediction.")
    }
  })
}

shinyApp(ui = ui, server = server)