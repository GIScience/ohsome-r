#' GET metadata from ohsome API
#'
#' Return parsed metadata from ohsome API
#'
#' \code{ohsome_get_metadata} sends a GET request to the metadata endpoint of
#' ohsome API and parses the response. The parsed metadata is silently returned.
#'
#' @param quiet logical; suppress message on data attribution, API version and
#'     temporal extent.
#'
#' @return An \code{ohsome_metadata} object. This is a named list with the
#'     attributes \code{date} and \code{status_code} (of the GET request) and
#'     the following list elements:
#'     \describe{
#'         \item{attribution}{\code{url} and \code{text} of OSM data copyrights
#'             and attribution (character)}
#'         \item{apiVersion}{Version of the ohsome API
#'             (numeric_version)}
#'         \item{timeout}{Limit of the processing time in seconds (numeric)}
#'         \item{extractRegion}{
#'             \code{spatialExtent}: {Spatial boundary of the OSM data in the
#'                 underlying OSHDB (sfc_POLYGON)}\cr
#'             \code{temporalExtent}: {Timeframe of the OSM data in the
#'                 underlying OSHDB data (vector of POSIXct)}\cr
#'             \code{replicationSequenceNumber}: {Precise state of the OSM data
#'                 contained in the underlying OSHDB, expressed as the id of the
#'                 last applied (hourly) diff file from
#'                 \url{planet.openstreetmap.org} (numeric)}
#'     }}
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/endpoints.html#metadata}
#' @export
#' @examples
#' \dontrun{
#' ohsome_get_metadata()
#' }
ohsome_get_metadata <- function(quiet = FALSE) {

	response <- httr::GET(
		url = build_endpoint_url("metadata"),
		httr::user_agent(paste("ohsome-r", utils::packageVersion("ohsome"), sep = "/"))
	)

	httr::stop_for_status(response)

	parsed <- ohsome_parse(response, return_class = "list")

	ohsome_metadata <- structure(
		.Data = convert_metadata(parsed),
		status_code = httr::status_code(response),
		date = lubridate::dmy_hms(httr::headers(response)$date),
		class = "ohsome_metadata"
	)

	if(!quiet) message(create_metadata_message(ohsome_metadata))
	invisible(ohsome_metadata)
}
