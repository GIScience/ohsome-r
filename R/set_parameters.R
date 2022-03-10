#' Set parameters
#'
#' Sets or modifies parameters of an existing `ohsome_query` object
#'
#' `set_parameters()` takes an `ohsome_query` object and an arbitrary number of 
#' named parameters as an input. It sets or modifies these parameters in the 
#' `ohsome_query` and returns the modified object. `set_time()`, `set_filter()`,
#' `set_groupByKeys()`, `set_groupByKey()`, `set_groupByValues()` and 
#' `set_properties()` are wrapper functions to set specific parameters. By 
#' default, an unmodified `ohsome_query` object is returned. In order to remove 
#' a parameter from the query object, you can set the respective argument 
#' explicitly to `NULL` (e.g. `set_filter(query, filter = NULL)`).
#'
#' @inherit ohsome_query params return
#' @inheritParams ohsome_post
#' @param time character; `time` parameter of the query (see 
#'   [Supported time formats](https://docs.ohsome.org/ohsome-api/v1/time.html)). 
#' @param filter character; `filter` parameter of the query (see
#'   [Filter](https://docs.ohsome.org/ohsome-api/v1/filter.html))
#' @param filter2 character; `filter2` parameter of a ratio query
#' @param groupByKeys character; `groupByKeys` parameter of a `groupBy/key` query
#' @param groupByKey character; `groupByKey` parameter of a `groupBy/tag` query
#' @param groupByValues character; `groupByValues` parameter of a `groupBy/tag` 
#'   query
#' @param properties character; properties to be extracted with extraction 
#'   queries:
#'   * `"tags"`, and/or 
#'   * `"metadata"` (i.e. `@changesetId`, `@lastEdit`, `@osmType`, 
#'   `@version`), and/or 
#'   * `"contributionTypes"` (i.e. `@creation`, `@tagChange`, `@deletion`, and 
#'   `@geometryChange`; only for contributions extraction)
#'   
#'   Multiple values can be provided as comma-separated character or as 
#'   character vector. This defaults to `NULL` (removes `properties` parameter
#'   from the query body).
#' @family Set parameters
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/}
#' @export
#' @examples
#' # Query ratio grouped by boundary
#' q1 <- ohsome_query(
#'      endpoint = "elements/count/ratio/groupBy/boundary",
#'      boundary = "HD:8.5992,49.3567,8.7499,49.4371|HN:9.1638,49.113,9.2672,49.1766"
#' )
#'
#' # Add time, filter and format parameters
#' q1 |>
#'     set_time("2021/2022/P3M") |>
#'     set_filter("building=*", filter2 = "building=* and building:levels=3") |>
#'     set_parameters(format = "csv")
#'
#' # Query elements area grouped by tag
#' q2 <- ohsome_query(
#'     endpoint = "elements/area/groupBy/tag",
#'     boundary = "HD:8.5992,49.3567,8.7499,49.4371"
#' )
#' 
#' # Add time, filter and groupByKey parameters
#' q2 |>
#'     set_time("2021/2022/P3M") |>
#'     set_filter("building=*") |>
#'     set_groupByKey("building:levels")
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
