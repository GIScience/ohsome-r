test_that("sets and modifies parameters of ohsome_query", {

	q <- ohsome_query("elements/count") %>%
		set_parameters(foo = "bar", foo2 = "bar") %>%
		set_parameters(foo = "baz")

	expect_equal(q$body$foo, "baz")
	expect_equal(q$body$foo2, "bar")
})

# set properties
test_that("removes properties from query body by default", {
	q <- ohsome_query("elements/centroid", properties = "tags")
	expect_null(set_properties(q)$body$properties)
}
)

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

test_that("throws error on properties argument other than 'tags' or 'metadata'", {
	
	q <- ohsome_query("elements/centroid")
	
	expect_error(set_properties(q, "foo"))
})