#' Set endpoint
#'
#' Modifies the endpoint of an existing `ohsome_query` object
#'
#' `set_endpoint()` takes an `ohsome_query` object and modifies the ohsome API 
#' endpoint. `set_grouping()` takes an `ohsome_query` object and modifies the 
#' endpoint path for grouped aggregations.
#'
#' @inherit ohsome_query params return
#' @inheritParams ohsome_post
#' @param append logical; If `TRUE`, the provided endpoint string is appended to  
#'   the existing endpoint definition instead of replacing it. This is 
#'   particularly useful if you wish to add  `density`/`ratio` and/or a grouping
#'   to an existing aggregation query.
#' @param reset_format logical; if `TRUE`, the format parameter of the query is 
#'   updated depending on the new endpoint.
#' @param ... Additional arguments passed to `set_endpoint()`
#' @family Set endpoint
#' @seealso [ohsome API Endpoints](https://docs.ohsome.org/ohsome-api/v1/endpoints.html)
#' @export
#' @examples
#' # Query for count of elements
#' q <- ohsome_elements_count(
#'   boundary = "HD:8.5992,49.3567,8.7499,49.4371|HN:9.1638,49.113,9.2672,49.1766",
#'   time = "2022-01-01",
#'   filter = "highway=*"
#' )
#'
#' # Modify query to aggregate length of elements instead of count
#' set_endpoint(q, "elements/length")
#' 
#' # Modify query to extract geometries instead of aggregating elements
#' set_endpoint(q, "elements/geometry")
#' 
#' # Append the endpoint path in order to group aggregation by boundary
#' set_endpoint(q, "groupBy/boundary", append = TRUE)
#' 
#' # Modify query to group aggregation by boundary
#' set_grouping(q, grouping = "boundary")
#' 
#' # Modify query to group by boundary, but keep format csv instead of geojson
#' set_grouping(q, grouping = "boundary", reset_format = FALSE)
#' 
#' # Append the endpoint path to query for element densities per boundary
#' set_endpoint(q, c("density", "groupBy", "boundary"), append = TRUE)
#' 
#' # Modify query to group aggregation by OSM element type
#' set_grouping(q, grouping = "type")
#' 
set_endpoint <- function(query,	endpoint, append = FALSE, reset_format = TRUE) {

	if(append) {
		old <- gsub("^.*?/", "", httr::parse_url(query$url)$path)
		endpoint <- paste(old, paste(endpoint, collapse = "/"), sep = "/")
	}

	body <- query$body
	if(reset_format) body$format <- NULL

	return(do.call(ohsome_query, c(endpoint, body)))
}

#' @export
#' @rdname set_endpoint
set_grouping <- function(query, grouping, ...) {
	
	if(missing(grouping)) return(query)
	
	old <- gsub("^.*?/", "", httr::parse_url(query$url)$path)
	split <- unlist(strsplit(old, "/groupBy/"))
	if(!is.null(grouping)) {
		grouping <- paste("groupBy", tolower(grouping), sep = "/", collapse = "/")
	}
	endpoint <- paste(split[1], grouping, sep = "/")
	
	set_endpoint(query, endpoint, ...)
}
