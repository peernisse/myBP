#' plots UI Function
#'
#' @description Plot time series and filter tools.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#' @import ggplot2
#' @importFrom shiny NS tagList
#' @importFrom DT datatable renderDT DTOutput
#' @importFrom magrittr %>%
#' @importFrom dplyr arrange filter mutate group_by summarize
#' @importFrom tidyr pivot_longer
#'
mod_plots_ui <- function(id){
  ns <- NS(id)
  tagList(

    f7Card(id = ns('plotCard'),title = 'BP Time Series',

      plotOutput(ns('plot')),#end plotOutput

      footer = tagList(
        f7CheckboxGroup(ns('cbParams'),
                        label = 'Metrics',
                        choices = c('Blood Pressure Systolic','Blood Pressure Diastolic',
                                    'Weight','Exercise Minutes','Medication Milligrams'),
                        #choices = c('SYS','DIAS','WT','EXERCISE','MEDS'),
                        selected = 'Blood Pressure Systolic'
        ),#end f7CheckboxGroup

        f7Select(ns('dtRange'),
                        label = 'Days Back',
                        choices = c('7','14','21','30', '60','90', '180', '365', '730', '1000', '2000'),
                        selected = c('365')
        )#end f7CheckboxGroup
      )#end tagList
    ),#end f7Card

    shinyMobile::f7Card(id = ns('cdTable'), title = 'Data Table',
      DT::DTOutput(ns('editView'))#end DTOutput
    )#end card


  )#end tagList
}#end mod_plots_ui

#' plots Server Functions
#'
#' @description server function for plots module
#' @param id the module id
#' @param data the reactive values data object shared between modules
#'
#' @noRd
mod_plots_server <- function(id,data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    LOCAL <- data#Bringing in the reactive data object

    #####TABLE#####
    output$editView <- renderDT(

      dtStyle1(session,
        df = LOCAL$bpd %>%
        dplyr::mutate(DATE = as.Date(DATE)) %>%
        dplyr::arrange(desc(DATE))

      )#end dtStyle1

    )#end renderDT



    #####PLOTTING#####

    output$plot <- renderPlot({

      LOCAL$bpd %>%
        dplyr::select(-7) %>%
        tidyr::pivot_longer(3:7,names_to = 'Metric', values_to = 'Value', values_drop_na = TRUE) %>%
        dplyr::filter(DATE >= (Sys.Date() - as.numeric(input$dtRange)), Metric %in% input$cbParams) %>%
        dplyr::group_by(USER_ID,DATE,Metric) %>%
        dplyr::summarize(dispValue = mean(Value),min = min(Value),max = max(Value)) %>%
        ggplot(.,aes(DATE,dispValue,color = Metric,ymin = min, ymax = max)) +
        geom_line(size = 2) +
        geom_linerange(size = 1) +
        geom_point(size = 8) +
        theme(
          legend.position = 'bottom',
          legend.title = element_blank()
        )
    })#end renderPlot
  })#end moduleServer
}#end mod_plots_server





## To be copied in the UI
# mod_plots_ui("plots_1")

## To be copied in the server
# mod_plots_server("plots_1")
