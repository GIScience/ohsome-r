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
#' @param grouping character; group type(s) for grouped aggregations (only 
#' available for queries to aggregation endpoints). In general, the following
#' group types are available:
#' \describe{
#'         \item{boundary}{Groups the result by the given boundaries that are defined through any of the boundary query parameters}
#'         \item{key}{Groups the result by the given keys that are defined through the groupByKeys query parameter.}
#'         \item{tag}{Groups the result by the given tags that are defined through the groupByKey and groupByValues query parameters.}
#'         \item{type}{Groups the result by the given OSM, or simple feature types that are defined through the types parameter.}
#'         \item{c("boundary", "tag")}{Groups the result by the given boundary and the tags.}
#' }
#' Not all of these group types are accepted by all of the aggregation 
#' endpoints. Please consult the 
#' [ohsome API documentation](https://docs.ohsome.org/ohsome-api/v1/group-by.html) 
#' to check for available group types.
#' @param ... Parameters of the request to the ohsome API endpoint
#' @param validate logical; if TRUE, issues warning for invalid endpoint or
#'      invalid/missing query parameters
#' @return An \code{ohsome_query} object. The object consists of the following elements: 
#' \describe{
#'         \item{url}{The url of the endpoint.}
#'         \item{encode}{The way the information is encoded then posted to the ohsome API. Set as "form".}
#'         \item{body}{The parameters of the query such as \code{format}, 
#'         \code{filter} or \code{bpolys}.}
#'         }
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
	grouping = NULL,
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
	
	if(!is.null(grouping)) query <- set_grouping(query, grouping, reset_format = is.null(body[["format"]]))

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
