#' Set endpoint
#'
#' Modify the endpoint of an existing \code{ohsome_query} object
#'
#' \code{set_endpoint()} takes an \code{ohsome_query} object and modifies the
#' ohsome API endpoint.
#'
#' @param query An \code{ohsome_query} object
#' @param endpoint The path to the ohsome API endpoint. Either a single string
#' (e.g. \code{"elements/count"}) or a character vector in the right order
#' (e.g. \code{c("elements", "count")})
#' @param append If true, the provided endpoint string is appended to  the
#' existing endpoint definition instead of replacing it. This is particularly
#' useful if you wish to add a groupBy to an existing aggregation query.
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/}
#' @export
#' @examples
set_endpoint <- function(query, endpoint, append = FALSE) {

	if(append) {
		old <- gsub("^.*?/", "", httr::parse_url(query$url)$path)
		endpoint <- paste(old, paste(endpoint, collapse = "/"), sep = "/")
	}

	body <- query$body

	return(do.call(ohsome_query, c(endpoint, body)))
}
