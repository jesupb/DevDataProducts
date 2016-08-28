
library(shiny)

# Define UI for application 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("BMI Calculator"),
  
  # Sidebar with input options
  sidebarLayout(
    sidebarPanel(
        helpText("This app will let you calculate your body mass index,
                 and know if you're within an underweight, normal, 
                 overweight or obesity range!"),
        
        selectInput("metric_sys",
                    label = "Choose whether you're going to input your height and weight
                    in the metric system or the standard US system:",
                    choices = c("Metric","Standard"),
                    selected = "Metric"),
        
        wellPanel(uiOutput("ui_height")),
        wellPanel(uiOutput("ui_weight"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
        h2("Your results: ",style = "color : #b30000;"),
        br(),
        wellPanel(textOutput("measure_sys"),
        textOutput("in_weight"),
        textOutput("in_height")),
        br(),
        tags$p("Thus your BMI is: "),
        wellPanel(tags$ins(tags$b(textOutput("bmi_res")))),
        br(),
        tags$p("Your category is: "),
        wellPanel(tags$b(textOutput("bmi_cat"))),
        br(),
        p("If you want to learn more you can find more info at ",
          tags$a("this site.",
                 href = "http://www.nhlbi.nih.gov/health/educational/lose_wt/BMI/bmi-m.htm")
        ),
        plotOutput("scale")
    )
  )
))
