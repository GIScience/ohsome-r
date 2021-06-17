# Upon attaching package, request ohsome API metadata and assign to .ohsome_metadata
.onAttach <- function(libname, pkgname) {
	tryCatch({
		ohsome_metadata <- ohsome_get_metadata(quiet = TRUE)
		packageStartupMessage(create_metadata_message(ohsome_metadata))
		},
		error = function(e) {
			warning(
				"Could not retrieve metadata from ohsome API.",
				"\nPlease check your internet connection and try to run ",
				"ohsome_get_metadata()",
				call. = FALSE
			)
		}
	)
}
