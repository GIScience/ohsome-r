#' Aggregate OSM elements
#'
#' Create an \code{ohsome_query} object for OSM element aggregation
#'
#' \code{ohsome_aggregate_elements} creates an \code{ohsome_query} object for
#' OSM element aggregation. \code{ohsome_elements_count},
#' \code{ohsome_elements_length}, \code{ohsome_elements_perimeter} and
#' \code{ohsome_elements_area} are wrapper functions for specific aggregation
#' endpoints. Boundary objects are passed via \code{\link{set_boundary}} into
#' \code{\link{ohsome_boundary}}.
#'
#' @param boundary Boundary object that can be interpreted by
#'     \code{\link{ohsome_boundary}}
#' @param aggregation character; aggregation operation
#' @param return_value character; the value to be returned by the ohsome API:
#'  \describe{
#'         \item{absolute}{Returns the absolute number, length, perimeter or area
#'         of elements (default).}
#'         \item{density}{Returns the number, length, perimeter or area
#'         of elements per square kilometer.}
#'         \item{ratio}{Returns an absolute \code{value} for elements satisfying 
#'         the \code{filter} argument, an absolute \code{value2} for elements 
#'         satisfying the \code{filter2} argument, and the \code{ratio} of 
#'         \code{value2} to \code{value}}
#' }
#' @param grouping character; group type(s) for grouped aggregations. The 
#' following group types are available:
#' \describe{
#'         \item{boundary}{Groups the result by the given boundaries that are defined through any of the boundary query parameters}
#'         \item{key}{Groups the result by the given keys that are defined through the groupByKeys query parameter.}
#'         \item{tag}{Groups the result by the given tags that are defined through the groupByKey and groupByValues query parameters.}
#'         \item{type}{Groups the result by the given OSM, or simple feature types that are defined through the types parameter.}
#'         \item{c("boundary", "tag")}{Groups the result by the given boundary and the tags.}
#' }
#' Not all of these group types are accepted by all of the aggregation 
#' endpoints. Check 
#' [Grouping](https://docs.ohsome.org/ohsome-api/v1/group-by.html) 
#' for available group types.
#' @param time character; time parameter of the query (see 
#'     [Supported time formats](https://docs.ohsome.org/ohsome-api/v1/time.html); 
#'     defaults to most recent available timestamp in the underlying OSHDB)
#' @param ... Parameters of the request to the ohsome API endpoint
#'
#' @family Aggregate elements
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/stable/endpoints.html#elements-aggregation}
#' @export
#' @examples
#'
#' ohsome_aggregate_elements(mapview::franconia, "count", filter = "craft=brewery")
#' ohsome_elements_count(mapview::franconia, filter = "craft=brewery")
#' ohsome_elements_length(mapview::franconia, filter = "highway=*")
#'
ohsome_aggregate_elements <- function(
	boundary = NULL,
	aggregation = c("count", "length", "perimeter", "area"),
	return_value = c("absolute", "density", "ratio"),
	grouping = NULL,
	time = lubridate::format_ISO8601(.ohsome_temporalExtent[2]),
	...
) {
	aggregation <- match.arg(aggregation)
	return_value <- match.arg(return_value)
	if(return_value == "absolute") return_value <- NULL
	q <- ohsome_query(c("elements", aggregation, return_value), boundary, grouping, ...)
	set_time(q, time)
}

#' @export
#' @rdname ohsome_aggregate_elements
ohsome_elements_count <- function(boundary = NULL, ...) {
	ohsome_aggregate_elements(boundary, aggregation = "count", ...)
}

#' @export
#' @rdname ohsome_aggregate_elements
ohsome_elements_length <- function(boundary = NULL, ...) {
	ohsome_aggregate_elements(boundary, aggregation = "length", ...)
}

#' @export
#' @rdname ohsome_aggregate_elements
ohsome_elements_perimeter <- function(boundary = NULL, ...) {
	ohsome_aggregate_elements(boundary, aggregation = "perimeter", ...)
}

#' @export
#' @rdname ohsome_aggregate_elements
ohsome_elements_area <- function(boundary = NULL, ...) {
	ohsome_aggregate_elements(boundary, aggregation = "area", ...)
}
