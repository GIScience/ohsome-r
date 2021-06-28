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
#' object is returned.
#'
#' @param query An \code{ohsome_query} object
#' @param ... named parameters (e.g. \code{time = "2020-01-01"})
#' @family Set parameters
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/}
#' @export
#' @examples
set_parameters <- function(query, ...) {

	endpoint <- gsub("^.*?/", "", httr::parse_url(query$url)$path)
	body <- query$body

	params <- list(...)

	for(i in 1:length(params)) body[[names(params[i])]] <- params[[i]]

	return(do.call(ohsome_query, c(endpoint, body)))
}

#' @export
#' @rdname set_parameters
set_time <- function(query, time = NULL) {
	set_parameters(query, time = time %||% query$body$time)
}

#' @export
#' @rdname set_parameters
set_filter <- function(query, filter = NULL, filter2 = NULL) {
	set_parameters(
		query,
		filter = filter %||% query$body$filter,
		filter2 = filter2 %||% query$body$filter2
	)
}

#' @export
#' @rdname set_parameters
set_groupByKeys <- function(query, groupByKeys = NULL) {
	set_parameters(query, groupByKeys = groupByKeys %||% query$body$groupByKeys)
}

#' @export
#' @rdname set_parameters
set_groupByKey <- function(query, groupByKey = NULL) {
	set_parameters(query, groupByKey = groupByKey %||% query$body$groupByKey)
}

#' @export
#' @rdname set_parameters
set_groupByValues <- function(query, groupByValues = NULL) {
	set_parameters(query, groupByValues = groupByValues %||% query$body$groupByValues)
}

#' @export
#' @rdname set_parameters
set_properties <- function(query, properties = NULL) {
	set_parameters(query, properties = properties %||% query$body$properties)
}
