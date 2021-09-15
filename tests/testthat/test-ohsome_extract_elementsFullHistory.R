test_that("creates ohsome_query object with the correct endpoint", {
	q <- ohsome_elementsFullHistory_geometry(time = "2010,2020")
	expect_equal(httr::parse_url(q$url)$path, "v1/elementsFullHistory/geometry")
})

test_that("returns object of class ohsome_query", {
	expect_s3_class(ohsome_extract_elementsFullHistory(time = "2010,2020"), "ohsome_query")
})

test_that("correctly sets clipGeometry parameter", {
	q <- ohsome_elementsFullHistory_geometry(time = "2010,2020", clipGeometry = FALSE)
	expect_equal(q$body$clipGeometry, "FALSE")
})

test_that("uses full temporal extent if time parameter is missing", {
	expect_equal(
		ohsome_extract_elementsFullHistory()$body$time,
		paste(lubridate::format_ISO8601(.ohsome_metadata$extractRegion$temporalExtent), collapse = ",")
	)
})
