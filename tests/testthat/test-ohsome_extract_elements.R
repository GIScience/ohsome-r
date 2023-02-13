test_that("creates ohsome_query object with the correct endpoint", {
	q <- ohsome_elements_geometry()
	expect_equal(httr::parse_url(q$url)$path, "v1/elements/geometry")
})

test_that("returns object of class ohsome_query", {
	expect_s3_class(ohsome_extract_elements(), "ohsome_query")
})

test_that("correctly sets clipGeometry parameter", {
	q <- ohsome_elements_geometry(clipGeometry = FALSE)
	expect_equal(q$body$clipGeometry, "FALSE")
})
