####################################################################
##Redirecting url's
####################################################################

## Packages to load ##
library(shiny)

#Use case
#When working with third party panel providers, you often have to use redirect
#links for disqualifications, quotas and completes
#n.b., will only work when you view app in browser mode

#Redirect links
linkA <- "Shiny.addCustomMessageHandler('linkA', function(message) {window.location = 'https://www.google.co.uk/';});"
linkB <- "Shiny.addCustomMessageHandler('linkB', function(message) {window.location = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';});"

#UI
ui <- fluidPage(
  
  #Header tag for launching the code
  tags$head(
    tags$script(linkA),
    tags$script(linkB)
  ),
  
  #App title
  titlePanel("Url redirector"),
  
  #Button to action redirect
  mainPanel(
    
    #Action buttons
    actionButton("redirectLinkA","Click here to trigger link"),
    br(),
    br(),
    actionButton("redirectLinkB","Click here to trigger link"),
    
  )
)

#Server
server <- function(input, session, output) {
  
  #Redirect event A
  observeEvent(input$redirectLinkA,{
    session$sendCustomMessage("linkA", "linkA")
  })
  
  #Redirect event B
  observeEvent(input$redirectLinkB,{
    session$sendCustomMessage("linkB", "linkB")
  })
  
}

shinyApp(ui, server)