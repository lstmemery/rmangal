#' @title POST a line of json data into a Mangal table
#'
#' @description POST a line of json data into the Mangal table specified by the user
#'
#' @param table_lst_line A json line of data
#' @param table A element, must be the name of the targeted table with ""
#'
#' @return
#'
#' The status of the request
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom httr modify_url
#' @importFrom httr POST
#' @importFrom httr add_headers
#' @importFrom jsonlite unbox
#'
#' @export

# Table must be inside " "
POST_line <- function (table_lst_line, table) {

  # Data.line must be of class JSON
  if(class(table_lst_line) != "json") stop(" 'table_lst_line' must be a json")

  # Connect to API
  server <- mangal.env$prod$server

  # Set the "table" as path
  path <- httr::modify_url(server, path = paste0(mangal.env$base, "/",table))

  # Post a line of data
  if ((any(grepl("\\[\\{", table_lst_line))) == TRUE) {
    httr::POST(path, body = substr(table_lst_line, 2, (nchar(table_lst_line))-1), config = mangal.env$headers)

  } else {
    httr::POST(path, body = table_lst_line, config = mangal.env$headers)
  }
}
