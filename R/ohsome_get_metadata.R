#' GET metadata from ohsome API
#'
#' \code{ohsome_get_metadata} returns the parsed metadata of ohsome API
#'
#' \code{ohsome_get_metadata} sends a GET request to the metadata endpoint of
#' ohsome API and parses the response. The parsed metadata is returned as well
#' assigned to \code{\link{ohsome_metadata}} as a side effect.
#'
#' @return a list of metadata (see \code{\link{ohsome_metadata}})
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/endpoints.html#metadata}
#' @export
#' @examples
#' \dontrun{
#' ohsome_get_metadata()
#' }
ohsome_get_metadata <- function() {

	r <- httr::GET(paste(ohsome::ohsome_api_url, "metadata", sep = "/"))

	# TODO add error handling for no connection and status code != 200

	meta <- httr::content(r, as = "parsed", encoding = "utf-8")

	# convert spatialExtent to sf polygon?
	# convert temporalExtent to POSIXct vector?

	assign("ohsome_metadata", meta, envir = as.environment("package:ohsome"))

	return(meta)
}
