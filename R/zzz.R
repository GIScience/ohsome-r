# Upon attaching package, request ohsome API metadata and store in ohsome_metadata
.onAttach <- function(libname, pkgname) {

	# url <- "https://api.ohsome.org/v1"
	# assign("ohsome_api_url", url, envir = as.environment("package:ohsome"))

	meta <- ohsome_get_metadata(quiet = T)

	if(attributes(meta)$status_code == 200) {
		packageStartupMessage(paste(
			"Data:", meta$attribution$text, meta$attribution$url,
			"\nohsome API version", meta$apiVersion,
			"\nTemporal extent: ",
			meta$extractRegion$temporalExtent[1], "to",
			meta$extractRegion$temporalExtent[2]
		))
	} else {
		packageStartupMessage(paste(
			"Could not retrieve metadata from ohsome API.",
			"\nCheck your internet connection and run ohsome_get_metadata()"
		))
	}

}
