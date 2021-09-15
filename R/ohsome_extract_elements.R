#' Extract OSM elements
#'
#' Create an \code{ohsome_query} object for OSM element extraction
#'
#' \code{ohsome_extract_elements} creates an \code{ohsome_query} object for
#' OSM element extraction. \code{ohsome_elements_bbox},
#' \code{ohsome_elements_centroid} and \code{ohsome_elements_geometry} are 
#' wrapper functions for specific elements extraction endpoints. Boundary 
#' objects are passed via \code{\link{set_boundary}} into 
#' \code{\link{ohsome_boundary}}.
#'
#' @param boundary Boundary object that can be interpreted by
#'     \code{\link{ohsome_boundary}}
#' @param geometryType Type of geometry to be extracted. Can be centroids 
#'     (\code{centroid}, bounding boxes (\code{bbox}) or \code{geometry}. 
#'     Default: \code{centroid}. Caveat: Node elements are omitted from results 
#'     in queries for bounding boxes. 
#' @param properties Can be "tags" to extract all tags with the elements and/or
#'     "metadata" to provide metadata (\code{changesetId}, \code{lastEdit}, 
#'     \code{osmType} and \code{version}) with the elements. Multiple values 
#'     can be provided as comma-separated character or as character vector. 
#'     Default: NULL (only provides \code{osmId} with the elements)
#' @param clipGeometry logical Specifies whether the returned geometries of the 
#'     features should be clipped to the query’s spatial boundary
#' @param ... Parameters of the request to the ohsome API endpoint
#'
#' @family Extract elements
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/stable/endpoints.html#elements-extraction}
#' @export
#' @examples
#' 
#' # query to extract geometries, metadata and tags of all elements around "null island":
#' ohsome_elements_geometry("0,0,10", properties = c("metadata", "tags"))

ohsome_extract_elements <- function(
	boundary = NULL,
	geometryType = c("centroid", "bbox", "geometry"),
	properties = NULL,
	clipGeometry = TRUE,
	...
) {
	geometryType <- match.arg(geometryType)
	q <- ohsome_query(c("elements", geometryType), boundary, ...)
	q <- set_properties(q, properties)
	q <- set_parameters(q, clipGeometry = as.character(clipGeometry))
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
