#' Set endpoint
#'
#' Modify the endpoint of an existing \code{ohsome_query} object
#'
#' \code{set_endpoint()} takes an \code{ohsome_query} object and modifies the
#' ohsome API endpoint.
#'
#' @param query An \code{ohsome_query} object
#' @param endpoint The path to the ohsome API endpoint. Either a single string
#'     (e.g. \code{"elements/count"}) or a character vector in the right order
#'     (e.g. \code{c("elements", "count")})
#' @param append If true, the provided endpoint string is appended to  the
#'     existing endpoint definition instead of replacing it. This is
#'     particularly useful if you wish to add a groupBy to an existing
#'     aggregation query.
#' @param reset_format If true, the format parameter of the query is updated
#'     depending on the new endpoint.
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/}
#' @export
#' @examples
#' q <- ohsome_elements_count(mapview::franconia, filter = "highway=*")
#'
#' set_endpoint(q, "elements/length")
#' set_endpoint(q, "groupBy/boundary", append = TRUE)
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
