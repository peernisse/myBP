#' dataEntry UI Function
#'
#' @description Entry form and data connection to add records.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @importFrom shiny NS tagList observeEvent
#' @importFrom magrittr %>%
#' @importFrom dplyr bind_rows
#' @importFrom RSQLite dbConnect dbListTables dbGetQuery dbDisconnect
#' @importFrom DBI dbGetQuery dbExecute dbDisconnect
#' @importFrom googlesheets4 gs4_auth gs4_get read_sheet sheet_append
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
      curUser = session$userData$auth0_info$name,
      #bpd = getData(session)[[1]] %>% mutate(., DATE = as.Date(DATE, origin = '1970/1/1'))#,
      bpd = getDataGS(session),
      #bpd = readRDS('./inst/app/file_bpd.Rds'),#Load existing data to reactive
      newRecord = data.frame('USER_ID' = '', 'DATE' = NA, 'SYS' = '', 'DIAS' = '', 'WT' = '',
                             'EXERCISE' = '','DRINKS' = '',  'MEDS' = '', stringsAsFactors = FALSE)
    )

    #####OBSERVERS#####
    shiny::observeEvent(input$commit, {

      #####Google sheets backend#####

      #Set newrecord values from inputs
      LOCAL$newRecord$USER_ID = LOCAL$curUser
      LOCAL$newRecord$DATE = input$date
      LOCAL$newRecord$SYS = input$sys %>% as.numeric()
      LOCAL$newRecord$DIAS = input$dias %>% as.numeric()
      LOCAL$newRecord$WT = input$wt %>% as.numeric()
      LOCAL$newRecord$EXERCISE = input$ex %>% as.numeric()
      LOCAL$newRecord$DRINKS = NA_real_
      LOCAL$newRecord$MEDS = input$meds %>% as.numeric()

      #Write record to GS
      googlesheets4::sheet_append('https://docs.google.com/spreadsheets/d/1vc3shTj6WqyrPTIbwNYOlijL50ih5Vk-5KjTfS_pVPY/edit#gid=449286518', LOCAL$newRecord, 1)

      #Clear new record
      LOCAL$newRecord <- data.frame('USER_ID' = '', 'DATE' = NA, 'SYS' = '', 'DIAS' = '', 'WT' = '',
                                    'EXERCISE' = '','DRINKS' = '',  'MEDS' = '', stringsAsFactors = FALSE)

      #Refresh data
      LOCAL$bpd <- getDataGS(session)

      #####DB BACKEND#####
      #Write new record to database
      # devUser <- 'peernisse'#This should change when user auth is set up
      #
      # qry <- paste0("INSERT INTO bpd (USER_ID, DATE, SYS,DIAS,WT,EXERCISE,MEDS) VALUES ('",
      #               devUser, "',",
      #               as.numeric(input$date), ",",
      #               ifelse(is.na(as.numeric(input$sys)),'NULL',as.numeric(input$sys)), ",",
      #               ifelse(is.na(as.numeric(input$dias)),'NULL',as.numeric(input$dias)), ",",
      #               ifelse(is.na(as.numeric(input$wt)),'NULL',as.numeric(input$wt)), ",",
      #               ifelse(is.na(as.numeric(input$ex)),'NULL',as.numeric(input$ex)), ",",
      #               ifelse(is.na(as.numeric(input$meds)),'NULL',as.numeric(input$meds)),
      #               ");"
      #               )#end paste0
      #
      # #Write record to DB
      # conn <- DBI::dbConnect(RSQLite::SQLite(), "./inst/app/bp-db.sqlite")
      # #dbGetQuery(conn, qry)#end dbGetQuery send insert statement
      # DBI::dbExecute(conn, qry)#end dbGetQuery send insert statement
      # LOCAL$bpd <- getData(session)[[1]] %>% mutate(., DATE = as.Date(DATE, origin = '1970/1/1'))#Update the LOCAL$dbd from the db
      # DBI::dbDisconnect(conn)

      #LOCAL$bpd %>% as.data.frame(.) %>% saveRDS(.,file = './inst/app/file_bpd.Rds', version =2)

      #Reset picker input values
      shinyMobile::updateF7DatePicker(inputId = 'date', value = NULL)
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


