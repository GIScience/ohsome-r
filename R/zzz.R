# Upon attaching package, request ohsome API metadata and assign to ohsome_metadata
.onLoad <- function(libname, pkgname) {
	tryCatch({
		ohsome_metadata <- ohsome_get_metadata(quiet = TRUE)
		assign(
			".ohsome_metadata", 
			ohsome_metadata, 
			envir = parent.env(environment())
		)
		assign(
			".ohsome_temporalExtent", 
			ohsome_metadata$extractRegion$temporalExtent,
			envir = parent.env(environment())
		)
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

.onAttach <- function(libname, pkgname) {
	if(exists(".ohsome_metadata", where = "package:ohsome")) {
		packageStartupMessage(create_metadata_message(.ohsome_metadata))
	}
}
