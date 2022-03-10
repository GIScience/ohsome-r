#' Set boundary
#'
#' Set or modify the spatial filter of an existing `ohsome_query` object
#'
#' [set_boundary()] adds a spatial filter to an `ohsome_query` object or 
#' replaces an exsting one. The spatial filter of a query to the ohsome API can 
#' be defined as one or more polygons, bounding boxes or bounding circles.
#'
#' @inheritParams ohsome_boundary
#' @inheritParams ohsome_post
#' @inherit ohsome_query return
#' @seealso [ohsome API documentation](https://docs.ohsome.org/ohsome-api/v1/)
#' @export
#' @examples
#' # Query without boundary definition
#' q <- ohsome_query("elements/count/groupBy/boundary", filter = "building=*")
#'
#' # Use franconia from the mapview package as bounding polygons
#' set_boundary(q, mapview::franconia, digits = 4)
#' 
#' # Use the bounding box of franconia
#' set_boundary(q, sf::st_bbox(mapview::franconia))
#' 
#' \dontrun{
#' # Get bounding box of the city of Kigali from OSM
#' set_boundary(q, osmdata::getbb("Kigali"))
#' }
#' 
#' # Definition of two named bounding circles
#' set_boundary(q, c("Circle 1:8.6528,49.3683,1000", "Circle 2:8.7294,49.4376,1000"))
#' 
set_boundary <- function(query,	boundary = NULL, ...) {

	endpoint <- gsub("^.*?/", "", httr::parse_url(query$url)$path)
	body <- query$body

	btypes <- c("bpolys", "bboxes", "bcircles")

	boundary <- ohsome_boundary(boundary %||% Reduce(`%||%`, body[btypes]), ...)
	
	body[[boundary$type]] <- boundary$boundary
	body[btypes[btypes != boundary$type]] <- NULL

	return(do.call(ohsome_query, c(endpoint, body)))
}
