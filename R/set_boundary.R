#' Set boundary
#'
#' Modify the spatial filter of an existing \code{ohsome_query} object
#'
#' \code{set_boundary()} adds or modifies aspatial filter of an
#' \code{ohsome_query} object. The spatial filter of a query to the ohsome API
#' can be defined as dne or more polygons, bounding boxes or bounding circles.
#'
#' @param query An \code{ohsome_query} object
#' @param boundary
#' @param boundary_type
#'
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/}
#' @export
#' @examples
set_boundary <- function(query,	boundary, ...) {

	endpoint <- gsub("^.*?/", "", httr::parse_url(query$url)$path)
	body <- query$body

	btypes <- c("bpolys", "bboxes", "bcircles")

	boundary <- ohsome_boundary(boundary, ...)

	body[[boundary$type]] <- boundary$boundary
	body[btypes[btypes != boundary$type]] <- NULL

	return(do.call(ohsome_query, c(endpoint, body)))
}
