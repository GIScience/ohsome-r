library(httr)
library(rapiclient)
library(data.table)

extract_endpoint <- function(endpoint, paths) {

	params <- rbindlist(paths[[endpoint]]$post$parameters, fill = TRUE)
	deprecated <- grepl("deprecated", params$description)

	invisible(list(
		summary = paths[[endpoint]]$post$summary,
		produces = paths[[endpoint]]$post$produces,
		parameters = as.data.frame(
			params[!deprecated, c("name", "description", "required")]
		)
	))
}

extract_spec <- function(spec) {
	api <- "https://api.ohsome.org/stable/docs" |>
		modify_url(query = spec) |>
		get_api()

	paths <- api$paths
	endpoints <- names(paths)

	out <- lapply(endpoints, extract_endpoint, paths = paths)
	names(out) <- sub("^/", "", endpoints)
	invisible(out)
}

specs <- c("group=Data%20Aggregation", "group=Data%20Extraction")
ohsome_endpoints <- unlist(lapply(specs, extract_spec), recursive = FALSE)

usethis::use_data(ohsome_endpoints, overwrite = TRUE)
