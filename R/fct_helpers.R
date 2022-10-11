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


#' Persistent dataset to hold blood pressure related data.
#'
#'  \itemize{
#'    \item DATE Date column for record
#'    \item SYS numeric Systolic bp value
#'    \item DIAS numeric Diastolic bp value
#'    \item WT numeric Body weight that day in pounds
#'    \item EX numeric Minutes of exercise in last 24 hours
#'    \item MDX numeric Blood pressure medicine dosage taken that day in milligrams
#'  }
#'
#' @docType data
#' @keywords datasets
#' @name bpd
#'
#' @format Data frame
#'
#'
NULL
