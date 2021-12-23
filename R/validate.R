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
	
	endpoint <- gsub("/$", "", endpoint)
	params <- ohsome::ohsome_endpoints[[endpoint]]$parameters$name
	required <- params[ohsome::ohsome_endpoints[[endpoint]]$parameters$required]
	unknown_params <- setdiff(names(body), params)
	missing_params <- setdiff(required, names(body))

	if(length(intersect(names(body), c("bpolys", "bboxes", "bcircles"))) != 1) {
		warning(
			"One (and only one) of the following parameters should be set: ",
			"bpolys, bboxes, or bcircles. ",
			"You can use set_boundary() to set a bounding geometry parameter.",
			call. = FALSE, 
			immediate. = TRUE
		)
	}
	
	for(param in unknown_params) {
		warning(
			param, " is not a known parameter of ",
			"endpoint ", endpoint,
			"\nSee https://docs.ohsome.org/ohsome-api/v1/",
			call. = FALSE, 
			immediate. = TRUE
		)
	}
	
	for(param in missing_params) {
		warning(
			param, " is a required parameter in queries to the endpoint ",
			endpoint,
			"You can use set_parameter() to set the ",
			param, " parameter.",
			call. = FALSE,
			immediate. = TRUE
		)
	
	}
	
	if(!("time" %in% names(body))) {
		warning(
			"time parameter is not defined and defaults to the latest ",
			"available timestamp within the underlying OSHDB. ",
			"You can use set_time() to set the time parameter.",
			call. = FALSE, 
			immediate. = TRUE
		)
	}
	
	if(!("filter" %in% names(body))) {
		warning(
			"filter parameter is not defined. ",
			"You can use set_filter() to set the filter parameter.",
			call. = FALSE, 
			immediate. = TRUE
		)
	}
	
	if(grepl("ratio", endpoint) & !("filter2" %in% names(body))) {
		warning(
			"filter2 parameter needs to be defined in ratio queries. ",
			"You can use set_filter() to set the filter2 parameter.",
			call. = FALSE, 
			immediate. = TRUE
		)
	}
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
	
	if(gsub("/$", "", endpoint) %in% names(ohsome::ohsome_endpoints)) {
		return(TRUE)
	} else {
		warning(
			"ohsome does not know endpoint ", endpoint,
			"\nSee ",
			"https://docs.ohsome.org/ohsome-api/v1/endpoint-visualisation.html",
			" for available endpoints.",
			call. = FALSE, 
			immediate. = TRUE
		)
		return(FALSE)
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
