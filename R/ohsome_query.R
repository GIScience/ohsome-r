#' Create an ohsome_query object
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
ohsome_query <- function(endpoint, ...) {

	body <- list(...)
	if(!any(grepl("(centroid|bbox|geometry)", endpoint))) {
		body <- c(body, format = "csv")
	}

	structure(
		list(
			url = build_endpoint_url(endpoint),
			encode = "form",
			body = body,
			httr::user_agent(paste("ohsome-r", packageVersion("ohsome"), sep = "/"))
		),
		class = "ohsome_query"
	)
}
