#' GET metadata from ohsome API
#'
#' Sends a GET request to the metadata endpoint of ohsome API, parses the
#' response and assigns it to ohsome_metadata
#'
#' @return a list of metadata (see \code{\link{ohsome_metadata}})
#' @export
#' @examples
#' \dontrun{
#' ohsome_get_metadata()
#' }
ohsome_get_metadata <- function() {
	r <- httr::GET("https://api.ohsome.org/v1/metadata")

	# TODO add error handling for no connection and status code != 200

	meta <- httr::content(r, as = "parsed", encoding = "utf-8")
	assign("ohsome_metadata", meta, envir = as.environment("package:ohsome"))

	return(meta)
}
