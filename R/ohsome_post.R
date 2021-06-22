#' Send POST request to ohsome API
#'
#' @param ohsome_query
#'
#' @return
#' @export
#'
#' @examples
ohsome_post <- function(ohsome_query, add_user_agent = "") {

	user_agent <- trimws(sprintf(
		"%s %s/%s",
		add_user_agent,	"ohsome-r",	packageVersion("ohsome")
	))

	resp <- httr::POST(
		url = ohsome_query$url,
		body = ohsome_query$body,
		encode = ohsome_query$encode,
		httr::user_agent(user_agent)
	)

	httr::stop_for_status(resp)
}
