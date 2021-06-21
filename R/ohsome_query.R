#' Create an ohsome_query object
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
ohsome_query <- function(endpoint, ...) {

	format <- ifelse(any(grepl("(centroid|bbox|geometry)", endpoint)), "json", "csv")
	body <- list(..., format = format)

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
