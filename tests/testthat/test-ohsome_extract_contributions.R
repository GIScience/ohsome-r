test_that("creates ohsome_query object with the correct endpoint", {
	q <- ohsome_contributions_geometry()
	expect_equal(httr::parse_url(q$url)$path, "v1/contributions/geometry")
})

test_that("correctly modifies endpoint when latest = TRUE", {
	q <- ohsome_contributions_geometry(latest = TRUE)
	expect_equal(httr::parse_url(q$url)$path, "v1/contributions/latest/geometry")
})

test_that("returns object of class ohsome_query", {
	expect_s3_class(ohsome_extract_contributions(), "ohsome_query")
})

test_that("correctly sets clipGeometry parameter", {
	q <- ohsome_contributions_geometry(clipGeometry = FALSE)
	expect_equal(q$body$clipGeometry, "FALSE")
})

test_that("uses full temporal extent if time parameter is missing", {
	expect_equal(
		ohsome_extract_contributions()$body$time,
		paste(lubridate::format_ISO8601(.ohsome_metadata$extractRegion$temporalExtent), collapse = ",")
	)
})
