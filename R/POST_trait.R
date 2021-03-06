#' @title POST data into the Mangal traits table
#'
#' @description GET foreign keys needed for the 'traits' table then POST
#'    the metadata associated. 'attributes' and 'refs' tables must be POST
#'    before.
#'
#' @param traits_df A dataframe with three columns:\cr
#' 'taxa': taxa name as found in the taxa table
#' 'name': name of the trait as found in the attribute table\cr
#' 'value': value of the trait
#' 
#' @param network A list the network's metadata; must have the 'name' level
#'
#' @return
#'
#' The status of the injection:
#' 'trait already in mangal' means that the environment name already have an id
#' 'trait done' an id has been created and the injection is succesfull
#'
#' @author Gabriel Bergeron
#'
#' @keywords database
#'
#' @importFrom httr modify_url
#' @importFrom httr GET
#' @importFrom httr add_headers
#'
#' @export

## Create and inject traits table ##
POST_trait <- function(trait_df, network){

  # Put attribute in lowercase
  trait_df[, "name"] <- tolower(trait_df[, "name"])

  server <- mangal.env$prod$server

  # Retreive fkey for taxon_id and attr_id
  trait_df[, "taxon_id"] <- NA
  trait_df[, "attr_id"]  <- NA

  for (i in 1:nrow(trait_df)) {

    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/taxa/?original_name=",
                                                             trait_df[i, "taxa"])), config = mangal.env$headers))) == 0){

      print(paste0(trait_df[i, "taxa"], " is not in taxa table, entry was skip"))

      } else {

      trait_df[i, "taxon_id"] <- GET_fkey("taxa", c("original_name", "network_id"), c(as.character(trait_df[i, "taxa"]), GET_fkey("network", "name", network[["name"]])))

      }
  }

  for (i in 1:nrow(trait_df)) {

    if (length(content(httr::GET(url = gsub(" ", "%20", paste0(server, mangal.env$base, "/attribute/?name=",
                                                              trait_df[i, "name"])), config = mangal.env$headers))) == 0){

      print(paste0(trait_df[i, "name"], " is not in attributes table, entry was skip"))

      } else {

      trait_df[i, "attr_id"] <- GET_fkey("attribute", "name", as.character(trait_df[i, "name"]))

    }

  }

  # Add metadata
  trait_df <- cbind(data.table::setDT(trait_df),
                    data.table::setDT(as.data.frame(trait)))

  # traits_df as a json list
  trait_lst <- json_list(data.frame(trait_df))

  # Inject to traits table
  POST_table(trait_lst, "trait")

  print("trait done")

}
