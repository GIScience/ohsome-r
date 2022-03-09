#' Aggregate OSM elements
#'
#' Creates an `ohsome_query` object for OSM element aggregation
#'
#' `ohsome_aggregate_elements()` creates an `ohsome_query` object for
#' OSM element aggregation. `ohsome_elements_count()`,
#' `ohsome_elements_length()`, `ohsome_elements_perimeter()` and
#' `ohsome_elements_area()` are wrapper functions for specific aggregation
#' endpoints. Boundary objects are passed via [set_boundary()] into
#' [ohsome_boundary()].
#'
#' @inheritParams ohsome_query
#' @param aggregation character; aggregation operation
#' @param return_value character; the value to be returned by the ohsome API:
#'   * `"absolute"` returns the absolute number, length, perimeter or area of 
#'   elements. This is the default.
#'   * `"density"` returns the number, length, perimeter or area of elements per 
#'   square kilometer.
#'   * `"ratio"` returns an absolute `value` for elements satisfying the 
#'   `filter` argument, an absolute `value2` for elements satisfying the 
#'   `filter2` argument, and the `ratio` of `value2` to `value`.
#' @param time character; time parameter of the query (see 
#'   [Supported time formats](https://docs.ohsome.org/ohsome-api/v1/time.html); 
#'   defaults to most recent available timestamp in the underlying OSHDB)
#' @inherit ohsome_query return
#' @seealso [ohsome API Endpoints - Elements Aggregation](https://docs.ohsome.org/ohsome-api/stable/endpoints.html#elements-aggregation)
#' @export
#' @family Aggregate elements
#' @examples
#' # Count of breweries in Franconia
#' ohsome_aggregate_elements(mapview::franconia, "count", filter = "craft=brewery")
#' ohsome_elements_count(mapview::franconia, filter = "craft=brewery")
#' 
#' # Monthly counts of breweries in Franconia from 2010 to 2020
#' ohsome_elements_count(
#'     mapview::franconia, 
#'     filter = "craft=brewery", 
#'     time = "2010/2020/P1M"
#' )
#' 
#' # Count of breweries per district of Franconia
#' ohsome_elements_count(
#'     mapview::franconia, 
#'     filter = "craft=brewery", 
#'     grouping = "boundary"
#' )
#' 
#' # Proportion of breweries in Franconia that are Microbreweries
#' ohsome_elements_count(
#'     mapview::franconia, 
#'     filter = "craft=brewery", 
#'     filter2 = "craft=brewery and microbrewery=yes", 
#'     return_value = "ratio"
#' ) 
#' 
#' # Total length of highway elements in Franconia
#' ohsome_elements_length(mapview::franconia, filter = "highway=* and geometry:line")
#'
ohsome_aggregate_elements <- function(
	boundary = NULL,
	aggregation = c("count", "length", "perimeter", "area"),
	return_value = c("absolute", "density", "ratio"),
	grouping = NULL,
	time = lubridate::format_ISO8601(ohsome_temporalExtent[2]),
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
