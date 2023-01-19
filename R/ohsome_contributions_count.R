#' Count OSM contributions
#'
#' Creates an `ohsome_query` object for OSM contributions count
#'
#' `ohsome_contributions_count()` creates an `ohsome_query` object for
#' OSM element aggregation. Boundary objects are passed via [set_boundary()] 
#' into [ohsome_boundary()].
#'
#' @inherit ohsome_query params return
#' @param latest logical; if `TRUE`, request only the latest contributions 
#'   provided to each OSM element.
#' @param return_value character; the value to be returned by the ohsome API:
#'   * `"absolute"` returns the absolute number of contributions. This is the
#'    default.
#'   * `"density"` returns the number of contributions per square kilometer.
#' @param time character; `time` parameter of the query (see 
#'   [Supported time formats](https://docs.ohsome.org/ohsome-api/v1/time.html)). 
#'   This defaults to the temporal extent of the underlying OSHDB.
#' @inherit ohsome_query return
#' @seealso [ohsome API Endpoints - Contributions Aggregation](https://docs.ohsome.org/ohsome-api/v1/endpoints.html#contributions-aggregation)
#' @export
#' @examples
#' # Monthly counts of contributions to man-made objects around "Null Island"
#' ohsome_contributions_count("0,0,10", filter = "man_made=*", time = "2010/2020/P1Y")
#' 
#' # Monthly counts of latest contributions to man-made objects around "Null Island"
#' ohsome_contributions_count(
#'     "0,0,10", 
#'     latest = TRUE, 
#'     filter = "man_made=*", 
#'     time = "2010/2020/P1Y"
#' )
#'
ohsome_contributions_count <- function(
	boundary = NULL,
	latest = FALSE,
	return_value = c("absolute", "density"),
	time = ohsome_temporalExtent,
	...
) {
	return_value <- match.arg(return_value)
	if(latest) latest <- "latest" else latest <- NULL
	if(return_value == "absolute") return_value <- NULL
	
	q <- ohsome_query(c("contributions", latest, "count", return_value), boundary,...)
	set_time(q, time)
}