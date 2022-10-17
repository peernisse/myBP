#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny shinyMobile htmltools
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    f7Page(allowPWA = TRUE,
      f7SingleLayout(navbar = f7Navbar(title = 'Blood Pressure Data'),


                     mod_dataEntry_ui("dataEntry"),
                     mod_plots_ui('plots')





      )#end f7singleLayout
    )#end f7Page
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "myBP"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
