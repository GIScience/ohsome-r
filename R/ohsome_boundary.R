#' Create \code{ohsome_boundary} object
#'
#' @param boundary
#'
#' @return
#' @export
#'
#' @examples
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
			"(MULTI)POLYGON and was ommitted.",
			call. = FALSE
		)
	}

	geojson <- geojsonsf::sf_geojson(x, digits = digits, simplify = FALSE)
	type <- "bpolys"

	structure(list(boundary = geojson, type = type), class = "ohsome_boundary")
}

#' @name ohsome_boundary
#' @export
ohsome_boundary.bbox <- function(x, digits = 6, ...) {

	sf <- sf::st_as_sf(sf::st_as_sfc(x))
	if(attributes(x)$crs$input != "EPSG:4326") sf <- st_transform(sf, 4326)

	geojson <- geojsonsf::sf_geojson(sf, digits = digits, simplify = FALSE)
	type <- "bpolys"

	structure(list(boundary = geojson, type = type), class = "ohsome_boundary")
}
