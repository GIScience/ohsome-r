#' Convert spatialExtent of ohsome metadata
#'
#' @param spatialExtent The \code{$extractRegion$spatialExtent} element of the
#'     parsed content of a response from the metadata endpoint of ohsome API
#'
#' @return An \code{sfc_POLYGON} object
#' @keywords Internal
convert_spatialExtent <- function(spatialExtent) {

	if(spatialExtent$type != "Polygon") return(spatialExtent)

	coords <- list(matrix(spatialExtent$coordinates, ncol = 2))
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
#' @param parsed The parsed content of a response object from the metadata endpoint of
#'     ohsome API
#'
#' @return A list (parsed and converted content of ohsome metadata)
#' @keywords Internal
convert_metadata <- function(parsed) {

	spex <- parsed$extractRegion$spatialExtent
	tex <- parsed$extractRegion$temporalExtent

	parsed$apiversion <- numeric_version(parsed$apiVersion)
	parsed$extractRegion$spatialExtent <- convert_spatialExtent(spex)
	parsed$extractRegion$temporalExtent <- convert_temporalExtent(tex)

	return(parsed)
}

#' Parse content from a response
#'
#' A wrapper around \code{\link{httr::content}} to extract and parse the content
#' from an API response.
#'
#' @param resp A response object
#'
#' @return A list (parsed and converted content of ohsome metadata)
#' @keywords Internal
parse_content <- function(resp) {
	jsonlite::fromJSON(
		httr::content(resp, as = "text", encoding = "utf-8"),
		simplifyVector = TRUE
	)
}

#' Create metadata message
#'
#' Creates a message text from a \code{ohsome_metadata} object.
#'
#' @param meta An ohsome_metadata object
#'
#' @return character
#' @keywords Internal
create_metadata_message  <- function(meta) {
	sprintf(
		"Data: %s %s\nohsome API version: %s\nTemporal extent: %s to %s",
		meta$attribution$text,
		meta$attribution$url,
		meta$apiVersion,
		meta$extractRegion$temporalExtent[1],
		meta$extractRegion$temporalExtent[2]
	)
}
