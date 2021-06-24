#' Send POST request to ohsome API
#'
#' Sends an ohsome_query object as a POST request to the ohsome API and silently
#' returns the unparsed response.
#'
#' @param ohsome_query an ohsome_query object constructed with ohsome_query()
#'     or any of its wrapper functions
#' @param parse logical parse the ohsome API response?
#' @param additional_identifiers optional user agent identifiers in addition to
#'     "ohsome-r/version" (a vector coercible to character)
#'
#' @return \describe{
#'    \item{an sf object}{if parse = TRUE and ohsome API response is GeoJSON}
#'    \item{a data.frame}{if parse = TRUE and ohsome API response is not GeoJSON}
#'    \item{an ohsome_response object}{if parse = FALSE}
#' }
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/}
#' @export
#' @examples
ohsome_post <- function(ohsome_query, parse = TRUE, additional_identifiers = NULL) {

	if(is.null(additional_identifiers)) additional_identifiers <- ""

	user_agent <- trimws(sprintf(
		"%s %s/%s",
		paste(as.character(additional_identifiers), collapse = " "),
		"ohsome-r", packageVersion("ohsome")
	))

	response <- httr::POST(
		url = ohsome_query$url,
		body = ohsome_query$body,
		encode = ohsome_query$encode,
		httr::user_agent(user_agent)
	)

	attr(response, "request_body") <- ohsome_query$body
	attr(response, "class") <- c("ohsome_response", "response")

	httr::stop_for_status(response)

	if(parse) { return(ohsome_parse(response)) } else { return(response) }
}
