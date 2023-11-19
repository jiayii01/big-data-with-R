# DSA306 Group Project: Modelling on US Car Accidents

## How to run our Shiny application
1. Run Lines 1218-1221 in code file <b>all-code.Rmd</b>
These lines of code expose our saved classification model as a web service at Port 8000.
```R
plumb(file = "spark-plumber.R") |>
  pr_run(host = "0.0.0.0", port = 8000)
```

2. Start a New R Session <br>
Running the API and running the Shiny application must be done on separate R sessions

3. Run Shiny Application (app.R)
![image](https://github.com/jiayii01/dsa306-project-group-7/assets/79521323/c7f351cf-4ef1-42cf-ac6a-aa1d1281697a)

4. Shiny Application is ready for predictions!
![image](https://github.com/jiayii01/dsa306-project-group-7/assets/79521323/134d7cd3-f354-4302-a377-57a19a469a96)

