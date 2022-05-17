#' Parse content from an ohsome API response
#'
#' Extracts and parses the content from an ohsome API response
#'
#' `ohsome_parse()` parses an `ohsome_response` object into an object of the 
#' specified class. By default, this is an `sf` object if the ohsome API 
#' response contains GeoJSON data or else a `data.frame`. `ohsome_sf()` and 
#' `ohsome_df()` wrapper functions for specific return classes.
#'
#' @param response An `ohsome_response` object
#' @param returnclass character; one of the following:
#'   * `"default"` returns `sf` if the `ohsome_response` contains GeoJSON, or 
#'   else a `data.frame`.
#'   * `"sf"` returns `sf` if the `ohsome_response` contains GeoJSON, else 
#'   issues a warning and returns a `data.frame`.
#'   * `"data.frame"` returns a `data.frame`.
#'   * `"list"` returns a `list`.
#'   * `"character"` returns the ohsome API response body as text (JSON or
#'   semicolon-separated values)
#' @param omit_empty logical; omit features with empty geometries (only if 
#'   `returnclass = "sf"`)
#' @family Extract and parse the content from an ohsome API response
#' @return An `sf` object, a `data.frame`, a `list` or a `character`
#' @export
#' @examples
#' \dontrun{
#' # Create and send a query to ohsome API
#' r <- ohsome_query("elements/centroid", filter = "amenity=*") |>
#'     set_boundary(osmdata::getbb("Heidelberg")) |>
#'     set_time("2021") |>
#'     set_properties("metadata") |>
#'     ohsome_post(parse = FALSE)
#'
#' # Parse response to object of default class (here: sf)
#' ohsome_parse(r)
#' 
#' # Parse response to data.frame
#' ohsome_df(r)
#' 
#' # Parse response to sf
#' ohsome_sf(r)
#' }
#' 
ohsome_parse <- function(
	response,
	returnclass = c("default", "sf", "data.frame", "list", "character"),
	omit_empty = TRUE
) {

	returnclass <- match.arg(returnclass)

	type <- httr::http_type(response)
	content <- httr::content(response, as = "text", encoding = "utf-8")
	
	if(grepl('\"status\" : 413', content)) {
		stop(
			"A broken response has been received. ",
			"The given query is too large in respect to the given timeout. ", 
			"Please use a smaller region and/or coarser time period.",
			call. = FALSE
		)
	} 

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
		empty_coords <- sapply(loc, function(x) {
			match.length <- attr(x, "match.length") 
			length(match.length[match.length > 0])
		})


		if(empty_coords > 0) {
			content <- gsub(pattern, '"Point","coordinates":[360, 360]', content)
		}
		
		p <- geojsonsf::geojson_sf(content)
		
		if(empty_coords > 0) {
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
			
			empty <- sf::st_is_empty(p)
			if(omit_empty & sum(empty) > 0) {
				p <- subset(p, !sf::st_is_empty(p))
				warning(
					paste(sum(empty), "element(s) with empty geometries omitted."),
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
