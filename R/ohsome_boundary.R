#' Create \code{ohsome_boundary} object
#'
#' Creates an \code{ohsome_boundary} object from input geometries of various
#' classes. The \code{ohsome_boundary} object is used to set the \code{bpolys}, \code{bboxes} or
#' \code{bcircles} parameters of an \code{ohsome_query} object.
#'
#' @param x Bounding geometries that are passed to
#' \code{\link{ohsome_boundary}}. Bounding geometries should be in WGS84 in the format lon-lat. For \code{sf} objects the geometries are transformed to WGS84 if the CRS of the object is known. The following classes are supported:
#' \describe{
#'     \item{sf}{with (MULTI)POLYGON geometries}
#'     \item{sfc}{with (MULTI)POLYGON geometries}
#'     \item{sfg}{with (MULTI)POLYGON geometries and WGS 84 coordinates}
#'     \item{bbox}{created with \code{\link[sf]{st_bbox}}}
#'     \item{matrix}{created with
#'         \code{\link[sp]{bbox}} or
#'         \code{\link[osmdata]{getbb}}
#'     }
#'      \item{character}{a textual definition of bounding polygons, boxes or
#'     circles as allowed by the ohsome API (see
#'     \href{https://docs.ohsome.org/ohsome-api/stable/boundaries.html}{documentation})
#'     }
#'     \item{list}{a list of \code{bbox} objects, \code{matrix} or
#'         \code{character}. Bounding geometry types of all list elements must
#'         be the same. Does not work with GeoJSON FeatureCollections.
#'     }
#' }    
#'     
#' @param ... Additional arguments other than \code{digits} are ignored.
#' @param digits Number of decimal places of coordinates in the resulting
#'     GeoJSON when converting \code{sf} to GeoJSON (defaults to 6).
#' @return An \code{ohsome_boundary} object which contains the following elements: \code{boundary} which
#' contains the boundary in textual format and the \code{type} of the boundary (bpolys, bcircles, or bboxes).
#' @export
#' @examples
#' # define boundary by a circle (bcircle)
#' ohsome_boundary("8.6528,49.3683,1000") 
#' # define boundary by two circles (named Circle 1 and Circle 2)
#' ohsome_boundary("Circle 1:8.6528,49.3683,1000|Circle 2:8.7294,49.4376,1000")
#' # use the shape of franconia from the mapview package as bpolys
#' ohsome_boundary(mapview::franconia, digits = 4)
#' # get administrative boundary for Berlin from OSM and use as bpolys
#' ohsome_boundary(osmdata::getbb("Berlin"))
#' # use the bounding box from franconia
#' ohsome_boundary(sf::st_bbox(mapview::franconia))
#' # use a list with two bounding boxes
#' ohsome_boundary(list(osmdata::getbb("Berlin"), sf::st_bbox(mapview::franconia)))
ohsome_boundary <- function(x, ...) UseMethod("ohsome_boundary")

#' @name ohsome_boundary
#' @export
ohsome_boundary.ohsome_boundary <- function(x, ...) return(x)

#' @name ohsome_boundary
#' @export
ohsome_boundary.character <- function(x, ...) {

	if(jsonlite::validate(x) && length(x) == 1) {
			type <- "bpolys"
	} else {
		splt <- unlist(strsplit(x, split = "|", fixed = TRUE))
		len <- unique(sapply(strsplit(splt, split = ","), length))

		if(length(len) == 1 && len == 3) {
			type <- "bcircles"
		} else if(length(len) == 1 && len == 4) {
			type <- "bboxes"
		} else type <- "bpolys"
	}

	structure(list(
		boundary = paste(x, collapse = "|"), type = type),
		class = "ohsome_boundary"
	)
}

#' @name ohsome_boundary
#' @export
ohsome_boundary.sf <- function(x, digits = 6, ...) {

	if( (sf::st_crs(x)$input != "EPSG:4326") & !is.na(sf::st_crs(x)) )
	  x <- sf::st_transform(x, 4326)

	types <- sf::st_geometry_type(x)

	if(!any(types %in% c("POLYGON", "MULTIPOLYGON"))) {
		stop(
			"None of the geometries provided are of type (MULTI)POLYGON.",
			call. = FALSE
		)
	}

	if(!all(types %in% c("POLYGON", "MULTIPOLYGON"))) {
		warning(
			"At least one of the bounding geometries is not of type ",
			"(MULTI)POLYGON and was omitted.",
			call. = FALSE
		)
		x <- x[types %in% c("POLYGON", "MULTIPOLYGON"),]
	}

	geojson <- geojsonsf::sf_geojson(x, digits = digits, simplify = FALSE)
	type <- "bpolys"

	structure(list(boundary = geojson, type = type), class = "ohsome_boundary")
}

#' @name ohsome_boundary
#' @export
ohsome_boundary.sfc <- function(x, ...) ohsome_boundary(sf::st_as_sf(x), ...)

#' @name ohsome_boundary
#' @export
ohsome_boundary.sfg <- function(x, ...) ohsome_boundary(sf::st_sfc(x, crs = 4326), ...)

#' @name ohsome_boundary
#' @export
ohsome_boundary.bbox <- function(x, ...) {

	if( (attributes(x)$crs$input != "EPSG:4326") & (!is.na((attributes(x)$crs$input)) ) ) {
		x <- sf::st_bbox(sf::st_transform(sf::st_as_sfc(x), 4326))
	}

	ohsome_boundary(paste(x, collapse = ","))
}

#' @name ohsome_boundary
#' @export
ohsome_boundary.matrix <- function(x, ...) ohsome_boundary(paste(x, collapse = ","))

#' @name ohsome_boundary
#' @export
ohsome_boundary.list <- function(x, ...) {
	ohsome_boundary(paste(sapply(x, ohsome_boundary)[1,], collapse = "|"))
}
