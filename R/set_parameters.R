#' Set parameters
#'
#' Set or modify parameters of an existing \code{ohsome_query} object
#'
#' \code{set_parameters()} takes an \code{ohsome_query} object and an arbitrary
#' number of named parameters as an input. It sets or modifies these parameters
#' in the \code{ohsome_query} and returns the modified object. \code{set_time()},
#' \code{set_filter()}, \code{set_groupByKey()}, \code{set_groupByKey()},
#' \code{set_groupByValues()} and  \code{set_properties()} are wrapper functions
#' to set specific parameters. By default, an unmodified \code{ohsome_query}
#' object is returned. In order to remove a parameter from the query object, you 
#' can set the respective argument explicitly to NULL 
#' (e.g. \code{set_filter(query, filter = NULL)}).
#'
#' @param query An \code{ohsome_query} object
#' @param ... named parameters (e.g. \code{time = "2020-01-01"})
#' @param time time parameter of the query
#' @param filter filter parameter of the query
#' @param filter2 filter2 parameter of a ratio query
#' @param groupByKeys groupByKeys parameter of a groupBy/key query
#' @param groupByKey groupByKey parameter of a groupBy/tag query
#' @param groupByValues groupByValues parameter of a groupBy/tag query
#' @param properties properties parameter of an extraction query. Can be 
#'     "tags" to extract all tags with the elements and/or
#'     "metadata" to provide metadata with the elements and/or 
#'     "contributionTypes" to provide contribution types (only in contribution
#'     extraction queries). Multiple values can be provided as comma-separated 
#'     character or as character vector. 
#'     Default: NULL (removes \code{properties} parameter from query body)
#' @family Set parameters
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/}
#' @export
#' @examples
#' q <- ohsome_query("elements/count/ratio/groupBy/boundary")
#'
#' q |>
#'     set_boundary("HD:8.5992,49.3567,8.7499,49.4371|HN:9.1638,49.113,9.2672,49.1766") |>
#'     set_time("2021") |>
#'     set_filter("building=*", filter2 = "building=* and building:levels=3") |>
#'     set_parameters(format = "csv")
#'
set_parameters <- function(query, ...) {

	endpoint <- extract_endpoint(query)
	body <- query$body

	params <- list(...)

	for(i in 1:length(params)) body[[names(params[i])]] <- params[[i]]

	return(do.call(ohsome_query, c(endpoint, body)))
}

#' @export
#' @rdname set_parameters
set_time <- function(query, time = query$body$time) {
	set_parameters(query, time = time)
}

#' @export
#' @rdname set_parameters
set_filter <- function(query, filter = query$body$filter, filter2 = query$body$filter2) {
	set_parameters(query, filter = filter, filter2 = filter2)
}

#' @export
#' @rdname set_parameters
set_groupByKeys <- function(query, groupByKeys = query$body$groupByKeys) {
	set_parameters(query, groupByKeys = groupByKeys)
}

#' @export
#' @rdname set_parameters
set_groupByKey <- function(query, groupByKey = query$body$groupByKey) {
	set_parameters(query, groupByKey = groupByKey)
}

#' @export
#' @rdname set_parameters
set_groupByValues <- function(query, groupByValues = query$body$groupByValues) {
	set_parameters(query, groupByValues = groupByValues)
}

#' @export
#' @rdname set_parameters
set_properties <- function(query, properties = NULL) {
	
	if(is.null(properties)) return(set_parameters(query, properties = NULL))
	
	endpoint <- extract_endpoint(query)
	choices <- c("tags", "metadata")
	if(grepl("contributions", endpoint)) choices <- c(choices, "contributionTypes")
	
	properties <- gsub(" ", "", unlist(strsplit(properties, ",")))
	properties <- match.arg(properties, choices = choices, several.ok = TRUE)
	properties <- paste(properties, collapse = ",")
	
	set_parameters(query, properties = properties)
}
