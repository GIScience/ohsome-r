#' Extract OSM contributions
#'
#' Creates an `ohsome_query` object for OSM contribution extraction
#'
#' `ohsome_extract_contributions()` creates an `ohsome_query` object for OSM
#' contribution extraction. `ohsome_contributions_bbox()`,
#' `ohsome_contributions_centroid()` and `ohsome_contributions_geometry()`
#' are wrapper functions for specific contributions extraction endpoints.
#' Boundary objects are passed via [set_boundary()] into [ohsome_boundary()].
#'
#' @inherit ohsome_query params return
#' @inheritParams ohsome_contributions_count
#' @inheritParams ohsome_extract_elements
#' @param properties character; properties to be extracted with the 
#'   contributions:
#'   * `"tags"`, and/or 
#'   * `"metadata"` (i.e. `@changesetId`, `@lastEdit`, `@osmType`, 
#'   `@version`), and/or 
#'   * `"contributionTypes"` (i.e. `@creation`, `@tagChange`, `@deletion`, and 
#'   `@geometryChange`)
#'   
#'   Multiple values can be provided as comma-separated character or as 
#'   character vector. This defaults to `NULL` (provides 
#'   `@contributionChangesetId`, `@osmId` and `@timestamp`).
#' @family Extract contributions
#' @seealso [ohsome API Endpoints -- Contributions Extraction](https://docs.ohsome.org/ohsome-api/stable/endpoints.html#contributions-extraction)
#' @export
#' @examples
#' # Extract contributions to man-made objects around "Null Island" with metadata:
#' ohsome_contributions_geometry(
#'     "0,0,10", 
#'     filter = "man_made=*", 
#'     time = c("2021-01-01", "2022-01-01"),
#'     properties = "metadata"
#' )
#' 
ohsome_extract_contributions <- function(
	boundary = NULL,
	geometryType = c("centroid", "bbox", "geometry"),
	latest = FALSE, 
	time = ohsome_temporalExtent,
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
