#' Parse content from an ohsome API response
#'
#' Extract and parse the content from an ohsome API response
#'
#' @param response A response object
#'
#' @return A list (if the response is of type "application/json"), an sf
#'     object (if the response is of type "application/geo+json") or a
#'     data.frame (if the response is of type "text/csv")
#' @export
#' @examples
ohsome_parse <- function(response) {

	type <- httr::http_type(response)
	req_format <- attributes(response)$request_body$format
	content <- httr::content(response, as = "text", encoding = "utf-8")

	if(
		type == "application/json" &&
		(!is.null(req_format) && req_format == "geojson") ||
		type == "application/geo+json"
	) {
		parsed <- geojsonsf::geojson_sf(content)

		# TODO: does not parse bbox correctly!

	} else if(type == "application/json") {

		parsed <- jsonlite::fromJSON(content, simplifyVector = TRUE)

	} else if(type == "text/csv") {

		parsed <- read.csv2(
			textConnection(content),
			comment.char = "#",
			header = TRUE,
			stringsAsFactors = FALSE
		)
	}

	return(parsed)
}
