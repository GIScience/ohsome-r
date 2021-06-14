# Upon attaching package, request ohsome API metadata and store in ohsome_metadata
.onAttach <- function(libname, pkgname) {

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
