#' @title GET id key from a Mangal entry
#'
#' @description GET primary key of a table entry specified by the user
#'
#' @param table A element, must be the name of the targeted table with ""
#' @param attribute A element, must be the name of the targeted attribute with ""
#' @param value A element, must be the value of the targeted attribute with ""
#'
#' @return
#'
#' The value of the primary key of a specified entry
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom httr modify_url
#' @importFrom httr GET
#' @importFrom httr content
#'
#' @export

GET_fkey <- function(table, attribute, value){

  # Connect to API
  server <- "http://localhost:3000"

  # Set the table and name as path
  url <- httr::modify_url(server, path = paste0("/api/v0/", table, "?", attribute, "=", value))

  # Change space in url by "_"
  url <- gsub(" ", "%20", url)

  # Retreive data from Mangal
  data <- httr::GET(url)
  data <- httr::content(data)

  # Get data into vector
  data <- unlist(data)

  if(is.null(data[[1]] == TRUE)){

    print("wrong attribute, check spelling; value or table inexistant, no associated id")

  } else {

    return(data[[1]])

    }
}