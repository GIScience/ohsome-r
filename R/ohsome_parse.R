#' Parse content from an ohsome API response
#'
#' Extract and parse the content from an ohsome API response
#'
#' \code{ohsome_parse()} parses an \code{ohsome_response} object into
#' an object of the specified class. By default, this is an \code{sf} object if
#' the ohsome API response contains GeoJSON data or a \code{data.frame} if it
#' does not. \code{ohsome_sf()}  and \code{ohsome_df()} are wrapper functions.
#'
#' @param response A response object
#' @param returnclass One of the following:
#'     \describe{
#'         \item{default}{returns \code{sf} if ohsome API response is GeoJSON,
#'             else a \code{data.frame}}
#'         \item{sf}{returns \code{sf} if ohsome API response is GeoJSON,
#'             else issues a warning and returns a \code{data.frame}}
#'         \item{data.frame}{returns a \code{data.frame}}
#'         \item{list}{returns a \code{list}}
#'         \item{character}{returns the ohsome API response as text (JSON or
#'             semicolon-separated values)}
#'     }
#' @param omit_empty logical omit features with empty geometries 
#'     (only if returnclass="sf")
#' @family Extract and parse the content from an ohsome API response
#' @return A list (if the response is of type "application/json"), an sf
#'     object (if the response is of type "application/geo+json") or a
#'     data.frame (if the response is of type "text/csv")
#' @export
#' @examples
#' r <- ohsome_query("elements/centroid", filter = "amenity=*", properties = "tags") |>
#'     set_boundary(osmdata::getbb("Heidelberg")) |>
#'     ohsome_post(parse = FALSE)
#'
#' ohsome_parse(r)
#' ohsome_df(r)
#' ohsome_sf(r)
ohsome_parse <- function(
	response,
	returnclass = c("default", "sf", "data.frame", "list", "character"),
	omit_empty = TRUE
) {

	returnclass <- match.arg(returnclass)

	type <- httr::http_type(response)
	content <- httr::content(response, as = "text", encoding = "utf-8")

	if(returnclass == "character") {

		return(content)

	} else if(
		type == "application/json" &&
		grepl('\"type\" : \"FeatureCollection\"', content) ||
		type == "application/geo+json"

	) {
		content <- jsonlite::minify(content)
		pattern <- '\"(Multi)?(Point|LineString|Polygon)\",\"coordinates\":\\[+\\]+'
		loc <- gregexpr(pattern = pattern, text = content)
		empty <- sapply(loc, function(x) length(attr(x, "match.length")))


		if(empty > 0) {
			content <- gsub(pattern, '"Point","coordinates":[360, 360]', content)
		}
		
		p <- geojsonsf::geojson_sf(content)
		
		if(empty > 0) {
			i <- suppressWarnings(suppressMessages(
				sf::st_intersects(
					p,
					sf::st_point(rep(360, 2)),
					sparse = FALSE
			)))
			p[i, "geometry"] <- NULL
		}

		if(returnclass == "data.frame") {
			return(convert_quietly(sf::st_drop_geometry(p)))
		} else if(returnclass == "list") {
			return(as.list(sf::st_sf(convert_quietly(as.data.frame(p)))))
		} else {
			
			if(omit_empty) {
				p <- subset(p, !sf::st_is_empty(p))
				warning(
					paste(empty, "elements with empty geometries omitted."),
					call. = FALSE
				)
			}
			
			return(sf::st_sf(convert_quietly(as.data.frame(p))))
		}

	} else if(type == "application/json") {

		p <- jsonlite::fromJSON(content, simplifyVector = TRUE)

		if(returnclass == "list") {
			return(p)
		} else {
			if(returnclass == "sf") {
				warning(
					"No geodata in ohsome API response. Returning data.frame ",
					"instead of sf."
				)
			}

			return(convert_quietly(as.data.frame(p)))
		}

	} else if(type == "text/csv") {

		p <- utils::read.csv2(
			textConnection(content),
			comment.char = "#",
			header = TRUE,
			stringsAsFactors = FALSE
		)

		if(returnclass == "list") {
			return(as.list(convert_quietly(p)))
		} else {
			if(returnclass == "sf") {
				warning(
					"No geodata in ohsome API response. Returning data.frame ",
					"instead of sf."
				)
			}

			return(convert_quietly(p))
		}
	} else {
		stop("ohsome API response content is neither of type (Geo)JSON nor CSV.")
	}
}

#' @export
#' @rdname ohsome_parse
ohsome_sf <- function(response, omit_empty = TRUE) {
	ohsome_parse(response, returnclass = "sf", omit_empty = omit_empty)
}

#' @export
#' @rdname ohsome_parse
ohsome_df <- function(response, omit_empty = TRUE) {
	ohsome_parse(response, returnclass = "data.frame", omit_empty = omit_empty)
}
