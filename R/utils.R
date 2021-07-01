#' Build URL to an ohsome API endpoint
#'
#' @param endpoint character (atomic or vector)
#'
#' @return character
#' @keywords Internal
build_endpoint_url <- function(endpoint) {
	httr::modify_url(
		ohsome::ohsome_api_url$base,
		path = c(ohsome::ohsome_api_url$version, endpoint)
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

#' Validate endpoint
#'
#' Checks if the specified endpoint is in the list of known ohsome API endpoints
#' and issues a warning if not. Silently returns a logical that indicates the
#' validity of the endpoint.
#'
#' @param endpoint The path to the ohsome API endpoint as a single string
#'      (e.g. \code{"elements/count"})
#' @return logical
#' @keywords Internal
validate_endpoint <- function(endpoint) {

	if(endpoint %in% names(ohsome::ohsome_endpoints)) {
		return(TRUE)
	} else {
		warning(
			"ohsome does not know endpoint ", endpoint,
			"\nSee ",
			"https://docs.ohsome.org/ohsome-api/v1/endpoint-visualisation.html",
			" for available endpoints.",
			call. = FALSE
		)
	return(FALSE)
	}

}

#' Validate parameters
#'
#' Checks if the specified parameters in a request body are valid and issues a
#' warning if not. Silently returns a logical that indicates the validity of the
#' parameters.
#'
#' @param endpoint The path to the ohsome API endpoint as a single string
#'     (e.g. \code{"elements/count"})
#' @param body A list of named parameters to the ohsome API request
#' @return logical
#' @keywords Internal
validate_parameters <- function(endpoint, body) {

	params <- ohsome::ohsome_endpoints[[endpoint]]$parameters$name
	diff <- setdiff(names(body), params)

	if(length(diff) > 0) {
		warning(
			paste(diff, collapse = ", "),
			ifelse(
				length(diff) > 1,
				" are not known parameters of ",
				" is not a known parameter of "
			),
			"endpoint ", endpoint,
			"\nSee https://docs.ohsome.org/ohsome-api/v1/",
			call. = FALSE
		)
	}

	if(length(intersect(names(body), c("bpolys", "bboxes", "bcircles"))) != 1) {
		warning(
			"One (and only one) of the following parameters should be set: ",
			"bpolys, bboxes, or bcircles. ",
			"You can use set_boundary() to set a bounding geometry parameter.",
			call. = FALSE
		)
	}

	if(!("time" %in% names(body))) {
		warning(
			"Time parameter is not defined and defaults to latest ",
			"available timestamp within the underlying OSHDB. ",
			"You can use set_time() to set the time parameter.",
			call. = FALSE
		)
	}

	if(!("filter" %in% names(body))) {
		warning(
			"Filter parameter is not defined. ",
			"You can use set_filter() to set the filter parameter.",
			call. = FALSE
		)
	}
}

#' Validate ohsome_query
#'
#' Validates an ohsome_query object by checking against ohsome_endpoints.
#'
#' @param query an ohsome_query object constructed with ohsome_query()
#'     or any of its wrapper functions
#' @return logical
#' @keywords Internal
validate_query <- function(query) {

	endpoint <- gsub("^.*?/", "", httr::parse_url(query$url)$path)
	if(validate_endpoint(endpoint)) validate_parameters(endpoint, query$body)
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
