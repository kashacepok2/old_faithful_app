library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "eruptionLength",
                  label = "Length of Eruption (minutes):",
                  min = 0,
                  max = 10,
                  value = c(3, 5),
                  step = 0.5),

      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput(outputId = "distPlot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  # ----
  # ADD THIS
  # ----
  data <- reactive(
    faithful %>%
      filter(
        between(eruptions, input$eruptionLength[1], input$eruptionLength[2])
      )
  )
  
  output$distPlot <- renderPlot({
    # draw the histogram with the specified number of bins
    data() %>% ggplot(aes(x = waiting)) +
      # Modify next line
      geom_histogram(bins = input$bins, col = "white", fill = "darkgreen") + 
      xlab("Waiting time (mins)") +
      ylab("Number of eruptions") +
      ggtitle("Histogram of eruption waiting times")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)