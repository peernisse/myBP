# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file

pkgload::load_all(export_all = FALSE,helpers = FALSE,attach_testthat = FALSE)
options( "golem.app.prod" = TRUE)

myBP::run_app_auth0() # for auth0 on for deployment to shinyapps.io

#myBP::run_app() # add parameters here (if any); for no auth0 enabled

#FOR LOCAL TESTING WITH AUTH0 enabled, comment out before putting to shinyapp.io
#options( shiny.port = 4242)


