#' Count OSM users
#'
#' Create an `ohsome_query` object for OSM users count
#'
#' `ohsome_users_count()` creates an `ohsome_query` object for OSM users 
#' aggregation. Boundary objects are passed via [set_boundary()] into 
#' [ohsome_boundary()].
#' 
#' @inherit ohsome_query params return
#' @inheritParams ohsome_contributions_count
#' @param return_value character; the value to be returned by the ohsome API:
#'   * `"absolute"` returns the absolute number of users. This is the
#'    default.
#'   * `"density"` returns the number of users per square kilometer.
#' @seealso [ohsome API Endpoints -- Users Aggregation](https://docs.ohsome.org/ohsome-api/stable/endpoints.html#users-aggregation)
#' @export
#' @examples
#' # Yearly count of users contributing to man-made objects around "Null Island"
#' ohsome_users_count("0,0,10", filter = "man_made=*", time = "2012/2022/P1Y")
#'
ohsome_users_count <- function(
	boundary = NULL,
	return_value = c("absolute", "density"),
	grouping = NULL,
	time = ohsome_temporalExtent,
	...
) {
	return_value <- match.arg(return_value)
	if(return_value == "absolute") return_value <- NULL
	
	q <- ohsome_query(c("users", "count", return_value), boundary, grouping,...)
	set_time(q, time)
}
