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

test_that("does not overwrite explicit format with groupBy/boundary", {
	q <- ohsome_query("elements/count", grouping = "boundary", format = "csv")
	expect_equal(q$body$format, "csv")
})

test_that("returns object of class ohsome_query", {
	expect_s3_class(ohsome_query("elements/count"), "ohsome_query")
})

test_that("issues warning if boundary and other bounding geom params are set", {
	expect_warning(
		ohsome_query("elements/count", boundary = "0,0,1,1", bboxes = "1,1,2,2")
	)
	expect_warning(
		ohsome_query("elements/count", boundary = "0,0,1,1", bcircles = "0,0,1000")
	)
	expect_warning(
		ohsome_query("elements/count", boundary = "0,0,1,1", bpolys = "foo")
	)
})

test_that("correctly sets bboxes param based on boundary argument", {
	bbox <- "0,0,1,1"
	q <- ohsome_query("elements/count", boundary = bbox)
	expect_equal(q$body$bboxes, bbox)
})

