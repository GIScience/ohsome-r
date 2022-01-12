#' Set endpoint
#'
#' Modify the endpoint of an existing \code{ohsome_query} object
#'
#' \code{set_endpoint()} takes an \code{ohsome_query} object and modifies the
#' ohsome API endpoint. \code{set_grouping()} takes an \code{ohsome_query} 
#' object and modifies the endpoint path for grouped aggregations.
#'
#' @param query An \code{ohsome_query} object
#' @param endpoint The path to the ohsome API endpoint. Either a single string
#'     (e.g. \code{"elements/count"}) or a character vector in the right order
#'     (e.g. \code{c("elements", "count")})
#' @param append logical; If true, the provided endpoint string is appended to  the
#'     existing endpoint definition instead of replacing it. This is
#'     particularly useful if you wish to add a groupBy to an existing
#'     aggregation query.
#' @param reset_format logical; if true, the format parameter of the query is updated
#'     depending on the new endpoint.
#' @param grouping character; group type(s) for grouped aggregations (only 
#' available for queries to aggregation endpoints). In general, the following
#' group types are available:
#' \describe{
#'         \item{boundary}{Groups the result by the given boundaries that are defined through any of the boundary query parameters}
#'         \item{key}{Groups the result by the given keys that are defined through the groupByKeys query parameter.}
#'         \item{tag}{Groups the result by the given tags that are defined through the groupByKey and groupByValues query parameters.}
#'         \item{type}{Groups the result by the given OSM, or simple feature types that are defined through the types parameter.}
#'         \item{c("boundary", "tag")}{Groups the result by the given boundary and the tags.}
#' }
#' Not all of these group types are accepted by all of the aggregation 
#' endpoints. Please consult the 
#' [ohsome API documentation](https://docs.ohsome.org/ohsome-api/v1/group-by.html) 
#' to check for available group types.
#' @family Set endpoint
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/}
#' @export
#' @examples
#' q <- ohsome_elements_count(mapview::franconia, filter = "highway=*")
#'
#' set_endpoint(q, "elements/length")
#' 
#' set_endpoint(q, "groupBy/boundary", append = TRUE)
#' set_grouping(q, grouping = "boundary")
#' 
#' set_endpoint(q, c("density", "groupBy", "boundary"), append = TRUE)
set_endpoint <- function(query,	endpoint, append = FALSE, reset_format = TRUE) {

	if(append) {
		old <- gsub("^.*?/", "", httr::parse_url(query$url)$path)
		endpoint <- paste(old, paste(endpoint, collapse = "/"), sep = "/")
	}

	body <- query$body
	if(reset_format) body$format <- NULL

	return(do.call(ohsome_query, c(endpoint, body)))
}

#' @export
#' @rdname set_endpoint
set_grouping <- function(query, grouping, ...) {
	
	if(missing(grouping)) return(query)
	
	old <- gsub("^.*?/", "", httr::parse_url(query$url)$path)
	split <- unlist(strsplit(old, "/groupBy/"))
	if(!is.null(grouping)) {
		grouping <- paste("groupBy", tolower(grouping), sep = "/", collapse = "/")
	}
	endpoint <- paste(split[1], grouping, sep = "/")
	
	set_endpoint(query, endpoint, ...)
}
