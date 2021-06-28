#' Parse content from an ohsome API response
#'
#' Extract and parse the content from an ohsome API response
#'
#' \code{ohsome_parse()} parses an \code{ohsome_response} object into the
#' an object of the specified class. By default, this is an \code{sf} object if
#' the ohsome API response contains GeoJSON data or a \code{data.frame} if it
#' does not. \code{ohsome_sf()}  and \code{ohsome_df()} are wrapper functions.
#'
#' @param response A response object
#' @param return_class One of the following:
#'     \describe{
#'         \item{default}{returns sf if ohsome API response is GeoJSON,
#'             else a data.frame}
#'         \item{sf}{returns sf if ohsome API response is GeoJSON,
#'             else issues a warning and returns a data.frame}
#'         \item{data.frame}{returns a data.frame}
#'         \item{list}{returns a list}
#'         \item{character}{returns the ohsome API response as text (JSON or
#'             semicolon-separated values)}
#'     }
#' @family Extract and parse the content from an ohsome API response
#' @return A list (if the response is of type "application/json"), an sf
#'     object (if the response is of type "application/geo+json") or a
#'     data.frame (if the response is of type "text/csv")
#' @export
#' @examples
ohsome_parse <- function(
	response,
	return_class = c("default", "sf", "data.frame", "list", "character")
) {

	return_class <- match.arg(return_class)

	type <- httr::http_type(response)
	content <- httr::content(response, as = "text", encoding = "utf-8")

	if(return_class == "character") {

		return(content)

	} else if(
		type == "application/json" &&
		grepl('\"type\" : \"FeatureCollection\"', content) ||
		type == "application/geo+json"

	) {
		p <- geojsonsf::geojson_sf(content)

		if(return_class == "data.frame") {
			return(sf::st_drop_geometry(p))
		} else if(return_class == "list") {
			return(as.list(p))
		} else {
			return(p)
		}

	} else if(type == "application/json") {

		p <- jsonlite::fromJSON(content, simplifyVector = TRUE)

		if(return_class == "list") {
			return(p)
		} else {
			if(return_class == "sf") {
				warning(
					"No geodata in ohsome API response. Returning data.frame ",
					"instead of sf."
				)
			}

			return(as.data.frame(p))
		}

	} else if(type == "text/csv") {

		p <- read.csv2(
			textConnection(content),
			comment.char = "#",
			header = TRUE,
			stringsAsFactors = FALSE
		)

		if(return_class == "list") {
			return(as.list(p))
		} else {
			if(return_class == "sf") {
				warning(
					"No geodata in ohsome API response. Returning data.frame ",
					"instead of sf."
				)
			}

			return(p)
		}
	} else {
		stop("ohsome API response content is neither of type (Geo)JSON nor CSV.")
	}
}

#' @export
#' @rdname ohsome_parse
ohsome_sf <- function(response) {ohsome_parse(response, return_class = "sf")}

#' @export
#' @rdname ohsome_parse
ohsome_df <- function(response) {ohsome_parse(response, return_class = "data.frame")}

# TODO: type_convert data.frame columns
