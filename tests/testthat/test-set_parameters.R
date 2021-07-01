test_that("sets and modifies parameters of ohsome_query", {

	q <- ohsome_query("elements/count") %>%
		set_parameters(foo = "bar", foo2 = "bar") %>%
		set_parameters(foo = "baz")

	expect_equal(q$body$foo, "baz")
	expect_equal(q$body$foo2, "bar")
})
