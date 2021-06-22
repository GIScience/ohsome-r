#' Send POST request to ohsome API
#'
#' @param ohsome_query an ohsome_query object constructed with ohsome_query()
#'     or any of its wrapper functions
#' @param additional_identifiers optional user agent identifiers in addition to
#'     "ohsome-r/version" (a vector coercible to character)
#'
#' @return an ohsome API response
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/}
#' @export
#'
#' @examples
ohsome_post <- function(ohsome_query, additional_identifiers = NULL) {

	if(is.null(additional_identifiers)) additional_identifiers <- ""

	user_agent <- trimws(sprintf(
		"%s %s/%s",
		paste(as.character(additional_identifiers), collapse = " "),
		"ohsome-r", packageVersion("ohsome")
	))

	resp <- httr::POST(
		url = ohsome_query$url,
		body = ohsome_query$body,
		encode = ohsome_query$encode,
		httr::user_agent(user_agent)
	)

	httr::stop_for_status(resp)
}
