#' Extract OSM contributions
#'
#' Create an \code{ohsome_query} object for OSM contribution extraction
#'
#' \code{ohsome_extract_contributionss} creates an \code{ohsome_query} object 
#' for OSM contribution extraction. \code{ohsome_contributions_bbox},
#' \code{ohsome_contributions_centroid} and \code{ohsome_contributions_geometry} 
#' are wrapper functions for specific contributions extraction endpoints. 
#' Boundary objects are passed via \code{\link{set_boundary}} into 
#' \code{\link{ohsome_boundary}}.
#'
#' @param boundary Boundary object that can be interpreted by
#'     \code{\link{ohsome_boundary}}
#' @param geometryType Type of geometry to be extracted. Can be centroids 
#'     (\code{centroid}, bounding boxes (\code{bbox}) or \code{geometry}. 
#'     Default: \code{centroid}. Caveat: Node elements are omitted from results 
#'     in queries for bounding boxes. 
#' @param latest logical; if true, request only the latest state of the 
#' contributions provided to the OSM data.
#' @param time must consist of two ISO-8601 conform timestrings (as 
#'     comma-separated character or as character vector of length two) defining 
#'     a time interval (defaults to the temporal extent of the underlying OSHDB)
#' @param properties Can be "tags" to extract all tags and/or "metadata" to 
#'     provide metadata (\code{changesetId}, \code{lastEdit}, \code{osmType} and
#'     \code{version}) and/or "contributionTypes" to provide contribution types
#'     with the contributions. Multiple values can be provided as 
#'     comma-separated character or as character vector. 
#'     Default: NULL (provides \code{contributionChangesetId}, \code{osmId} and 
#'     \code{timestamp} with the contribution geometries)
#' @param clipGeometry logical; specifies whether the returned geometries of the 
#'     contributions should be clipped to the query’s spatial boundary
#' @param ... Parameters of the request to the ohsome API endpoint
#'
#' @family Extract contributions
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/stable/endpoints.html#contributions-extraction}
#' @export
#' @examples
#' 
#' # query to extract contributions to man-made features around "null island" with metadata:
#' ohsome_contributions_geometry("0,0,10", filter = "man_made=*", properties = "metadata")

ohsome_extract_contributions <- function(
	boundary = NULL,
	geometryType = c("centroid", "bbox", "geometry"),
	latest = FALSE, 
	time = lubridate::format_ISO8601(ohsome_temporalExtent),
	properties = NULL,
	clipGeometry = TRUE,
	...
) {
	geometryType <- match.arg(geometryType)
	if(latest) latest <- "latest" else latest <- NULL
	q <- ohsome_query(c("contributions", latest, geometryType), boundary, ...)
	q <- set_properties(q, properties)
	q <- set_parameters(q, clipGeometry = as.character(clipGeometry))
	q <- set_time(q, time)
	return(q)
}

#' @export
#' @rdname ohsome_extract_contributions
ohsome_contributions_bbox <- function(boundary = NULL, ...) {
	ohsome_extract_contributions(boundary, geometryType = "bbox", ...)
}

#' @export
#' @rdname ohsome_extract_contributions
ohsome_contributions_centroid <- function(boundary = NULL, ...) {
	ohsome_extract_contributions(boundary, geometryType = "centroid", ...)
}

#' @export
#' @rdname ohsome_extract_contributions
ohsome_contributions_geometry <- function(boundary = NULL, ...) {
	ohsome_extract_contributions(boundary, geometryType = "geometry", ...)
}
