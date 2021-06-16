#' Convert spatialExtent of ohsome metadata
#'
#' @param spatialExtent The \code{$extractRegion$spatialExtent} element of the
#'     parsed content of a response from the metadata endpoint of ohsome API
#'
#' @return An \code{sfc_POLYGON} object
#' @keywords Internal
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
#' @return A \code{POSIXct} vector
#' @keywords Internal
convert_temporalExtent <- function(temporalExtent) {
	lubridate::ymd_hms(unlist(temporalExtent), truncated = 3)
}


#' Convert ohsome metadata content
#'
#' Converts the following elements: \code{apiVersion} to \code{numeric_version},
#' \code{spatialExtent} to \code{sfc_POLYGON} and \code{temporalExtent} to a
#' vector of \code{POSIXct}
#'
#' @param content The parsed content of a response from the metadata endpoint of
#'     ohsome API
#'
#' @return A list (parsed and converted content of ohsome metadata)
#' @keywords Internal
convert_content <- function(content) {

	spex <- content$extractRegion$spatialExtent
	tex <- content$extractRegion$temporalExtent

	content$apiversion <- numeric_version(content$apiVersion)
	content$extractRegion$spatialExtent <- convert_spatialExtent(spex)
	content$extractRegion$temporalExtent <- convert_temporalExtent(tex)

	return(content)
}

