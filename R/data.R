#' @docType data
#' @name ohsome_api_url
#' @title ohsome API URL
#' @description The base URL of the ohsome API with path to current major
#' version.
#' @format A list:
#'   * `base`: character; base URL
#'   * `version`: character; path to current major API version
NULL

#' @docType data
#' @name ohsome_endpoints
#' @title ohsome API endpoints
#' @description Available ohsome API endpoints with their parameters
#' @format A list of ohsome API endpoints.
NULL

#' @docType data
#' @name ohsome_metadata
#' @title ohsome API metadata
#' @description Metadata of the ohsome API that is requested on loading the 
#'     package
#' @format An `ohsome_metadata` object. This is a named list with the 
#'   attributes `date`, `status_code` (of the GET request) and the following list 
#'   elements:
#'   * `attribution`: characer; `url` and `text` of OSM data copyrights and 
#'   attribution 
#'   * `apiVersion`: numeric_version; Version of the ohsome API
#'   * `timeout`: numeric; limit of the processing time in seconds
#'   * `extractRegion`:
#'     * `spatialExtent`: sfc_POLYGON; spatial boundary of the OSM data in the 
#'     underlying OSHDB
#'     * `temporalExtent`: vector of POSIXct; timeframe of the OSM data in the
#'     underlying OSHDB data 
#'     * `replicationSequenceNumber`: numeric; precise state of the OSM data
#'     contained in the underlying OSHDB, expressed as the id of the last 
#'     applied (hourly) diff file from [Planet OSM](planet.openstreetmap.org)
NULL

#' @docType data
#' @name ohsome_temporalExtent
#' @title ohsome API temporal extent 
#' @description Temporal extent of the OSM data in the underlying OSHDB
#' @format A vector of POSIXct
NULL
