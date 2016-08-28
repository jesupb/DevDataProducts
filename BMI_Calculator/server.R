#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
#setwd("~/Data Science/JHU/99_Projects Repo/DevDataProducts/BMI_Calculator/")
source("utils.R")

# for the plot
bmi = seq(12,42,by = 0.1)
x = rep(1,length(bmi))
colors = rep("green",length(bmi))
colors[bmi < 18.5] = "skyblue"
colors[bmi >= 25] = "yellow"
colors[bmi >= 30] = "red"

df = data.frame(x,bmi)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$ui_height <- renderUI({
        if (is.null(input$metric_sys))
            return()
        
        # Depending on input$input_type, we'll generate a different
        # UI component and send it to the client.
        switch(input$metric_sys,
               "Metric" = numericInput("height", "Your height in cm:", 170),
               "Standard" = numericInput("height", "Your height in inches:", 67)
        )
    })
    
    output$ui_weight <- renderUI({
        if (is.null(input$metric_sys))
            return()
        
        # Depending on input$input_type, we'll generate a different
        # UI component and send it to the client.
        switch(input$metric_sys,
               "Metric" = numericInput("weight", "Your weight in kg:", 70),
               "Standard" = numericInput("weight", "Your weight in pounds:", 130)
        )
    })
    
    # get the user defined inputs
    output$measure_sys <- renderText(paste0("You are using the ",input$metric_sys," system."))
    output$in_weight <- renderText({
        units <- switch(input$metric_sys,
                        "Metric" = "kg",
                        "Standard" = "lbs")
        paste0("Your weight is ",format(input$weight,digits = 2),units,".")})
    
    output$in_height <- renderText({
        units <- switch(input$metric_sys,
                        "Metric" = "cm",
                        "Standard" = "in")
        paste0("Your height is ",format(input$height,digits = 2),units,".")
        })
    
    # calculate and print results
    output$bmi_res <- renderText({
        format(
            round(your_bmi(input$height,input$weight,input$metric_sys),digits = 2)
            )
    })
    
    # tell category
    output$bmi_cat <- renderText({
        your_mbi <- round(your_bmi(input$height,input$weight,input$metric_sys),digits = 2)
        limits <- c(0,18.5,25,30)
        cats <- c("undeweight","normal","overweight","obese")
        your_cat_index <- findInterval(your_mbi,vec = limits)
        your_category <- toupper(cats[your_cat_index])
    })
    
    # make plot
    output$scale <- renderPlot({
        user_bmi = your_bmi(input$height,input$weight,input$metric_sys)
        df2 <- data.frame(x= 1,bmi = user_bmi)
        ggplot(df, aes(x = bmi, y = x)) + 
            geom_tile(fill = colors) + 
            geom_vline(xintercept = user_bmi,
                       col = "black", size = 2) + 
            geom_label(data = df2,inherit.aes = F,aes(x = bmi, y = x),
                       label = "You are\nhere") + 
            theme_bw() + 
            scale_x_continuous(breaks = c(15.25,18.5,21.75,25,27.5,30,35),
                               labels = c("undeweight","18.5","normal","25","overweight","30","obese"),
                               expand = c(0,0))+
            scale_y_continuous(expand = c(0,0))+
            xlab("Body Mass Index") + 
            theme(axis.title.y=element_blank(),
                  axis.text.y=element_blank(),
                  axis.ticks.y=element_blank())
    }, height = 100)
  
})
