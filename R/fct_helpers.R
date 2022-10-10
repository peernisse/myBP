#' dtStyle1
#'
#' @description A editable DT table with option setting arguments
#'
#' @return Interactive DT.
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
