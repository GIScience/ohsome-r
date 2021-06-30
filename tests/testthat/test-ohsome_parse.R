# original query:
# q <- ohsome_query(
# 	c("elements", "count"),
# 	filter = "shop=convenience",
# 	bcircles = "13.45,52.5,1000",
# 	format = "csv"
# )
# r <- ohsome_post(q, parse = FALSE, validate = FALSE)

r <- readRDS(here::here("tests/testthat/data/elements-count-shop-convenience-bcircles-csv.rds"))

test_that(
	'returns data.frame by default when content CSV', {
		expect_s3_class(ohsome_parse(r), "data.frame")
})

test_that(
	'converts timestamp to POSIXct in data.frame', {
		p <- ohsome_parse(r)
		expect_s3_class(p$timestamp, "POSIXct")
})

test_that(
	'issues warning and returns data.frame if return_class = "sf" and content not GeoJSON', {
		expect_warning(ohsome_parse(r, return_class = "sf"))
		expect_s3_class(suppressWarnings(ohsome_parse(r, return_class = "sf")), "data.frame")
})

test_that(
	'returns list if return_class = "list"', {
		expect_type(ohsome_parse(r, return_class = "list"), "list")
})

test_that(
	'returns character if return_class = "character"', {
		expect_type(ohsome_parse(r, return_class = "character"), "character")
})



# original query:
# q <- ohsome_query(
# 	c("elements", "centroid"),
# 	filter = "shop=convenience",
# 	bcircles = "13.45,52.5,1000"
# )
# r <- ohsome_post(q, parse = FALSE, validate = FALSE)

r <- readRDS(here::here("tests/testthat/data/elements-centroid-shop-convenience-bcircles.rds"))

test_that(
	'returns sf by default when content GeoJSON', {
		expect_s3_class(ohsome_parse(r, return_class = "sf"), "sf")
})

test_that(
	'converts @snapshotTimestamp to POSIXct in sf objects', {
		p <- ohsome_parse(r)
		expect_s3_class(p$`@snapshotTimestamp`, "POSIXct")
})

test_that(
	'returns data.frame when return_class = "data.frame" and content GeoOJSON', {
		expect_s3_class(ohsome_parse(r, return_class = "data.frame"), "data.frame")
})

test_that(
	'returns list if return_class = "list" and content GeoJSON', {
		expect_type(ohsome_parse(r, return_class = "list"), "list")
})
