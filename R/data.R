#' @docType data
#' @name ohsome_api_url
#' @title ohsome API URL
#' @description The base URL of the ohsome API with path to current major
#' version.
#' @format A list:
#' \describe{
#'     \item{base}{base URL (character)}
#'     \item{version}{path to current major API version (character)}
#' }
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
#' @format An \code{ohsome_metadata} object. This is a named list with the 
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
NULL

#' @docType data
#' @name ohsome_temporalExtent
#' @title ohsome API temporal extent 
#' @description Temporal extent of the OSM data in the underlying OSHDB
#' @format A vector of POSIXct
NULL
