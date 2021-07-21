#' Set boundary
#'
#' Set or modify the spatial filter of an existing \code{ohsome_query} object
#'
#' \code{set_boundary()} adds or modifies a spatial filter of an
#' \code{ohsome_query} object. The spatial filter of a query to the ohsome API
#' can be defined as one or more polygons, bounding boxes or bounding circles.
#'
#' @param query An \code{ohsome_query} object
#' @param boundary Bounding geometries that are passed to
#'     \code{\link{ohsome_boundary}}. Bounding geometries can be of class:
#'     \describe{
#'     \item{sf}{with (MULTI)POLYGON geometries}
#'     \item{sfc}{with (MULTI)POLYGON geometries}
#'     \item{sfg}{with (MULTI)POLYGON geometries and WGS 84 coordinates}
#'     \item{bbox}{created with \code{\link[sf]{st_bbox}}}
#'     \item{matrix}{created with
#'         \code{\link[sp]{bbox}} or
#'         \code{\link[osmdata]{getbb}}
#'         }
#'     \item{character}{a textual definition of bounding polygons, boxes or
#'     circles as allowed by the ohsome API (see
#'     \href{https://docs.ohsome.org/ohsome-api/stable/boundaries.html}{documentation})}
#'     }
#' @param ... Additional arguments passed to \code{\link{ohsome_boundary}}. For
#'     boundaries of class \code{sf}, \code{digits} defines the number of
#'     decimal places of coordinates in the resulting GeoJSON (defaults to 6).
#'     Other arguments are ignored.
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/}
#' @export
#' @examples
#' q <- ohsome_query("elements/count/groupBy/boundary", ilter = "building=*")
#'
#' set_boundary(q, mapview::franconia)
#' set_boundary(q, sf::st_bbox(mapview::franconia))
#' set_boundary(q, osmdata::getbb("Kigali"))
#' set_boundary(q, c("Circle 1:8.6528,49.3683,1000", "Circle 2:8.7294,49.4376,1000"))
set_boundary <- function(query,	boundary, ...) {

	endpoint <- gsub("^.*?/", "", httr::parse_url(query$url)$path)
	body <- query$body

	btypes <- c("bpolys", "bboxes", "bcircles")

	boundary <- ohsome_boundary(boundary, ...)
	
	body[[boundary$type]] <- boundary$boundary
	body[btypes[btypes != boundary$type]] <- NULL

	return(do.call(ohsome_query, c(endpoint, body)))
}
