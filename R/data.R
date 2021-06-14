#' @docType data
#' @name ohsome_metadata
#' @title ohsome API metadata
#' @description Metadata of the underlying OSHDB data
#' @details This is a list of metadata requested from the ohsome API via
#' \url{https://api.ohsome.org/v1/metadata} at the moment of attaching the ohsome
#' package. It contains information such as the current API version, the
#' maximum timeout, and the spatial and temporal extent of currently available
#' data. Metadata can be refreshed with \code{\link{ohsome_get_metadata}}.
#' @format A list of the following structure:
#' \describe{
#' \item{attribution}{\code{url} and \code{text} of OSM data attribution}
#' \item{apiVersion}{Current version number of ohsome API}
#' \item{timeout}{Maximum timeout for ohsome API requests}
#' \item{extractRegion}{
#'     \code{spatialExtent}: {\code{type} and \code{coordinates}}\cr
#'     \code{temporalExtent}: {\code{fromTimestamp} and \code{toTimestamp}}\cr
#'     \code{replicationSequenceNumber}
#' }}
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/endpoints.html#metadata}
NULL
