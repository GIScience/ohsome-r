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
#' @param aggregation Aggregation operation
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
	...
) {
	aggregation <- match.arg(aggregation)
	ohsome_query(c("elements", aggregation), boundary, ...)
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
