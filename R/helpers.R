#' Convert spatialExtent of ohsome metadata
#'
#' @param spatialExtent The \code{$extractRegion$spatialExtent} element of the
#'     parsed content of a response from the metadata endpoint of ohsome API
#'
#' @return An \code{sfc_POLYGON} object
#' @keywords internal
convert_spatialExtent <- function(spatialExtent) {

	if(spatialExtent$type != "Polygon") return(spatialExtent)

	coords <- list(t(matrix(unlist(spatialExtent$coordinates[[1]]), nrow = 2)))
	sf::st_sfc(sf::st_polygon(coords), crs = 4326)
}

#' Convert temporalExtent of ohsome metadata
#'
#' @param temporalExtent The \code{$extractRegion$temporalExtent} element of the
#'     parsed content of a response from the metadata endpoint of ohsome API
#'
#' @return A named POSIXct vector
#' @keywords internal
convert_temporalExtent <- function(temporalExtent) {
	lubridate::ymd_hms(unlist(temporalExtent), truncated = 3)
}

#' Convert ohsome metadata content
#'
#' @param content The parsed content of a response from the metadata endpoint of
#'     ohsome API
#'
#' @return a list
#' @keywords internal
convert_content <- function(content) {

	spex <- content$extractRegion$spatialExtent
	tex <- content$extractRegion$temporalExtent

	content$apiversion <- numeric_version(content$apiVersion)
	content$extractRegion$spatialExtent <- convert_spatialExtent(spex)
	content$extractRegion$temporalExtent <- convert_temporalExtent(tex)

	return(content)
}

