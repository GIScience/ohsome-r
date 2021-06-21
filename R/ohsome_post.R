#' Send POST request to ohsome API
#'
#' @param ohsome_query
#'
#' @return
#' @export
#'
#' @examples
ohsome_post <- function(ohsome_query) {

	resp <- do.call(httr::POST, ohsome_query)
	httr::stop_for_status(resp)
}
