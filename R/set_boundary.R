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
set_boundary <- function(
	query,
	boundary,
	boundary_type = c("bpolys", "bboxes", "bcircles")

) {
	endpoint <- gsub("^.*?/", "", httr::parse_url(query$url)$path)
	body <- query$body
	btypes <- c("bpolys", "bboxes", "bcircles")
	boundary_type <- match.arg(boundary_type)
	boundary <- convert_boundary(boundary, boundary_type)

	body[[boundary_type]] <- boundary
	body[btypes[btypes != boundary_type]] <- NULL

	return(do.call(ohsome_query, c(endpoint, body)))
}

#' @export
#' @rdname set_boundary
set_bpolys <- function(query, boundary) {
	set_boundary(query, boundary, boundary_type = "bpolys")
}

#' @export
#' @rdname set_boundary
set_bboxes <- function(query, boundary) {
	set_boundary(query, boundary, boundary_type = "bboxes")
}

#' @export
#' @rdname set_boundary
set_bcircles <- function(query, boundary) {
	set_boundary(query, boundary, boundary_type = "bcircles")
}
