#' Extract OSM elements' full history
#'
#' Create an \code{ohsome_query} object for the extraction of OSM elements' full
#' history
#'
#' \code{ohsome_extract_elementsFullHistory} creates an \code{ohsome_query} 
#' object for OSM element full history extraction. 
#' \code{ohsome_elementsFullHistory_bbox}, 
#' \code{ohsome_elementsFullHistory_centroid} and 
#' \code{ohsome_elementsFullHistory_geometry} are wrapper functions for specific
#' elementsFullHistory extraction endpoints. Boundary objects are passed via 
#' \code{\link{set_boundary}} into \code{\link{ohsome_boundary}}.
#'
#' @param boundary Boundary object that can be interpreted by
#'     \code{\link{ohsome_boundary}}
#' @param geometryType Type of geometry to be extracted. Can be centroids 
#'     (\code{centroid}, bounding boxes (\code{bbox}) or \code{geometry}. 
#'     Default: \code{centroid}. Caveat: Node elements are omitted from results 
#'     in queries for bounding boxes. 
#' @param time must consist of two ISO-8601 conform timestrings (as 
#'     comma-separated character or as character vector of length two) defining 
#'     a time interval (defaults to the temporal extent of the underlying OSHDB)
#' @param properties Can be "tags" to extract all tags with the elements and/or
#'     "metadata" to provide metadata (\code{changesetId}, \code{lastEdit}, 
#'     \code{osmType} and \code{version}) with the elements. Multiple values 
#'     can be provided as comma-separated character or as character vector. 
#'     Default: NULL (only provides \code{osmId} with the elements)
#' @param clipGeometry logical; specifies whether the returned geometries of the 
#'     features should be clipped to the query’s spatial boundary
#' @param ... Parameters of the request to the ohsome API endpoint
#'
#' @family Extract elements full History
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/v1/endpoints.html#elements-full-history-extraction}
#' @export
#' @examples
#' 
#' # query to extract full history of building geometries around Heidelberg 
#' # main station:
#' ohsome_elementsFullHistory_geometry(
#'     boundary = "8.67542,49.40347,1000", 
#'     filter = "building=* and type:way", 
#'     clipGeometry = FALSE
#' )

ohsome_extract_elementsFullHistory <- function(
	boundary = NULL,
	geometryType = c("centroid", "bbox", "geometry"),
	time = lubridate::format_ISO8601(ohsome_temporalExtent),
	properties = NULL,
	clipGeometry = TRUE,
	...
) {
	geometryType <- match.arg(geometryType)
	q <- ohsome_query(c("elementsFullHistory", geometryType), boundary, ...)
	q <- set_properties(q, properties)
	q <- set_parameters(q, clipGeometry = as.character(clipGeometry))
	q <- set_time(q, time)
	return(q)
}

#' @export
#' @rdname ohsome_extract_elementsFullHistory
ohsome_elementsFullHistory_bbox <- function(boundary = NULL, ...) {
	ohsome_extract_elementsFullHistory(boundary, geometryType = "bbox", ...)
}

#' @export
#' @rdname ohsome_extract_elementsFullHistory
ohsome_elementsFullHistory_centroid <- function(boundary = NULL, ...) {
	ohsome_extract_elementsFullHistory(boundary, geometryType = "centroid", ...)
}

#' @export
#' @rdname ohsome_extract_elementsFullHistory
ohsome_elementsFullHistory_geometry <- function(boundary = NULL, ...) {
	ohsome_extract_elementsFullHistory(boundary, geometryType = "geometry", ...)
}