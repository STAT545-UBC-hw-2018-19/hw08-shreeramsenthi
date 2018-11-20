library(shiny)
library(DT)
library(tidyverse)

bcl <- read_csv("bcl-data.csv") %>%
  mutate_if(is.character, str_to_title) %>% # for readable names, etc
  replace_na(list(Sweetness = 0L)) #the L specifies this is an integer

ui <- fluidPage(
  titlePanel("BC Liquor Store prices"),
  sidebarLayout(
		# Sidebar of widgets to filter data
    sidebarPanel(
			# Slidebar for price
      sliderInput("priceInput", "Price",
        0, 100, c(25, 40), pre = "$"
      ),
			# Search bar for drink name
      textInput("searchInput", "Search products by name",
        placeholder = "Psst! You can use regular expressions here!"
      ),
			# Droplist for drink type
      selectInput("typeInput", "Choose beverage type: ",
        choices = c("All", unique(bcl$Type)),
        selected = "All"
      ),
			# Droplist for x-axis of the histogram
      selectInput("axisInput", "Plot options by ",
        choices = c("Price", "Alcohol Content", "Sweetness"),
        selected = "Price"
      ),
			# Checkboxes for drink subtype
      uiOutput("subtypeInput") # See the server section for the widget code
    ),

		# Main Panel with plot and table
    mainPanel(
      plotOutput("varPlot"),
      br(), br(),
      dataTableOutput("intTable")
    )
  )
)

server <- function(input, output) {
	# Filter data by all but the subtype checkboxes
  prefiltered <- reactive({
    bcl %>%
      filter(
        Price > input$priceInput[1],
        Price < input$priceInput[2],
        str_detect(Name, input$searchInput),
        (Type == input$typeInput | input$typeInput == "All")
      )
  })
	# Use the prefiltered list to build the list of subtypes
	subtypeList <- reactive({
		prefiltered()$Subtype %>%
			fct_drop %>%
			unique
  })
	# Finally filter by subtype choice as well
	filtered <- reactive({
		prefiltered() %>%
			filter(
				Subtype %in% input$subtypeCheckbox
			)
	})

	# Drink subtype checkbox widget for side panel
  output$subtypeInput <- renderUI({
    tags$div(
      checkboxGroupInput("subtypeCheckbox", "Filter by subtype: ",
        choices = subtypeList(),
        selected = subtypeList()
			)
		)
	})

	# Plot output for main panel
	output$varPlot <- renderPlot({
    filtered() %>%
      ggplot(aes_string(str_replace(input$axisInput, " ", "_"))) +
        geom_histogram(binwidth = 1) +
        labs(x = input$axisInput, y = "Number of Products") +
        theme_bw() +
				theme(
					axis.text = element_text(size = 12),
					axis.title = element_text(size = 14, face="bold")
				)
  })

	# Interactive table for main panel
  output$intTable <- renderDataTable({
    datatable(filtered(), options = list(dom = 'tp')) # options only show table and pages
  })
}

shinyApp(ui = ui, server = server)
