library(shiny)

# Define available pollutants and their directories
pollutants <- list(
  "CO (CALINE4)" = list(folder = "CO_maps", prefix = "CO"),
  "NO2 (LUR)" = list(folder = "NO2_maps", prefix = "NO2"),
  "Nickel (LUR)" = list(folder = "Ni_maps", prefix = "Ni"),
  "Benzene (LUR)" = list(folder = "Ben_maps", prefix = "Ben"),
  "1,3-Butadiene (LUR)" = list(folder = "But_maps", prefix = "But"),
  "PM2.5 (CTM)" = list(folder = "PM25_maps", prefix = "PM25"),
  "PM2.5 (LUR)" = list(folder = "PM2.5_maps", prefix = "PM2.5"),
  "O3 (LUR)" = list(folder = "O3_maps", prefix = "O3")
)

# Define available years
years <- 1989:2016  

ui <- fluidPage(
  titlePanel("Annual Average Pollutant Concentration by Year"),
  sidebarLayout(
    sidebarPanel(
      selectInput("pollutant", "Select Pollutant:", choices = names(pollutants)),
      sliderInput("year", "Select Year:", min = min(years), max = max(years), value = min(years), step = 1, sep = "")
    ),
    mainPanel(
      imageOutput("pollutantMap", width = "100%")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$pollutant, {
    updateSliderInput(session, "year", value = 1989)
  })
  
  output$pollutantMap <- renderImage({
    folder <- pollutants[[input$pollutant]]$folder
    prefix <- pollutants[[input$pollutant]]$prefix
    filename <- paste0(folder, "/", prefix, "_", input$year, ".png")
    filepath <- file.path("www", filename)
    
    list(src = filepath,
         contentType = 'image/png',
         width = "100%",
         alt = paste(input$pollutant, input$year))
  }, deleteFile = FALSE)
}

shinyApp(ui, server)