test_that("creates ohsome_query object with the correct endpoint", {
	q <- ohsome_elements_count(mapview::franconia)
	expect_equal(httr::parse_url(q$url)$path, "v1/elements/count")
})

test_that("returns object of class ohsome_query", {
	expect_s3_class(ohsome_elements_count(mapview::franconia), "ohsome_query")
})
