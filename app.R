# Import libraries
library(shiny)
library(httr)

ui <- pageWithSidebar(
  # Page header
  headerPanel(''),
  
  # Input values
  sidebarPanel(
    HTML("<h3>Input parameters</h4>"),
    sliderInput("Distance_Km", label = "Distance (KM)", value = 1.675, min = 0.003, max = 541.541),
    sliderInput("Humidity", label = "Humidity (%)", value = 61.6816, min = 1.0, max = 100.0),
    sliderInput("Pressure_Cm", label = "Pressure (Cm)", value = 74.615, min = 0.0, max = 148.92),
    sliderInput("Visibility_Km", label = "Visibility (KM)", value = 14.736169319, min = 0.0, max = 144.81),
    sliderInput("Wind_Speed_KmPH", label = "Wind Speed (KM/H)", value = 12.455, min = 0.0, max = 305.71),
    sliderInput("Precipitation_Cm", label = "Precipitation (Cm)", value = 0.01389, min = 0.0, max = 7.62),
    sliderInput("StartHr", label = "Start Hour", value = 13, min = 0, max = 23),
    sliderInput("Temperature_C", label = "Temperature (C)", value = 17.371791908, min = -42.8, max = 77.8),
    
    radioButtons("Amenity", label="Amenity", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("Crossing", label="Crossing", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("Give_Way", label="Give Way", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("Junction", label="Junction", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("No_Exit", label="No Exit", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("Railway", label="Railway", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("Station", label="Station", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("Stop", label="Stop", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("Traffic_Signal", label="Traffic Signal", choices = c("TRUE" = TRUE, "FALSE" = FALSE)),
    radioButtons("Sunrise_Sunset", label="Sunrise/Sunset", choices = c("Day" = "Day", "Night" = "Night")),
    radioButtons("Nautical_Twilight", label="Nautical Twilight", choices = c("Day" = "Day", "Night" = "Night")),
    
    selectInput("DayOfWk", label="Day of Week", choices = c("Mon", "Tues", "Wed", "Thu", "Fri", "Sat", "Sun")),
    selectInput("TimeOfDay", label="Time of Day", choices = c("Morning", "Afternoon", "Evening", "Night")),
    selectInput("Wind_Direction_New", label="Weather Condition", choices = c("CALM", "W", "S", "N", "E", "VAR")),
    
    actionButton("submitbutton", "Submit", class = "btn btn-primary")
  ),
  
  mainPanel(
    HTML("Please remember to run <b>Lines 1137-1140</b> in <b>all-code.rmd</b> to start a local server to get predictions from our trained classifier. <br>"), 
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
    request_body <- list(Distance_Km = input$Distance_Km,
                         Humidity = input$Humidity,
                         Pressure_In = input$Pressure_In,
                         Visibility_Km = input$Visibility_Km,
                         Wind_Speed_KmPH = input$Wind_Speed_KmPH,
                         Precipitation_Cm = input$Precipitation_Cm,
                         StartHr = input$StartHr,
                         Temperature_C = input$Temperature_C,
                         Amenity = input$Amenity,
                         Crossing = input$Crossing,
                         Give_Way = input$Give_Way,
                         Junction = input$Junction,
                         No_Exit = input$No_Exit,
                         Railway = input$Railway,
                         Station = input$Station,
                         Stop = input$Stop,
                         Traffic_Signal = input$Traffic_Signal,
                         Sunrise_Sunset = input$Sunrise_Sunset,
                         Nautical_Twilight = input$Nautical_Twilight,
                         DayOfWk = input$DayOfWk,
                         TimeOfDay = input$TimeOfDay,
                         Wind_Direction_New = input$Wind_Direction_New)
    
    # Make POST request to the API
    response <- POST(url = "http://0.0.0.0:8000/predict", body = request_body, encode = "json")
    
    # Extract and display API response
    api_result <- content(response, "text")
    output$output_text <- renderText({
      if (input$submitbutton>0) {
        ans <- ""
        if (api_result == "[1]"){
          ans <- "Severe"
        } else if (api_result == "[0]"){
          ans <- "Not Severe"
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