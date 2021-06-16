#' GET metadata from ohsome API
#'
#' Return parsed metadata from ohsome API
#'
#' \code{ohsome_get_metadata} sends a GET request to the metadata endpoint of
#' ohsome API and parses the response. The parsed metadata is silently returned.
#' As a side effect, it is also assigned to \code{\link{.ohsome_metadata}}.
#'
#' @param quiet logical; suppress message on data attribution, API version and
#'     temporal extent.
#'
#' @return An \code{ohsome_metadata} object. This is a named list with the
#'     attributes \code{date} and \code{status_code} (of the GET request) and
#'     the following list elements:
#'     \describe{
#'         \item{attribution}{\code{url} and \code{text} of OSM data attribution
#'             (character)}
#'         \item{apiVersion}{Current version number of ohsome API
#'             (numeric_version)}
#'         \item{timeout}{Maximum timeout for ohsome API requests in seconds
#'             (numeric)}
#'         \item{extractRegion}{
#'             \code{spatialExtent}: {spatial extent of available data
#'                 (sfc_POLYGON)}\cr
#'             \code{temporalExtent}: {temporal extent of available data
#'                 (vector of POSIXct)}\cr
#'             \code{replicationSequenceNumber}
#'     }}
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/endpoints.html#metadata}
#' @export
#' @examples
#' \dontrun{
#' ohsome_get_metadata()
#' }
ohsome_get_metadata <- function(quiet = F) {

	r <- httr::GET(paste(ohsome::ohsome_api_url, "metadata", sep = "/"))

	# TODO add error handling for no connection and status code != 200

	meta <- structure(
		convert_content(httr::content(r, as = "parsed", encoding = "utf-8")),
		status_code = httr::status_code(r),
		date = lubridate::dmy_hms(httr::headers(r)$date),
		class = c("ohsome_metadata")
	)

	if(!quiet) message(paste(
		"Data:", meta$attribution$text, meta$attribution$url,
		"\nohsome API version", meta$apiVersion,
		"\nTemporal extent: ",
		meta$extractRegion$temporalExtent[1], "to",
		meta$extractRegion$temporalExtent[2]
	))

	assign(".ohsome_metadata", meta, pos = "package:ohsome")
	invisible(meta)
}
