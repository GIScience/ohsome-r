#' Create an `ohsome_boundary` object
#'
#' Creates an `ohsome_boundary` object from various classes of input geometries. 
#' The `ohsome_boundary` object is used to set the `bpolys`, `bboxes` or
#' `bcircles` parameter of an `ohsome_query` object.
#'
#' @param boundary Bounding geometries specified by WGS84 coordinates in the 
#'   order `lon,lat`. The geometries of `sf` are transformed to WGS84 if the CRS 
#'   of the object is known. The following classes are supported:
#'   * `sf` with (MULTI)POLYGON geometries
#'   * `sfc` with (MULTI)POLYGON geometries
#'   * `sfg` with (MULTI)POLYGON geometries and WGS 84 coordinates
#'   * `bbox` created with [sf::st_bbox()] or [tmaptools::bb()]
#'   * `matrix` created with [sp::bbox()] or [osmdata::getbb()]
#'   * `character` providing textual definitions of bounding polygons, boxes or 
#'   circles as allowed by the ohsome API (see 
#'   [ohsome API - Boundaries](https://docs.ohsome.org/ohsome-api/stable/boundaries.html)
#'   ):
#'     * bboxes: WGS84 coordinates in the following format: 
#'     `"id1:lon1,lat1,lon2,lat2|id2:lon1,lat1,lon2,lat2|..."` OR 
#'     `"lon1,lat1,lon2,lat2|lon1,lat1,lon2,lat2|..."`
#'     * bcircles: WGS84 coordinates + radius in meter in the following 
#'     format: `"id1:lon,lat,r|id2:lon,lat,r|..."` OR 
#'     `"lon,lat,r|lon,lat,r|..."`
#'     * bpolys: WGS84 coordinates given as a list of coordinate pairs (as for 
#'     bboxes) or GeoJSON FeatureCollection. The first point has to be the same 
#'     as the last point and MultiPolygons are only supported in GeoJSON.
#'   * `list` of `bbox`, `matrix` or `character`. Bounding geometry types of all 
#'   list elements must be the same. Does not work with GeoJSON 
#'   FeatureCollections.
#' @param ... Additional arguments other than `digits` are ignored.
#' @param digits integer; number of decimal places of coordinates in the 
#'   resulting GeoJSON when converting `sf` to GeoJSON (defaults to 6).
#' @return An `ohsome_boundary` object which contains the following elements: 
#'   * `boundary`: the boundary in textual format
#'   * `type` of the boundary (`bpolys`, `bcircles`, or `bboxes`).
#' @export
#' @examples
#' # Defintion of a bounding circle (lon,lat,radius in meters)
#' ohsome_boundary("8.6528,49.3683,1000") 
#' 
#' # Definition of two named bounding circles
#' ohsome_boundary("Circle 1:8.6528,49.3683,1000|Circle 2:8.7294,49.4376,1000")
#' 
#' # Definition of two named bounding circles with a character vector
#' ohsome_boundary(c("Circle 1:8.6528,49.3683,1000", "Circle 2:8.7294,49.4376,1000"))
#' 
#' # Use franconia from the mapview package as bounding polygons
#' \donttest{
#' ohsome_boundary(mapview::franconia, digits = 4)
#' }
#'  
#' # Use the bounding box of franconia
#' \donttest{
#' ohsome_boundary(sf::st_bbox(mapview::franconia))
#' }
#' 
#' # Get bounding box of the city of Berlin from OSM
#' \dontrun{
#' ohsome_boundary(osmdata::getbb("Berlin"))
#' }
#'  
#' # Use a list of two bounding boxes
#' \dontrun{
#' ohsome_boundary(list(osmdata::getbb("Berlin"), sf::st_bbox(mapview::franconia)))
#' }
#' 
ohsome_boundary <- function(boundary, ...) UseMethod("ohsome_boundary")

#' @name ohsome_boundary
#' @export
ohsome_boundary.ohsome_boundary <- function(boundary, ...) return(boundary)

#' @name ohsome_boundary
#' @export
ohsome_boundary.character <- function(boundary, ...) {

	if(jsonlite::validate(boundary) && length(boundary) == 1) {
			type <- "bpolys"
	} else {
		splt <- unlist(strsplit(boundary, split = "|", fixed = TRUE))
		len <- unique(sapply(strsplit(splt, split = ","), length))

		if(length(len) == 1 && len == 3) {
			type <- "bcircles"
		} else if(length(len) == 1 && len == 4) {
			type <- "bboxes"
		} else type <- "bpolys"
	}

	structure(list(
		boundary = paste(boundary, collapse = "|"), type = type),
		class = "ohsome_boundary"
	)
}

#' @name ohsome_boundary
#' @export
ohsome_boundary.sf <- function(boundary, digits = 6, ...) {

	if( (sf::st_crs(boundary)$input != "EPSG:4326") & !is.na(sf::st_crs(boundary)) )
	  boundary <- sf::st_transform(boundary, 4326)

	types <- sf::st_geometry_type(boundary)

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
		boundary <- boundary[types %in% c("POLYGON", "MULTIPOLYGON"),]
	}

	geojson <- geojsonsf::sf_geojson(boundary, digits = digits, simplify = FALSE)
	type <- "bpolys"

	structure(list(boundary = geojson, type = type), class = "ohsome_boundary")
}

#' @name ohsome_boundary
#' @export
ohsome_boundary.sfc <- function(boundary, ...) ohsome_boundary(sf::st_as_sf(boundary), ...)

#' @name ohsome_boundary
#' @export
ohsome_boundary.sfg <- function(boundary, ...) ohsome_boundary(sf::st_sfc(boundary, crs = 4326), ...)

#' @name ohsome_boundary
#' @export
ohsome_boundary.bbox <- function(boundary, ...) {

	if( (attributes(boundary)$crs$input != "EPSG:4326") & (!is.na((attributes(boundary)$crs$input)) ) ) {
		boundary <- sf::st_bbox(sf::st_transform(sf::st_as_sfc(boundary), 4326))
	}

	ohsome_boundary(paste(boundary, collapse = ","))
}

#' @name ohsome_boundary
#' @export
ohsome_boundary.matrix <- function(boundary, ...) ohsome_boundary(paste(boundary, collapse = ","))

#' @name ohsome_boundary
#' @export
ohsome_boundary.list <- function(boundary, ...) {
	ohsome_boundary(paste(sapply(boundary, ohsome_boundary)[1,], collapse = "|"))
}
