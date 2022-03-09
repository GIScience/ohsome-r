#' Create an `ohsome_query` object
#'
#' Creates an `ohsome_query` object specifying the ohsome API endpoint and
#' the request parameters.
#'
#' @param endpoint The path to the ohsome API endpoint. Either a single string
#'   (e.g. `"elements/count"`) or a vector of character in the right order
#'   (e.g. `c("elements", "count")`).
#' @param boundary A boundary object that can be interpreted by
#'   [ohsome_boundary()].
#' @param grouping character; group type(s) for grouped aggregations (only 
#'   available for queries to aggregation endpoints). The following group types 
#'   are available:
#'   * `"boundary"` groups the result by the given boundaries that are defined 
#'   through any of the `boundary` query parameters
#'   * `"key"` groups the result by the given keys that are defined through the 
#'   `groupByKeys` query parameter.
#'   * `"tag"` groups the result by the given tags that are defined through the 
#'   `groupByKey` and `groupByValues` query parameters.
#'   * `"type"` groups the result by the given OSM, or simple feature types that 
#'   are defined through the `types` parameter.
#'   * `c("boundary", "tag")` groups the result by the given boundary and tags.
#' 
#'   Not all of these group types are accepted by all of the aggregation 
#'   endpoints. Check 
#'   [Grouping](https://docs.ohsome.org/ohsome-api/v1/group-by.html) 
#'   for available group types.
#' @param ... Parameters of the request to the ohsome API endpoint.
#' @param validate logical; if TRUE, issues warning for invalid endpoint or
#'   invalid/missing query parameters.
#' @return An `ohsome_query` object. The object can be sent to the ohsome API 
#'   with [ohsome_post()]. It consists of the following elements:
#'   * `url`: The URL of the endpoint.
#'   * `encode`: The way the information is encoded and then posted to the
#'   ohsome API. Set as `"form"`.
#'   * `body`: The parameters of the query such as `format`, `filter` or 
#'   `bpolys`.
#' @seealso [ohsome API documentation](https://docs.ohsome.org/ohsome-api/v1/)
#' @export
#' @examples
#' # Extract building geometries with manually set bboxes parameter
#' ohsome_query(
#'     "elements/geometry", 
#'     bboxes = "8.6,49.36,8.75,49.44", 
#'     time = "2022-01-01",
#'     filter = "building=*"
#' )
#' 
#' # Extract building geometries using a boundary object:
#' ohsome_query(
#'     "elements/geometry", 
#'     boundary = "8.6,49.36,8.75,49.44", 
#'     time = "2022-01-01",
#'     filter = "building=*"
#' )
#' 
ohsome_query <- function(
	endpoint,
	boundary = NULL,
	grouping = NULL,
	...,	
	validate = FALSE) {

	body <- lapply(list(...), paste, collapse=",")
	explicit_format <- !is.null(body[["format"]])

	if(
		!explicit_format &&
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

	if(!is.null(grouping)) query <- set_grouping(query, grouping, reset_format = !explicit_format)

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
