#' GET metadata from ohsome API
#'
#' Returns parsed metadata from ohsome API
#'
#' `ohsome_get_metadata()` sends a GET request to the metadata endpoint of
#' ohsome API and parses the response. The parsed metadata is silently returned.
#'
#' @param quiet logical; suppresses message on data attribution, API version and
#'   temporal extent.
#' @return An `ohsome_metadata` object. This is a named list with the 
#'   attributes `date`, `status_code` (of the GET request) and the following list 
#'   elements:
#'   * `attribution`: character; `url` and `text` of OSM data copyrights and 
#'   attribution 
#'   * `apiVersion`: character; Version of the ohsome API
#'   * `timeout`: numeric; limit of the processing time in seconds
#'   * `extractRegion`:
#'     * `spatialExtent`: sfc_POLYGON; spatial boundary of the OSM data in the 
#'     underlying OSHDB
#'     * `temporalExtent`: vector of ISO 8601 character; start and end of the temporal extent of OSM data in the
#'     underlying OSHDB
#'     * `replicationSequenceNumber`: numeric; precise state of the OSM data
#'     contained in the underlying OSHDB, expressed as the id of the last 
#'     applied (hourly) diff file from [Planet OSM](https://planet.openstreetmap.org)
#' @seealso [ohsome API Endpoints -- Metadata](https://docs.ohsome.org/ohsome-api/v1/endpoints.html#metadata)
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

	parsed <- ohsome_parse(response, returnclass = "list")
	spatialExtent <- parsed$extractRegion$spatialExtent
	parsed$extractRegion$spatialExtent <- convert_spatialExtent(spatialExtent)

	ohsome_metadata <- structure(
		.Data = parsed,
		status_code = httr::status_code(response),
		date = httr::headers(response)$date,
		class = "ohsome_metadata"
	)

	if(!quiet) message(create_metadata_message(ohsome_metadata))
	invisible(ohsome_metadata)
}
