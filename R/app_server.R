#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

    #Load database tables
    #dbTables <- mod_dbConnector_server('getData')

    dataEntryOutput <- mod_dataEntry_server("dataEntry")

    mod_plots_server('plots', data = dataEntryOutput)

}#end app_server
