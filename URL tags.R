####################################################################
##Capturing URL tags for surveys
####################################################################

## Packages to load ##
library(shiny)

#Working shiny app
#https://jamiesamson.shinyapps.io/url_grabber/?id=test
#This url capture works by grabbing the text after the id call in the link.

#This is useful for when you are working with third party panel providers who 
#often use id links with respondents, e.g. RID with LUCID and psid with Dynata 

#UI
ui <- fluidPage(
  
  #App title
  titlePanel("Url grabber"),
  
    #Action button to register capture and text box to show it
    mainPanel(
      #Action button
      actionButton("urlBtn","Click here to capture ID"),
      br(),
      
      #Text output box
      verbatimTextOutput("urlOut")
      
    )
)

#Server
server <- function(input, session, output) {
  
  #Capture URL id's
  urlDetails<-reactiveValues(url=NA)
  
  #Text output triggered when button pressed
  observeEvent(input$urlBtn,{
    
    #We use the parseQueryString command to capture aspects of that sessions url.
    #For concurrent users of your app this id can be different, as it works on a 
    #session by session basis
    queryID<-parseQueryString(session$clientData$url_search)
    
    #Feed the id variable to the reactive element above
    urlDetails$url<-paste0(queryID[['id']])
    
  })
  
  output$urlOut <- renderText({
    
    #Render the text if works properly 
    ifelse(is.null(urlDetails$url),"Something went wrong...",urlDetails$url)
    
  })
  
}

shinyApp(ui, server)