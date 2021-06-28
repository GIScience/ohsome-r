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
	boundary_type = c("bpolys", "bboxes", "bcircles"),
	aggregation = c("count", "length", "perimeter", "area"),
	groupBy = c("none", "boundary", "key", "tag", "type"),
	density = FALSE,
	ratio = FALSE,
	...
) {

	aggregation <- match.arg(aggregation)
	boundary_type <- match.arg(boundary_type)
	query <- ohsome_query(c("elements", aggregation), ...)

	return(set_boundary(query, boundary, boundary_type))
}
