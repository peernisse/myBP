#' dbConnector UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList

#' @importFrom RSQLite dbConnect dbListTables dbGetQuery dbDisconnect
#'
#'
#'
#'
#'
mod_dbConnector_ui <- function(id){
  ns <- NS(id)
  tagList(

  )#end tagList
}#end mod_dbConnector_ui

#' dbConnector Server Functions
#'
#' @noRd
mod_dbConnector_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    #Database connection
    conn <- dbConnect(RSQLite::SQLite(), "./inst/app/bp-db.sqlite")

    #List tables
    tbls <- dbListTables(conn)

    #Get Data
    bpd <- dbGetQuery(conn, 'SELECT * FROM bpd;')
    users <- dbGetQuery(conn, 'SELECT * FROM users;')

    dbDisconnect(conn)


    return(list(users = users,bpd = bpd))

  })#end moduleServer
}#end mod_dbConnector_server

## To be copied in the UI
# mod_dbConnector_ui("dbConnector_1")

## To be copied in the server
# mod_dbConnector_server("dbConnector_1")

##To test the module alone
# Run the application
shinyApp(ui = mod_dbConnector_ui, server = mod_dbConnector_server)
