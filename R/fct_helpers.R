#' dtStyle1
#'
#' @description A editable DT table with option setting arguments
#'
#' @return Interactive DT.x
#'
#' @noRd
dtStyle1 <- function(session,df,edit = TRUE, filter = 'none', dom = 't',scrollY = '400px'){
    datatable(
        data = df,
        rownames = FALSE,
        style = "bootstrap",
        filter = filter,
        editable = edit,
        options = list(fixedHeader = TRUE, pageLength = 1000, scrollX = TRUE, scrollY = scrollY, dom = dom)
    )#end datatable
}#end function dtStyle1


#' getData
#'
#' @description Retrieves data tables from SQLite file
#'
#' @return list of dataframes
#'
#'
#' @noRd
getData <- function(session){

    ns <- session$ns
    #Database connection
    conn <- DBI::dbConnect(RSQLite::SQLite(), "./inst/app/bp-db.sqlite")

    #List tables
    tbls <- dbListTables(conn)

    #Get Data
    bpd <- DBI::dbGetQuery(conn, 'SELECT * FROM bpd;')
    users <- DBI::dbGetQuery(conn, 'SELECT * FROM users;')

    DBI::dbDisconnect(conn)

    return(list(bpd = bpd, users = users))

}#end getData



#' getDataGS
#'
#' @description Retrieves data tables from SQLite file
#'
#' @return list of dataframes
#'
#'
#' @noRd
getDataGS <- function(session){

    ns <- session$ns
    #Database connection
    googlesheets4::gs4_auth(path = './inst/app/www/.token/rivermenu-96e6b5c5652d.json')
    #conn <- googlesheets4::gs4_get('https://docs.google.com/spreadsheets/d/1vc3shTj6WqyrPTIbwNYOlijL50ih5Vk-5KjTfS_pVPY/edit#gid=449286518')
    data <- googlesheets4::read_sheet('https://docs.google.com/spreadsheets/d/1vc3shTj6WqyrPTIbwNYOlijL50ih5Vk-5KjTfS_pVPY/edit#gid=449286518') %>%
        mutate(DATE = as.Date(DATE)) %>%
        filter(USER_ID %in% session$userData$auth0_info$name)


    return(data)

}#end getData

