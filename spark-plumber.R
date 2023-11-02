library(sparklyr); library(dplyr)

sc <- spark_connect(master = "local", version = "3.4.0")
pipeline_path <- "accidents_spark_model"

spark_model <- ml_load(sc, path = pipeline_path)

#* @post /predict
function(Distance_Mi, Humidity, Pressure_In, Visibility_Mi, Wind_Speed_Mph, Precipitation_In, StartHr, Temperature_C, Amenity, Bump, Crossing, Give_Way, Junction, No_Exit, Railway, Station, Stop, Traffic_Signal, Sunrise_Sunset, DayOfWk, TimeOfDay, Weather_Condition_New) {
  new_data <- data.frame(
    Distance_Mi = as.numeric(Distance_Mi),
    Humidity = as.numeric(Humidity),
    Pressure_In = as.numeric(Pressure_In),
    Visibility_Mi = as.numeric(Visibility_Mi),
    Wind_Speed_Mph = as.numeric(Wind_Speed_Mph),
    Precipitation_In = as.numeric(Precipitation_In),
    StartHr = as.numeric(StartHr),
    Temperature_C = as.numeric(Temperature_C),
    Amenity = as.logical(Amenity),
    Bump = as.logical(Bump),
    Crossing = as.logical(Crossing),
    Give_Way = as.logical(Give_Way),
    Junction = as.logical(Junction),
    No_Exit = as.logical(No_Exit),
    Railway = as.logical(Railway),
    Station = as.logical(Station),
    Stop = as.logical(Stop),
    Traffic_Signal = as.logical(Traffic_Signal),
    Sunrise_Sunset,
    DayOfWk,
    TimeOfDay,
    Weather_Condition_New,
    Is_Severe = NA
  )
  
  new_data_r <- copy_to(sc, new_data, overwrite = TRUE)
  
  ml_transform(spark_model, new_data_r) |>
    pull(prediction)
}