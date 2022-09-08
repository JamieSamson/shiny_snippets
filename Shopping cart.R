####################################################################
##AAn editable 'shopping cart' for Shiny
####################################################################

## Packages to load ##
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyWidgets)
library(tidyverse)
library(DT)

#The data
cartDf<-data.frame(style=c("Style A","Style B","Style C"),
                   colour=c("Blue","Green","Yellow"),
                   unitPrice=c("10","15","12"))


ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    
    #Add some drop downs in the side bar to create your product
    pickerInput("style",label="Style",choices=unique(cartDf$style),multiple = F),
    pickerInput("colour",label="Colour",choices=unique(cartDf$colour),multiple = F),
    uiOutput("price",label="Unit price"),
    numericInput("quantity",label="Quantity",value=0),
    
    
    #Add to cart button (with some styling)
    actionButton("addBtn",label="Add product to cart",style='font-size:14px; background-color: #76dcb9; color: black;')
    
  ),
  dashboardBody(
    
    #Delete highlighted rows button
    actionButton("delBtn",label="Delete",style='background-color: red; color: white; font-size:80%; margin-bottom: 10px;'),
    
    #Add table to UI
    DT::dataTableOutput("mytable")
    
  )
)

server <- function(input, output) { 
  
  
  #Create an empty reactive dataframe
  values <- reactiveValues()
  
  qty<-reactive({
    
    #Filter product data.frame for chosen product
    productFilter<- cartDf %>% filter(style==input$style & colour==input$colour)
    
    #Add quantity
    productFilter$qty<-as.numeric(paste0(input$quantity))
    
    #Add total price
    productFilter$totalPrice<-productFilter$qty*as.numeric(paste0(productFilter$unitPrice))
  
    productFilter

  })
  
  #Render price text
  output$price<-renderUI({
    HTML("<center><h4>",paste0("£",qty()$unitPrice),"</h4></center>")
    
  })
  
  
  #Set up to add row
  values$df <- data.frame(style=character(),
                          colour=character(),
                          unitPrice=numeric(0),
                          qty=numeric(0),
                          totalPrice=numeric(0))
  
  observeEvent(input$addBtn,{
    newLine <- isolate(qty())
    isolate(values$df <- rbind(values$df, qty()))
  })
  
  #Table output
  output$mytable <- renderDataTable({
    tbl<-values$df

    datatable(
      tbl,
      escape=F,
      editable = list(target = "cell", disable = list(columns =c(1:3,5))),
      options = list(dom = 'ft',
                     ordering=F))

  })
  
  #Delete button action
  observeEvent(input$delBtn,{
    
    if (!is.null(input$mytable_rows_selected)) {
      
      values$df <- values$df[-as.numeric(input$mytable_rows_selected),]
    }
  })
  
  
  #Quantity cell edit action
  observeEvent(input$mytable_cell_edit, {
    info = input$mytable_cell_edit
    i = info$row
    j = info$col
    v = info$value
    
    values$df[i, j] <- isolate(DT::coerceValue(v, values$df[i, j]))

  })
  
  #Update total price
  observeEvent(input$mytable_cell_edit, {
    info = input$mytable_cell_edit
    i = info$row
    j = info$col
    v = info$value
    
    values$df[i,5] <- isolate(DT::coerceValue(v, values$df[i, j]))*as.numeric(values$df[i,3])
  })

  
  
}

shinyApp(ui, server)