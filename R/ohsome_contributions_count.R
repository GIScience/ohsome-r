#' Count OSM contributions
#'
#' Create an \code{ohsome_query} object for OSM contributions count
#'
#' \code{ohsome_contributions_count} creates an \code{ohsome_query} object for
#' OSM element aggregation. Boundary objects are passed via \code{\link{set_boundary}} into
#' \code{\link{ohsome_boundary}}.
#'
#' @param boundary Boundary object that can be interpreted by
#'     \code{\link{ohsome_boundary}}
#' @param latest logical; if true, request the count of only the latest 
#' contributions provided to the OSM data.
#' @param return_value character; the value to be returned by the ohsome API:
#'  \describe{
#'         \item{absolute}{Returns the absolute number of contributions (default).}
#'         \item{density}{Returns the number of contributions per square kilometer.}
#' }
#' @param ... Parameters of the request to the ohsome API endpoint
#'
#' @return An \code{ohsome_query} object
#' @seealso \url{https://docs.ohsome.org/ohsome-api/stable/endpoints.html#users-aggregation}
#' @export
#' @examples
#'
#' ohsome_contributions_count("0,0,10", filter = "man_made=*", time = "2010/2020/P1Y")
#' ohsome_contributions_count("0,0,10", latest = TRUE, filter = "man_made=*", time = "2010/2020/P1Y")
#'
ohsome_contributions_count <- function(
	boundary = NULL,
	latest = FALSE,
	return_value = c("absolute", "density"),
	...
) {
	return_value <- match.arg(return_value)
	if(latest) latest <- "latest" else latest <- NULL
	if(return_value == "absolute") return_value <- NULL
	
	ohsome_query(c("contributions", latest, "count", return_value), boundary,...)
}