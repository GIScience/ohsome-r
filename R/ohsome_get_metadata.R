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

	if(httr::http_type(r) != "application/json") {
		stop("ohsome API did not return JSON.", call. = FALSE)
	}

	parsed <- parse_content(r)

	if(httr::http_error(r)) {
		stop(
			sprintf(
				"ohsome API request failed [%s]\n%s",
				httr::status_code(r),
				parsed$error
			),
			call. = FALSE
		)
	}

	meta <- convert_metadata(parsed)

	ohsome_metadata <- structure(
		.Data = meta,
		status_code = httr::status_code(r),
		date = lubridate::dmy_hms(httr::headers(r)$date),
		class = "ohsome_metadata"
	)

	if(!quiet) message(create_metadata_message(ohsome_metadata))

	assign(".ohsome_metadata", ohsome_metadata, pos = "package:ohsome")
	invisible(ohsome_metadata)
}
