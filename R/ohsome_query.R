#' Create an \code{ohsome_query} object
#'
#' Creates an \code{ohsome_query} object specifying the ohsome API endpoint and
#' the request parameters.
#'
#' @param endpoint The path to the ohsome API endpoint. Either a single string
#' (e.g. \code{"elements/count"}) or a character vector in the right order
#' (e.g. \code{c("elements", "count")})
#' @param boundary Boundary object that can be interpreted by
#'     \code{\link{ohsome_boundary}}
#' @param ... Parameters of the request to the ohsome API endpoint
#' @param validate logical If TRUE, issues warning for invalid endpoint or
#'      invalid/missing query parameters
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/}
#' @export
#' @examples
#' # setting bbox parameter manually
#' ohsome_query("elements/geometry", bboxes = "8.6,49.36,8.75,49.44", filter = "building=*")
#' 
#' # using a boundary object:
#' ohsome_query("elements/geometry", boundary = "8.6,49.36,8.75,49.44", filter = "building=*")
ohsome_query <- function(
	endpoint,
	boundary = NULL,
	...,	
	validate = FALSE) {

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

	if(!is.null(boundary)) {
		btypes <- c("bpolys", "bboxes", "bcircles")
		check <- btypes %in% names(query$body)
		if(any(check)) warning(
			paste(
				"Boundary overwrites", 
				paste(btypes[check], collapse = ", "), 
				"parameter(s)."),
			call. = FALSE
		)
		
		query <- set_boundary(query, boundary)
		
	}
	
	if(validate) validate_query(query)

	return(query)
}
