#' Validate parameters
#'
#' Checks if the specified parameters in a request body are valid and issues a
#' warning if not. Returns a logical that indicates the validity of the
#' parameters.
#'
#' @inherit validate_query return
#' @param endpoint The path to the ohsome API endpoint as a single string
#'   (e.g. `"elements/count"`)
#' @param body A list of named parameters to the ohsome API request
#' @keywords Internal
#' @noRd
validate_parameters <- function(endpoint, body) {
	
	valid <- TRUE
	
	endpoint <- gsub("/$", "", endpoint)
	params <- ohsome::ohsome_endpoints[[endpoint]]$parameters$name
	required <- params[ohsome::ohsome_endpoints[[endpoint]]$parameters$required]
	unknown_params <- setdiff(names(body), params)
	missing_params <- setdiff(required, names(body))

	if(length(intersect(names(body), c("bpolys", "bboxes", "bcircles"))) != 1) {
		warning(
			"One (and only one) of the following parameters should be set: ",
			"bpolys, bboxes, or bcircles.",
			"\nYou can use set_boundary() to set a bounding geometry parameter.",
			call. = FALSE, 
			immediate. = TRUE
		)
		valid <- FALSE
	}

	if(!("time" %in% names(body)) && !("time" %in% missing_params)) {
		warning(
			"The time parameter is not defined and defaults to the latest ",
			"available timestamp within the underlying OSHDB.",
			"\nYou can use set_time() to set the time parameter.",
			call. = FALSE, 
			immediate. = TRUE
		)
		valid <- FALSE
	}
	
	if(!("filter" %in% names(body))) {
		warning(
			"The filter parameter is not defined.",
			"\nYou can use set_filter() to set the filter parameter.",
			call. = FALSE, 
			immediate. = TRUE
		)
		valid <- FALSE
	}
	
	if(grepl("ratio", endpoint) & !("filter2" %in% names(body))) {
		warning(
			"The filter2 parameter needs to be defined in ratio queries.",
			"\nYou can use set_filter() to set the filter2 parameter.",
			call. = FALSE, 
			immediate. = TRUE
		)
		valid <- FALSE
	}
	
	for(param in unknown_params) {
		warning(
			param, " is not a known parameter of ",
			"endpoint ", endpoint, ".",
			"\nYou can use set_parameters() with the argument ",
			param, " = NULL to remove it from the query.",
			call. = FALSE, 
			immediate. = TRUE
		)
		valid <- FALSE
	}
	
	for(param in missing_params) {
		warning(
			param, " is a required parameter in queries to the endpoint ",
			endpoint, ".",
			"\nYou can use set_parameters() to set the ",
			param, " parameter.",
			call. = FALSE,
			immediate. = TRUE
		)
		valid <- FALSE
	}
	
	return(valid)
}

#' Validate endpoint
#'
#' Checks if the specified endpoint is in the list of known ohsome API endpoints
#' and issues a warning if not. Specifically checks for invalid groupings in 
#' the endpoint path. Returns a logical that indicates the validity of 
#' the endpoint.
#'
#' @inheritParams validate_parameters
#' @inherit validate_query return
#' @keywords Internal
#' @noRd
validate_endpoint <- function(endpoint) {
	
	endpoint <- gsub("/$", "", endpoint)
	endpoints <- names(ohsome::ohsome_endpoints)
	split <- unlist(strsplit(endpoint, "/groupBy"))
	grouping_message <- NULL
	
	if(endpoint %in% endpoints) {
		return(TRUE)
	} else if(split[1] %in% endpoints) {
		
		if(length(split) > 1) {
			allowed <- endpoints[grepl(paste0("^", split[[1]], "/groupBy"), endpoints)]
			grouping_message <- ifelse(
				length(allowed) > 0,
				paste0(
					"\nOnly the following groupings are allowed with ",
					split[1], ":\n",
					paste("\t", gsub(split[[1]], "", allowed), collapse = "\n")
				),
				paste0("\nGrouping is not allowed with ", split[1], "."
				)
			)
		}
	}
			
	warning(
		"ohsome does not know endpoint ", endpoint,
		grouping_message,
		"\nSee ",
		"https://docs.ohsome.org/ohsome-api/v1/endpoint-visualisation.html",
		" for available endpoints.",
		call. = FALSE, 
		immediate. = TRUE
	)
	return(FALSE)

}

#' Validate ohsome_query
#'
#' Validates an ohsome_query object by checking against [ohsome_endpoints]. 
#' Returns a logical that indicates the validity of the query. 
#'
#' @inheritParams ohsome_post
#' @return logical
#' @keywords Internal
#' @noRd
validate_query <- function(query) {
	
	endpoint <- gsub("^.*?/", "", httr::parse_url(query$url)$path)
	valid_endpoint <- validate_endpoint(endpoint)
	if(valid_endpoint) {
		valid_params <- validate_parameters(endpoint, query$body)
	}
	return(valid_endpoint && valid_params)
}

#' Validate JSON response
#'
#' Validates ohsome API response content of type (Geo)JSON. Specifically checks 
#' for HTTP status messages in the content and uses any message to issue a 
#' warning. Returns a logical that indicates the validity of the JSON.
#'
#' @param json A JSON text string
#' @return logical
#' @keywords Internal
#' @noRd
validate_json <- function(json) {
	
	valid_json <- jsonlite::validate(json)
	status_message_pattern <- '.*status\" : [0-9]{3},\n  \"message\" : \"'
	
	if(!valid_json && grepl(status_message_pattern, json)) {
		warning(
			paste(
				"HTTP status message in ohsome API response content:",
				sub('\".*$', "", sub(status_message_pattern, "", json)),
				sep = "\n"
			),
			call. = FALSE
		)
	}
	return(valid_json)
}