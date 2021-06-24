require(usethis)

ohsome_api_url <- list(
	base = "https://api.ohsome.org",
	version = "v1"
)

usethis::use_data(ohsome_api_url, overwrite = TRUE)
