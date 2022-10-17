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

