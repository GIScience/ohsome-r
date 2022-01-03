test_that("creates ohsome_query object with the correct endpoint", {
	q <- ohsome_users_count()
	expect_equal(httr::parse_url(q$url)$path, "v1/users/count")
})

test_that("returns object of class ohsome_query", {
	expect_s3_class(ohsome_users_count(), "ohsome_query")
})

test_that("correctly sets density endpoint on return_value arg", {
	q <- ohsome_users_count(return_value = "density")
	expect_equal(httr::parse_url(q$url)$path, "v1/users/count/density")
})

