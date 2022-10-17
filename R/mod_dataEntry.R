#' dataEntry UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @importFrom shiny NS tagList observeEvent
#' @importFrom magrittr %>%
#' @importFrom dplyr bind_rows
#' @importFrom RSQLite dbConnect dbListTables dbGetQuery dbDisconnect
#' @importFrom DBI dbGetQuery dbExecute dbDisconnect
#'
#' @noRd
mod_dataEntry_ui <- function(id){
  ns <- NS(id)

  tagList(
    shinyMobile::f7Card(
      id = ns('cdEntry'),
      title = 'Data Entry',
      shinyMobile::f7DatePicker(ns('date'),label = 'Date'),
      shinyMobile::f7Select(ns('sys'), label = 'Systolic', choices = c('--Enter Systolic--',seq(0,300)), selected = '--Enter Systolic--'),
      shinyMobile::f7Select(ns('dias'), label = 'Diastolic', choices = c('--Enter Diastolic--',seq(0,200)), selected = '--Enter Diastolic--'),
      shinyMobile::f7Select(ns('wt'), label = 'Weight (lbs)', choices = c('--Enter Weight--',seq(50,300)), selected = '--Enter Weight--'),
      shinyMobile::f7Select(ns('ex'), label = 'Exercise (minutes)', choices = c('--Enter Exercise--',seq(0,300, by = 5)), selected = '--Enter Exercise--'),
      shinyMobile::f7Select(ns('meds'), label = 'BP Med (mg)', choices = c('--Enter BP Med--','0','5','10','15','20','25','30'), selected = '--BP Med--'),
      footer = tagList(
        shinyMobile::f7Button(ns("commit"), label = 'Save')
      )#end footer
    )#end card
  )#end tagList
}#end mod_dataEntry_ui

#' dataEntry Server Functions
#'
#' @returns LOCAL the reactive values data object shared between modules
#'
#' @noRd
mod_dataEntry_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    #Instantiate reactive dataframe to add to
    LOCAL <- reactiveValues(
      bpd = getData(session)[[1]] %>% mutate(., DATE = as.Date(DATE, origin = '1970/1/1'))#,
      #bpd = readRDS('./inst/app/file_bpd.Rds'),#Load existing data to reactive
      #newRecord = data.frame('DATE' = NA, 'SYS' = '', 'DIAS' = '', 'WT' = '',
         #                    'EXERCISE' = '', 'MEDS' = '', stringsAsFactors = FALSE)
    )

    #####OBSERVERS#####
    shiny::observeEvent(input$commit, {

      #Write new record to database
      devUser <- 'peernisse'#This should change when user auth is set up

      qry <- paste0("INSERT INTO bpd (USER_ID, DATE, SYS,DIAS,WT,EXERCISE,MEDS) VALUES ('",
                    devUser, "',",
                    as.numeric(input$date), ",",
                    ifelse(is.na(as.numeric(input$sys)),'NULL',as.numeric(input$sys)), ",",
                    ifelse(is.na(as.numeric(input$dias)),'NULL',as.numeric(input$dias)), ",",
                    ifelse(is.na(as.numeric(input$wt)),'NULL',as.numeric(input$wt)), ",",
                    ifelse(is.na(as.numeric(input$ex)),'NULL',as.numeric(input$ex)), ",",
                    ifelse(is.na(as.numeric(input$meds)),'NULL',as.numeric(input$meds)),
                    ");"
                    )#end paste0

      #Write record to DB
      conn <- DBI::dbConnect(RSQLite::SQLite(), "./inst/app/bp-db.sqlite")
      #dbGetQuery(conn, qry)#end dbGetQuery send insert statement
      DBI::dbExecute(conn, qry)#end dbGetQuery send insert statement
      LOCAL$bpd <- getData(session)[[1]] %>% mutate(., DATE = as.Date(DATE, origin = '1970/1/1'))#Update the LOCAL$dbd from the db
      DBI::dbDisconnect(conn)

      #LOCAL$bpd %>% as.data.frame(.) %>% saveRDS(.,file = './inst/app/file_bpd.Rds', version =2)

      #Reset picker input values
      shinyMobile::updateF7DatePicker(inputId = 'date', value = Sys.Date())
      shinyMobile::updateF7Select('sys', selected = '--Enter Systolic--')
      shinyMobile::updateF7Select('dias', selected = '--Enter Diastolic--')
      shinyMobile::updateF7Select('wt', selected = '--Enter Weight--')
      shinyMobile::updateF7Select('ex', selected = '--Enter Exercise--')
      shinyMobile::updateF7Select('meds', selected = '--Enter BP Med--')


    })#end observeEvent

    #####SERVER MODULE EXPORT#####
    return(LOCAL)

  })#end moduleServer
}#end mod_dataEntry_server


