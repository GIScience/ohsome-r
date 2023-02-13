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
