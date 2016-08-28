# utils script

# BMI calculator

your_bmi <- function(height,weight,scale = "Metric") {
    switch(scale,
           "Metric" = weight/(height/100)^2,
           "Standard" = weight/height^2 * 703
           )
}