#' Create an ohsome query object
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
ohsome_query <- function(endpoint = NULL, ...) {

	body <- list(time = time, ...)

	structure(
		list(
			url = build_endpoint_url(endpoint),
			encode = "form",
			body = body,
			httr::user_agent("ohsome-r")
		),
		class = "ohsome_query"
	)

}
