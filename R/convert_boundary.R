#' Convert boundary
#'
#' @param boundary
#' @param boundary_type
#' @return
convert_boundary <- function(boundary, boundary_type) {

	switch(
		boundary_type,
		bpolys = convert_bpolys(boundary),
		bboxes = convert_bboxes(boundary),
		bcircles = convert_bcircles(boundary),
		stop("Unknown boundary type.")
	)

}

#' Convert bounding polygons
#'
#' @param bpolys
#' @return
convert_bpolys <- function(bpolys) {

	if("character" %in% class(bpolys)) {

		return(bpolys)

	} else if("sf" %in% class(bpolys)) {

		if(!all(sf::st_geometry_type(bpolys) %in% c("POLYGON", "MULTIPOLYGON"))) {
			warning(
				"At least one of the bounding geometries is not of type ",
				"(MULTI)POLYGON."
			)
		}

		return(geojsonsf::sf_geojson(bpolys))

	} else {

		stop("Bounding polygons need to be character or sf objects.")
	}
}

#' Convert bounding boxes
#'
#' @param bboxes
#' @return
convert_bboxes <- function(bboxes) {

	if("character" %in% class(bboxes)) {

		return(bboxes)

	} else if("bbox" %in% class(bboxes)) {

		return(paste(bboxes, collapse = ","))

	} else {

		stop("Bounding boxes need to be character or bbox objects.")
	}
}

#' Convert bounding circles
#'
#' @param bcircles
#' @return
convert_bcircles <- function(bcircles) {

	if("character" %in% class(bcircles)) {

		return(bcircles)

	} else if("sf" %in% class(bcircles)) {

		if(any(sf::st_geometry_type(bcircles) != "POINT")) {
			stop("At least one of the geometries is not of type POINT.")
		}

		if(!any(names(bcircles) == "radius")) {
			stop("Column radius is missing in bcircles sf object.")
		}

		coords <- sf::st_coordinates(bcircles)
		circles <- paste(coords[,1], coords[,2], test$radius, sep = ",")

		if(any(names(bcircles) == "id")) {
			return(paste(bcircles$id, circles, sep = ":", collapse = "|"))
		} else {
			return(paste(circles, collapse = "|"))
		}


	} else {

		stop("Bounding circles need to be character or sf objects.")
	}
}
