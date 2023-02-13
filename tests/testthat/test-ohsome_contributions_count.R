test_that("creates ohsome_query object with the correct endpoint", {
	q <- ohsome_contributions_count()
	expect_equal(httr::parse_url(q$url)$path, "v1/contributions/count")
})

test_that("returns object of class ohsome_query", {
	expect_s3_class(ohsome_contributions_count(), "ohsome_query")
})

test_that("correctly sets density endpoint on return_value arg", {
	q <- ohsome_contributions_count(return_value = "density")
	expect_equal(httr::parse_url(q$url)$path, "v1/contributions/count/density")
})

test_that("correctly modifies endpoint when latest = TRUE", {
	q <- ohsome_contributions_count(latest = TRUE)
	expect_equal(httr::parse_url(q$url)$path, "v1/contributions/latest/count")
})