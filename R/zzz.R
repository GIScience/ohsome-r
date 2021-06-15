# Upon attaching package, request ohsome API metadata and store in ohsome_metadata
.onAttach <- function(libname, pkgname) {

	url <- "https://api.ohsome.org/v1"
	assign("ohsome_api_url", url, envir = as.environment("package:ohsome"))

	meta <- ohsome_get_metadata()


	if(exists("meta")) {
		packageStartupMessage(paste(
			"Data:", meta$attribution$text, meta$attribution$url,
			"\nohsome API version", meta$apiVersion,
			"\nTemporal extent: ",
			meta$extractRegion$temporalExtent$fromTimestamp, "to",
			meta$extractRegion$temporalExtent$toTimestamp
		))
	} else {
		packageStartupMessage(
			"Could not retrieve metadata from ohsome API."
		)
	}

}
