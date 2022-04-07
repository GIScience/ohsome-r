#' Extract OSM elements
#'
#' Create an `ohsome_query` object for OSM element extraction
#'
#' `ohsome_extract_elements()` creates an `ohsome_query` object for OSM element 
#' extraction. `ohsome_elements_bbox()`, `ohsome_elements_centroid()` and 
#' `ohsome_elements_geometry()` are wrapper functions for specific elements 
#' extraction endpoints. Boundary objects are passed via [set_boundary()] into 
#' [ohsome_boundary()].
#'
#' @inherit ohsome_query params return
#' @inheritParams ohsome_aggregate_elements
#' @param geometryType character; type of geometry to be extracted: 
#'   * `"centroid"`,
#'   * `"bboxes"` (bounding boxes), or
#'   * `"geometry"`
#'   
#'   Caveat: Node elements are omitted from results in queries for bounding 
#'   boxes. 
#' @param properties character; properties to be extracted with the features:
#'   * `"tags"`, and/or 
#'   * `"metadata"` (i.e. `@changesetId`, `@lastEdit`, `@osmType`, and
#'   `@version`)
#'   
#'   Multiple values can be provided as comma-separated character or as 
#'   character vector. This defaults to `NULL` (provides `@osmId`).
#' @param clipGeometry logical; specifies whether the returned geometries should 
#'   be clipped to the query’s spatial boundary
#' @family Extract elements
#' @seealso [ohsome API Endpoints -- Elements Extraction](https://docs.ohsome.org/ohsome-api/stable/endpoints.html#elements-extraction)
#' @export
#' @examples
#' # Extract geometries, metadata and tags of man-made objects around "Null Island":
#' ohsome_elements_geometry(
#'     "0,0,10", 
#'     filter = "man_made=*", 
#'     time = "2022-01-01",
#'     properties = c("metadata", "tags")
#' )
#' 
ohsome_extract_elements <- function(
	boundary = NULL,
	geometryType = c("centroid", "bbox", "geometry"),
	time = lubridate::format_ISO8601(ohsome_temporalExtent[2]),
	properties = NULL,
	clipGeometry = TRUE,
	...
) {
	geometryType <- match.arg(geometryType)
	q <- ohsome_query(c("elements", geometryType), boundary, ...)
	q <- set_properties(q, properties)
	q <- set_parameters(q, clipGeometry = as.character(clipGeometry))
	q <- set_time(q, time)
	return(q)
}

#' @export
#' @rdname ohsome_extract_elements
ohsome_elements_bbox <- function(boundary = NULL, ...) {
	ohsome_extract_elements(boundary, geometryType = "bbox", ...)
}

#' @export
#' @rdname ohsome_extract_elements
ohsome_elements_centroid <- function(boundary = NULL, ...) {
	ohsome_extract_elements(boundary, geometryType = "centroid", ...)
}

#' @export
#' @rdname ohsome_extract_elements
ohsome_elements_geometry <- function(boundary = NULL, ...) {
	ohsome_extract_elements(boundary, geometryType = "geometry", ...)
}
