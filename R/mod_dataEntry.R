#' dataEntry UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'

#'
#' @importFrom shiny NS tagList observeEvent
#' @importFrom magrittr %>%
#' @importFrom dplyr bind_rows
#'
#'
#'
#' @noRd
mod_dataEntry_ui <- function(id){
  ns <- NS(id)
  tagList(

    shinyMobile::f7DatePicker(ns('date'),label = 'Date'),
    shinyMobile::f7Select(ns('sys'), label = 'Systolic', choices = seq(1:300), selected = 100),
    shinyMobile::f7Select(ns('dias'), label = 'Diastolic', choices = seq(1:300), selected = 70),
    shinyMobile::f7Select(ns('wt'), label = 'Weight (lbs)', choices = seq(1:300), selected = 170),
    shinyMobile::f7Select(ns('ex'), label = 'Exercise (minutes)', choices = seq(1:300), selected = 0),
    shinyMobile::f7Select(ns('meds'), label = 'Lisinopril (mg)', choices = c(0,5,10,20), selected = 0),
    shinyMobile::f7Button(ns("commit"), label = 'Save')


  )
}

#' dataEntry Server Functions
#'
#' @returns LOCAL the reactive values data object shared between modules
#'
#' @noRd
mod_dataEntry_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    #####SETUP DATA#####
    #Read current dataset in
    load('./data/bp_dataset.rda')

    #Instantiate reactive dataframe to add to
    LOCAL <- reactiveValues(
      bp_dataset = bp_dataset %>% mutate(DATE = as.Date(DATE)),#Load existing data to reactive
      newRecord = data.frame('DATE' = NA, 'SYS' = '', 'DIAS' = '', 'WT' = '',
                             'EXERCISE' = '', 'MEDS' = '', stringsAsFactors = FALSE)
    )

    #####OBSERVERS#####
    shiny::observeEvent(input$commit, {

      LOCAL$newRecord$DATE <- input$date
      LOCAL$newRecord$SYS <- as.numeric(input$sys)
      LOCAL$newRecord$DIAS <- as.numeric(input$dias)
      LOCAL$newRecord$WT <- as.numeric(input$wt)
      LOCAL$newRecord$EXERCISE <- as.numeric(input$ex)
      LOCAL$newRecord$MEDS <- as.numeric(input$meds)

      LOCAL$bp_dataset <- dplyr::bind_rows(LOCAL$bp_dataset, LOCAL$newRecord)

      LOCAL$newRecord <- LOCAL$newRecord[0,]

      bp_dataset <- LOCAL$bp_dataset

      save(bp_dataset,file = './data/bp_dataset.rda')


    })#end observeEvent

    #####OUTPUTS#####

    #####SERVER MODULE EXPORT#####
    return(LOCAL)


  })#end moduleServer
}#end mod_dataEntry_server

## To be copied in the UI
# mod_dataEntry_ui("dataEntry_1")

## To be copied in the server
# mod_dataEntry_server("dataEntry_1")
