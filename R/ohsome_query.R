#' Create an ohsome_query object
#'
#' Creates an ohsome_query object specifying the ohsome API endpoint and the
#' request parameters.
#'
#' @param endpoint The path to the ohsome API endpoint. Either a single string
#' (e.g. \code{"elements/count"}) or a character vector in the right order
#' (e.g. \code{c("elements", "count")})
#' @param ... Parameters of the request to the ohsome API endpoint
#'
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/}
#' @export
#' @examples
ohsome_query <- function(endpoint, ...) {

	body <- list(...)
	if(any(grepl("(centroid|bbox|geometry|boundary)", endpoint))) {
		body <- c(body, format = "geojson")
	} else {
		body <- c(body, format = "csv")
	}

	structure(
		list(
			url = build_endpoint_url(endpoint),
			encode = "form",
			body = body
		),
		class = "ohsome_query"
	)
}
