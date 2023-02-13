test_that("replaces endpoint in ohsome_query by default (append = FALSE)", {

	q1 <- ohsome_query("elements/count")
	q2 <- set_endpoint(q1, "elements/length")
	expect_equal(httr::parse_url(q2$url)$path, "v1/elements/length")
})

test_that("appends endpoint if append = TRUE", {

	q1 <- ohsome_query("elements/count")
	q2 <- set_endpoint(q1, c("groupBy", "boundary"), append = TRUE)
	expect_equal(httr::parse_url(q2$url)$path, "v1/elements/count/groupBy/boundary")
})

test_that("resets response format correctly according to reset_format argument",{
	q1 <- ohsome_query("elements/count")
	q2 <- set_endpoint(q1, c("groupBy", "boundary"), append = TRUE, reset_format = FALSE)
	q3 <- set_endpoint(q1, c("groupBy", "boundary"), append = TRUE)
	q4 <- set_endpoint(q1, c("elements/geometry"))
	expect_equal(q2$body$format, "csv")
	expect_equal(q3$body$format, "geojson")
	expect_null(q4$body$format)
})

test_that("returns unmodified endpoint if grouping arg is missing", {
	q1 <- ohsome_query("elements/count/groupBy/boundary/groupBy/tag")
	q2 <- set_grouping(q1)
	expect_equal(httr::parse_url(q1$url)$path, httr::parse_url(q2$url)$path)
	
	q1 <- ohsome_query("elements/count")
	q2 <- set_grouping(q1)
	expect_equal(httr::parse_url(q1$url)$path, httr::parse_url(q2$url)$path)
})

test_that("correctly modifies grouping", {
	q1 <- ohsome_query("elements/count/groupBy/boundary")
	q2 <- set_grouping(q1, "tag")
	expect_equal(httr::parse_url(q2$url)$path, "v1/elements/count/groupBy/tag")
	
	q1 <- ohsome_query("elements/count")
	q2 <- set_grouping(q1, "tag")
	expect_equal(httr::parse_url(q2$url)$path, "v1/elements/count/groupBy/tag")
	
	q1 <- ohsome_query("elements/count")
	q2 <- set_grouping(q1, c("Boundary", "Tag"))
	expect_equal(httr::parse_url(q2$url)$path, "v1/elements/count/groupBy/boundary/groupBy/tag")
})

test_that("removes grouping if grouping = NULL", {
	q1 <- ohsome_query("elements/count/groupBy/boundary")
	q2 <- set_grouping(q1, grouping = NULL)
	expect_equal(httr::parse_url(q2$url)$path, "v1/elements/count")
})