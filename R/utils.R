#' Build URL to an ohsome API endpoint
#'
#' @param endpoint character (atomic or vector)
#'
#' @return character
#' @keywords Internal
build_endpoint_url <- function(endpoint) {
	httr::modify_url(
		ohsome::ohsome_api_url$base,
		path = trimws(c(ohsome::ohsome_api_url$version, endpoint), whitespace = "/")
	)
}

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

	parsed$apiVersion <- numeric_version(parsed$apiVersion)
	parsed$extractRegion$spatialExtent <- convert_spatialExtent(spex)
	parsed$extractRegion$temporalExtent <- convert_temporalExtent(tex)

	return(parsed)
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

#' Extract endpoint
#'
#' Extract the API endpoint path from the URL in an ohsome_query object
#' @param query an ohsome_query object
#' @return character
#' @keywords Internal
extract_endpoint <- function(query) {
	gsub("^.*?/", "", httr::parse_url(query$url)$path)
}

#' Type convert without message
#'
#' Converts type of data.frame columns with \code{readr::type_convert()} while
#' suppressing messages
#'
#' @param df data.frame
#'
#' @return data.frame
#' @keywords Internal
convert_quietly <- function(df) suppressMessages(readr::type_convert(df))

#' Null coalesce operator
#'
#' @param a left-side argument
#' @param b right-side argument
#' @keywords Internal
`%||%` <- function(a, b) if (is.null(a)) b else a
