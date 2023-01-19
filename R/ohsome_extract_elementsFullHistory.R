#' Extract OSM elements' full history
#'
#' Creates an `ohsome_query` object for the extraction of OSM elements' full
#' history
#'
#' `ohsome_extract_elementsFullHistory()` creates an `ohsome_query` object for OSM 
#' element full history extraction. `ohsome_elementsFullHistory_bbox()`, 
#' `ohsome_elementsFullHistory_centroid()` and 
#' `ohsome_elementsFullHistory_geometry()` are wrapper functions for specific 
#' elementsFullHistory extraction endpoints. Boundary objects are passed via 
#' [set_boundary()] into [ohsome_boundary()].
#'
#' @inherit ohsome_query params return
#' @inheritParams ohsome_contributions_count
#' @inheritParams ohsome_extract_elements
#' @family Extract elements full History
#' @seealso [ohsome API Endpoints -- Elements Full History Extraction](https://docs.ohsome.org/ohsome-api/v1/endpoints.html#elements-full-history-extraction)
#' @export
#' @examples
#' 
#' # Extract full history of building geometries around Heidelberg main station:
#' ohsome_elementsFullHistory_geometry(
#'     boundary = "8.67542,49.40347,1000",
#'     time = "2012,2022", 
#'     filter = "building=* and geometry:polygon",
#'     clipGeometry = FALSE
#' )

ohsome_extract_elementsFullHistory <- function(
	boundary = NULL,
	geometryType = c("centroid", "bbox", "geometry"),
	time = NULL,
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