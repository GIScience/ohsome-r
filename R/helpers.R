#' Convert spatialExtent metadata
#'
#' @param spatialExtent The \code{$extractRegion$spatialExtent} element of an
#'     \code{ohsome_metadata} object created with
#'     \code{\link{ohsome_get_metadata}}
#'
#' @return An \code{sfc_POLYGON} object
#' @keywords internal
convert_spatialExtent <- function(spatialExtent) {

	if(spatialExtent$type != "Polygon") return(spatialExtent)

	coords <- list(t(matrix(unlist(spatialExtent$coordinates[[1]]), nrow = 2)))
	return(sf::st_sfc(sf::st_polygon(coords), crs = 4326))
}
