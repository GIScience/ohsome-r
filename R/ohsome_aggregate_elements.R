#' Aggregate elements
#'
#' Create an \code{ohsome_query} object for OSM element aggregation
#'
#' @param boundary
#' @param boundary_type
#' @param aggregation
#' @param ...
#'
#' @family Aggregate elements
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/stable/endpoints.html#elements-aggregation}
#' @export
#' @examples
ohsome_aggregate_elements <- function(
	boundary,
	aggregation = c("count", "length", "perimeter", "area"),
	...
) {
	aggregation <- match.arg(aggregation)
	query <- ohsome_query(c("elements", aggregation), ...)
	return(set_boundary(query, boundary))
}

#' @export
#' @rdname ohsome_aggregate_elements
ohsome_elements_count <- function(boundary, ...) {
	ohsome_aggregate_elements(boundary, aggregation = "count", ...)
}

#' @export
#' @rdname ohsome_aggregate_elements
ohsome_elements_length <- function(boundary, ...) {
	ohsome_aggregate_elements(boundary, aggregation = "length", ...)
}

#' @export
#' @rdname ohsome_aggregate_elements
ohsome_elements_perimeter <- function(boundary, ...) {
	ohsome_aggregate_elements(boundary, aggregation = "perimeter", ...)
}

#' @export
#' @rdname ohsome_aggregate_elements
ohsome_elements_area <- function(boundary, ...) {
	ohsome_aggregate_elements(boundary, aggregation = "area", ...)
}
