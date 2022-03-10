#' Send POST request to ohsome API
#'
#' Sends an `ohsome_query` object as a POST request to the ohsome API and 
#' returns the response.
#'
#' @param query An `ohsome_query` object constructed with [ohsome_query()] or 
#'   any of its wrapper functions
#' @param parse logical; if `TRUE`, parse the ohsome API response with 
#'   [ohsome_parse()]
#' @param validate logical; if `TRUE`, issues warning for invalid endpoint or
#'   invalid/missing query parameters.
#' @param strict logical; If `TRUE`, throws error on invalid query. Overrules 
#'   validate argument `TRUE`.
#' @param additional_identifiers vector coercible to character; optional user 
#'   agent identifiers in addition to `"ohsome-r/{version}"`.
#' @param ... Additional arguments passed to [ohsome_parse()]:
#'   * `returnclass`: class of the returned object
#'   * `omit_empty`: logical; omit features with empty geometries (only if 
#'   `returnclass = "sf"`)
#' @return An `ohsome_response` object if `parse = FALSE`, else an `sf` object, 
#'   a `data.frame`, a `list` or a `character`
#' @seealso [ohsome API documentation](https://docs.ohsome.org/ohsome-api/v1/)
#' @export
#' @examples
#' \dontrun{
#' # Get bounding box of the city of Berlin
#' bbberlin <- osmdata::getbb("Berlin")
#' 
#' # Query for cinema geometries within bounding box
#' q <- ohsome_elements_geometry(bbberlin, filter = "amenity=cinema")
#' 
#' # Send query to ohsome API and return sf by default
#' ohsome_post(q)
#' 
#' # Send query to ohsome API and return data.frame
#' ohsome_post(q, returnclass = "data.frame")
#' 
#' # Send query and return unparsed response
#' ohsome_post(q, parse = FALSE)
#' 
#' # Send query with strict validation (will fail due to missing time parameter)
#' ohsome_post(q, strict = TRUE)
#' }
#' 
ohsome_post <- function(
	query,
	parse = TRUE,
	validate = TRUE,
	strict = validate,
	additional_identifiers = NULL,
	...
) {
	if(validate || strict) valid <- validate_query(query)
	stopifnot("Query invalid. See warnings for details." = !strict || valid)

	if(is.null(additional_identifiers)) additional_identifiers <- ""
	user_agent <- trimws(sprintf(
		"%s %s/%s",
		paste(as.character(additional_identifiers), collapse = " "),
		"ohsome-r", utils::packageVersion("ohsome")
	))

	response <- httr::POST(
		url = query$url,
		body = query$body,
		encode = query$encode,
		httr::user_agent(user_agent)
	)

	attr(response, "request_body") <- query$body
	attr(response, "class") <- c("ohsome_response", "response")

	httr::stop_for_status(response)

	if(parse) { return(ohsome_parse(response, ...)) } else { return(response) }
}
