#' Count OSM users
#'
#' Create an \code{ohsome_query} object for OSM users count
#'
#' \code{ohsome_count_users} creates an \code{ohsome_query} object for
#' OSM element aggregation. Boundary objects are passed via \code{\link{set_boundary}} into
#' \code{\link{ohsome_boundary}}.
#'
#' @param boundary Boundary object that can be interpreted by
#'     \code{\link{ohsome_boundary}}
#' @param return_value character; the value to be returned by the ohsome API:
#'  \describe{
#'         \item{absolute}{Returns the absolute number of users (default).}
#'         \item{density}{Returns the number of users per square kilometer.}
#' }
#' @param grouping character; group type(s) for grouped user aggregation. The 
#' following group types are available:
#' \describe{
#'         \item{boundary}{Groups the result by the given boundaries that are defined through any of the boundary query parameters}
#'         \item{key}{Groups the result by the given keys that are defined through the groupByKeys query parameter.}
#'         \item{tag}{Groups the result by the given tags that are defined through the groupByKey and groupByValues query parameters.}
#'         \item{type}{Groups the result by the given OSM, or simple feature types that are defined through the types parameter.}
#' }
#' Not all of these group types are accepted by all of the user aggregation 
#' endpoints. Please consult the 
#' [ohsome API documentation](https://docs.ohsome.org/ohsome-api/v1/group-by.html) 
#' to check for available group types.
#' @param ... Parameters of the request to the ohsome API endpoint
#'
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/stable/endpoints.html#users-aggregation}
#' @export
#' @examples
#'
#' ohsome_users_count("0,0,10", filter = "man_made=*", time = "2010/2020/P1Y")
#'
ohsome_users_count <- function(
	boundary = NULL,
	return_value = c("absolute", "density"),
	grouping = NULL,
	...
) {
	return_value <- match.arg(return_value)
	if(return_value == "absolute") return_value <- NULL
	
	ohsome_query(c("users", "count", return_value), boundary, grouping,...)
}
