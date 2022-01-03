test_that("sets and modifies parameters of ohsome_query", {

	q <- ohsome_query("elements/count") %>%
		set_parameters(foo = "bar", foo2 = "bar") %>%
		set_parameters(foo = "baz")

	expect_equal(q$body$foo, "baz")
	expect_equal(q$body$foo2, "bar")
})

test_that("returns unmodified query if filter arg is missing", {
	q1 <- ohsome_query("elements/count",filter = "foo")
	q2 <- set_filter(q1)
	expect_equal(q1$body$filter, q2$body$filter)
})

test_that("removes filter with arg filter = NULL", {
	q1 <- ohsome_query("elements/count", filter = "foo")
	q2 <- set_filter(q1, filter = NULL)
	expect_null(q2$body$filter)
})

# set properties
test_that("removes properties from query body by default", {
	q <- ohsome_query("elements/centroid", properties = "tags")
	expect_null(set_properties(q)$body$properties)
})

test_that("correctly sets properties", {
	q <- ohsome_query("elements/centroid")
	
	expect_equal(
		set_properties(q, "tags")$body$properties,
		"tags"
	)
	expect_equal(
		set_properties(q, "metadata, tags")$body$properties,
		"metadata,tags"
	)
	expect_equal(
		set_properties(q, c("tags", "metadata"))$body$properties,
		"tags,metadata"
	)
})

test_that("throws error on properties argument 'foo'", {
	
	q <- ohsome_query("elements/centroid")
	
	expect_error(set_properties(q, "foo"))
})

test_that("removes 'contributionTypes' from element extraction query", {
	
	q <- ohsome_query("elements/elements/bbox")
	
	expect_equal(
		set_properties(q, c("tags", "contributionTypes"))$body$properties,
		"tags"
	)
})

test_that("accepts 'contributionTypes' in contribution extraction", {
	
	q <- ohsome_query("elements/contributions/bbox")
	
	expect_equal(
		set_properties(q, c("tags", "contributionTypes"))$body$properties,
		"tags,contributionTypes"
	)
})