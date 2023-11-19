library(sparklyr); library(dplyr); library(plumber)

sc <- spark_connect(master = "local", version = "3.4.0")
pipeline_path <- "accidents_spark_model"

spark_model <- ml_load(sc, path = pipeline_path)

#* @post /predict
function(Distance_Km, Humidity, Pressure_Cm, Visibility_Km, Wind_Speed_KmPH, Precipitation_Cm, StartHr, Temperature_C, Amenity, Crossing, Give_Way, Junction, No_Exit, Railway, Station, Stop, Traffic_Signal, Sunrise_Sunset, Nautical_Twilight, DayOfWk, TimeOfDay, Wind_Direction_New) {
  new_data <- data.frame(
    Distance_Km = as.numeric(Distance_Km),
    Humidity = as.numeric(Humidity),
    Pressure_Cm = as.numeric(Pressure_Cm),
    Visibility_Km = as.numeric(Visibility_Km),
    Wind_Speed_KmPH = as.numeric(Wind_Speed_KmPH),
    Precipitation_Cm = as.numeric(Precipitation_Cm),
    StartHr = as.numeric(StartHr),
    Temperature_C = as.numeric(Temperature_C),
    
    Amenity = as.logical(Amenity),
    Crossing = as.logical(Crossing),
    Give_Way = as.logical(Give_Way),
    Junction = as.logical(Junction),
    No_Exit = as.logical(No_Exit),
    Railway = as.logical(Railway),
    Station = as.logical(Station),
    Stop = as.logical(Stop),
    Traffic_Signal = as.logical(Traffic_Signal),
    
    Sunrise_Sunset,
    Nautical_Twilight,
    DayOfWk,
    TimeOfDay,
    Wind_Direction_New,
    Is_Severe = NA
  )
  
  new_data_r <- copy_to(sc, new_data, overwrite = TRUE)
  
  ml_transform(spark_model, new_data_r) |>
    pull(prediction)
}