test_that("requests geojson content with groupBy/boundary queries", {

	q1 <- ohsome_query(c("elements", "count", "groupBy", "boundary"))
	q2 <- ohsome_query("elements/length/density/groupBy/boundary")
	expect_equal(q1$body$format, "geojson")
	expect_equal(q2$body$format, "geojson")
})

test_that("requests csv content with aggregation not grouped by boundary", {
	q1 <- ohsome_query(c("elements", "area", "ratio"))
	q2 <- ohsome_query("elements/count/groupBy/tag")
	expect_equal(q1$body$format, "csv")
	expect_equal(q2$body$format, "csv")
})

test_that("accepts custom format parameter", {
	q <- ohsome_query(c("elements", "count"), format = "foo")
	expect_equal(q$body$format, "foo")
})

test_that("does not set format parameter with elements extraction queries", {
	q1 <- ohsome_query(c("elements", "bbox"))
	q2 <- ohsome_query("elements/centroid")
	expect_null(q1$body$format)
	expect_null(q2$body$format)
})

test_that("returns object of class ohsome_query", {
	expect_s3_class(ohsome_query("elements/count"), "ohsome_query")
})
