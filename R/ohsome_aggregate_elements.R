#' Aggregate elements
#'
#' Create an \code{ohsome_query} object for OSM element aggregation
#'
#' @param boundary
#' @param boundary_type
#' @param aggregation
#' @param ...
#'
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/stable/endpoints.html#elements-aggregation}
#' @export
#' @examples
ohsome_aggregate_elements <- function(
	boundary,
	aggregation = c("count", "length", "perimeter", "area"),
	groupBy = c("none", "boundary", "key", "tag", "type"),
	...
) {
	aggregation <- match.arg(aggregation)
	query <- ohsome_query(c("elements", aggregation), ...)
	return(set_boundary(query, boundary, boundary_type))
}
