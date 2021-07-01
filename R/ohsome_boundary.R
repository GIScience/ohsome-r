#' Create \code{ohsome_boundary} object
#'
#' Creates an \code{ohsome_boundary} object from input geometries of various
#' classes. The \code{ohsome_boundary} object is used by
#' \code{\link{ohsome_boundary}} to set the \code{bpolys}, \code{bboxes} or
#' \code{bcircles} parameters of an \code{ohsome_query} object.
#'
#' @param boundary Bounding geometries that are passed to
#'     \code{\link{ohsome_boundary}}. Bounding geometries can be of class:
#'     \describe{
#'     \item{sf}{with (MULTI)POLYGON geometries}
#'     \item{sfc}{with (MULTI)POLYGON geometries}
#'     \item{sfg}{with (MULTI)POLYGON geometries and WGS 84 coordinates}
#'     \item{bbox}{created with \code{\link[sf]{st_bbox}}}
#'     \item{matrix}{created with
#'         \code{\link[sp]{bbox}},
#'         \code{\link[terra]{bbox}}, or
#'         \code{\link[osmdata]{getbb}}
#'         }
#'     \item{character}{a textual definition of bounding polygons, boxes or
#'     circles as allowed by the ohsome API (see
#'     \href{https://docs.ohsome.org/ohsome-api/stable/boundaries.html}{documentation})}
#'     }
#' @param ... Additional arguments passed to \code{\link[geojsonsf]{sf_geojson}}
#'     for boundaries of class \code{sf}. \code{digits} defines the number of
#'     decimal places of coordinates in the resulting GeoJSON (defaults to 6).
#'     Other arguments are ignored.
#'
#' @return an \code{ohsome_boundary} object
#' @export
#' @examples
#' ohsome_boundary("Circle 1:8.6528,49.3683,1000|Circle 2:8.7294,49.4376,1000")
#' ohsome_boundary(mapview::franconia, digits = 4)
#' ohsome_boundary(osmdata::getbb("Berlin"))
#' ohsome_boundary(sf::st_bbox(mapview::franconia))
ohsome_boundary <- function(x, ...) UseMethod("ohsome_boundary")

#' @name ohsome_boundary
#' @export
ohsome_boundary.ohsome_boundary <- function(x) return(x)

#' @name ohsome_boundary
#' @export
ohsome_boundary.character <- function(x) {

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

	if(sf::st_crs(x)$input != "EPSG:4326") x <- st_transform(x, 4326)

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
ohsome_boundary.sfc <- function(x, ...) ohsome_boundary(st_as_sf(x), ...)

#' @name ohsome_boundary
#' @export
ohsome_boundary.sfg <- function(x, ...) ohsome_boundary(st_sfc(x, crs = 4326), ...)

#' @name ohsome_boundary
#' @export
ohsome_boundary.bbox <- function(x, ...) {

	if(attributes(x)$crs$input != "EPSG:4326") {
		x <- st_bbox(st_transform(st_as_sfc(x), 4326))
	}

	ohsome_boundary(paste(x, collapse = ","))
}

#' @name ohsome_boundary
#' @export
ohsome_boundary.matrix <- function(x, ...) ohsome_boundary(paste(x, collapse = ","))
