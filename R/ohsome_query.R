#' Create an \code{ohsome_query} object
#'
#' Creates an \code{ohsome_query} object specifying the ohsome API endpoint and
#' the request parameters.
#'
#' @param endpoint The path to the ohsome API endpoint. Either a single string
#' (e.g. \code{"elements/count"}) or a character vector in the right order
#' (e.g. \code{c("elements", "count")})
#' @param ... Parameters of the request to the ohsome API endpoint
#' @param validate logical If TRUE, issues warning for invalid endpoint or
#'      invalid/missing query parameters
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/}
#' @export
#' @examples
#' ohsome_query("elements/geometry", bbox = "8.5992,49.3567,8.7499,49.4371", filter = "building=*")
ohsome_query <- function(endpoint, ...,	validate = FALSE) {

	body <- lapply(list(...), paste, collapse=",")

	if(
		is.null(body[["format"]]) &&
		!any(grepl("(centroid|bbox|geometry)", endpoint))
	) {
		if(any(grepl("boundary", endpoint))) {
			body[["format"]] = "geojson"
		} else {
			body[["format"]] = "csv"
		}
	}

	query <- structure(
		list(
			url = build_endpoint_url(endpoint),
			encode = "form",
			body = body
		),
		class = "ohsome_query"
	)

	if(validate) validate_query(query)

	return(query)
}
