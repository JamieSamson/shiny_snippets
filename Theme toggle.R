####################################################################
##A simple JS solution for creating light and dark themes in Shiny
####################################################################


## Packages to load ##
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyWidgets)


ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody(
    
    shinyjs::useShinyjs(),
    
    #Toggle switch
    p("Switch between light and dark"),
    prettyToggle(
      inputId="themeToggle",
      label_on="",
      label_off="",
      icon_on = icon("sun"),
      icon_off = icon("moon"),
      status_on = "info",
      status_off="info",
      value=TRUE,
      fill=FALSE,
      animation="jelly"),
    
    br(),
    h2("Heading")
    
  )
)

server <- function(input, output) { 
  
  observe(
    if(isTRUE(input$themeToggle)){ #i.e. light
      
      #UI colors - n.b. only changes header and wrapper (main panel) colours
      runjs(code = '$(".content-wrapper, .right-side").css({"background-color":"#FFFFFF"});')
      runjs(code = '$(" .skin-blue .main-header .navbar").css({"background-color":"#6ed1e3"});')
      runjs(code = '$(".skin-blue .main-header .logo").css({"background-color":"#6ed1e3"});')
      runjs(code = '$(".skin-blue .main-header .navbar .sidebar-toggle").css({"background-color":"#6ed1e3"});')
      
      #Fonts 
      runjs(code = '$("h2").css({"color":"#005377"});')
      runjs(code = '$("p").css({"color":"#005377"});')
      
    }else if(isFALSE(input$themeToggle)){ #i.e. dark
      
    #UI colors
    shinyjs::runjs(code = '$(".content-wrapper, .right-side").css({"background-color":"#005377"});')
    shinyjs::runjs(code = '$(" .skin-blue .main-header .navbar").css({"background-color":"#005377"});')
    shinyjs::runjs(code = '$(".skin-blue .main-header .logo").css({"background-color":"#005377"});')
    shinyjs::runjs(code = '$(".skin-blue .main-header .navbar .sidebar-toggle").css({"background-color":"#005377"});')
    
    #Fonts 
    runjs(code = '$("h2").css({"color":"#FFFFFF"});')
    runjs(code = '$("p").css({"color":"#FFFFFF"});')
    
    }
    )
  
}

shinyApp(ui, server)