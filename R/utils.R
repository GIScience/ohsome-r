#' Build URL to an ohsome API endpoint
#'
#' @param endpoint character (atomic or vector)
#' @return character
#' @keywords Internal
build_endpoint_url <- function(endpoint) {
	trimws(
		httr::modify_url(
			ohsome::ohsome_api_url$base,
			path = c(ohsome::ohsome_api_url$version, endpoint)
		), 
		whitespace = "/"
	)
}

#' Convert spatialExtent of ohsome metadata
#'
#' @param spatialExtent The `$extractRegion$spatialExtent` element of the
#'   parsed content of a response from the metadata endpoint of ohsome API
#' @return An `sfc_POLYGON` object
#' @keywords Internal
convert_spatialExtent <- function(spatialExtent) {

	if(spatialExtent$type != "Polygon") return(spatialExtent)

	coords <- list(matrix(spatialExtent$coordinates, ncol = 2))
	sf::st_sfc(sf::st_polygon(coords), crs = 4326)
}


#' Convert temporalExtent of ohsome metadata
#'
#' @param temporalExtent The `$extractRegion$temporalExtent` element of the
#'   parsed content of a response from the metadata endpoint of ohsome API
#' @return A `POSIXct` vector
#' @keywords Internal
convert_temporalExtent <- function(temporalExtent) {
	lubridate::ymd_hms(unlist(temporalExtent), truncated = 3)
}


#' Convert ohsome metadata content
#'
#' Converts the following elements of a response from the metadata endpoint of 
#' ohsome API: `apiVersion` to `numeric_version`, `spatialExtent` to 
#' `sfc_POLYGON` and `temporalExtent` to a vector of `POSIXct`
#'
#' @param parsed The parsed content of a response object from the metadata 
#'   endpoint of ohsome API
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
#' Creates a message text from an `ohsome_metadata` object.
#'
#' @param meta An [ohsome_metadata] object
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
#' Extracts the API endpoint path from the URL in an `ohsome_query` object
#' @inheritParams ohsome_post
#' @return character
#' @keywords Internal
extract_endpoint <- function(query) {
	gsub("^.*?/", "", httr::parse_url(query$url)$path)
}


#' Type convert without message
#'
#' Converts types of data.frame columns with [readr::type_convert()] while
#' suppressing messages
#'
#' @param df data.frame
#' @return data.frame
#' @keywords Internal
convert_quietly <- function(df) suppressMessages(readr::type_convert(df))


#' Null coalesce operator
#' 
#' Operator that returns the left-hand side operand if it is not `NULL`, else 
#' returns the right-hand side operand
#' 
#' @name null-coalesce
#' @param a left-side argument
#' @param b right-side argument
#' @keywords Internal
`%||%` <- function(a, b) if (is.null(a)) b else a
