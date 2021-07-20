#' Send POST request to ohsome API
#'
#' Sends an ohsome_query object as a POST request to the ohsome API and silently
#' returns the unparsed response.
#'
#' @param query an ohsome_query object constructed with \code{\link{ohsome_query}}
#'     or any of its wrapper functions
#' @param parse logical parse the ohsome API response?
#' @param validate logical If true, issues warning for invalid endpoint or
#'      invalid/missing query parameters
#' @param additional_identifiers optional user agent identifiers in addition to
#'     "ohsome-r/version" (a vector coercible to character)
#' @param ... additional arguments passed to \code{\link{ohsome_parse}} \describe{
#'     \item{returnclass}{class of the returned object}
#'     \item{omit_empty}{logical omit features with empty geometries 
#'         (only if returnclass="sf")}
#' }
#'
#' @return \describe{
#'    \item{an \code{sf} object}{if parse = TRUE and ohsome API response is GeoJSON}
#'    \item{a \code{data.frame}}{if parse = TRUE and ohsome API response is not GeoJSON}
#'    \item{an \code{ohsome_response} object}{if parse = FALSE}
#' }
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/}
#' @export
#' @examples
#' q <- ohsome_elements_count(osmdata::getbb("Berlin"), filter = "amenity=cinema")
#'
#' ohsome_post(q)
ohsome_post <- function(
	query,
	parse = TRUE,
	validate = TRUE,
	additional_identifiers = NULL,
	...
) {

	if(validate) validate_query(query)

	if(is.null(additional_identifiers)) additional_identifiers <- ""
	user_agent <- trimws(sprintf(
		"%s %s/%s",
		paste(as.character(additional_identifiers), collapse = " "),
		"ohsome-r", utils::packageVersion("ohsome")
	))

	response <- httr::POST(
		url = query$url,
		body = query$body,
		encode = query$encode,
		httr::user_agent(user_agent)
	)

	attr(response, "request_body") <- query$body
	attr(response, "class") <- c("ohsome_response", "response")

	httr::stop_for_status(response)

	if(parse) { return(ohsome_parse(response, ...)) } else { return(response) }
}
