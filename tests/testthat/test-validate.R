# simple valid query:
q <- ohsome_query(
	"elements/count", 
	boundary = "0,0,1000",
	filter = "highway=*",
	time = "2020-01-01"
)

test_that("silent on valid query and returns true", {
	expect_silent(validate_query(q))
	expect_true(validate_query(q))
})

test_that("issues warning on unknown endpoint and returns false", {
	q <- set_endpoint(q, "foo")
	expect_warning(
		validate_query(q), 
		regexp = "ohsome does not know endpoint foo"
	)
	expect_false(suppressWarnings(validate_query(q)))
})

test_that("issues warning on missing bounding geometry and returns fals", {
	q <- set_parameters(q, bcircles = NULL)
	expect_warning(
		validate_query(q),
		regexp = "bpolys, bboxes, or bcircles"
	)
	expect_false(suppressWarnings(validate_query(q)))
})

test_that("issues warning on unknown param", {
	q <- set_parameters(q, foo = "bar")
	expect_warning(
		validate_query(q),
		regexp = "foo is not a known parameter"
	)
	expect_false(suppressWarnings(validate_query(q)))
})

test_that("issues warning on missing required param", {
	q <- set_endpoint(q, "groupBy/key", append = TRUE)
	expect_warning(
		validate_query(q),
		regexp = "groupByKeys is a required parameter"
	)
	expect_false(suppressWarnings(validate_query(q)))
})

test_that("issues warning on missing time param", {
	q <- set_parameters(q, time = NULL)
	expect_warning(
		validate_query(q),
		regexp = "time parameter is not defined"
	)
	expect_false(suppressWarnings(validate_query(q)))
})

test_that("issues warning on missing filter param", {
	q <- set_parameters(q, filter = NULL)
	expect_warning(
		validate_query(q),
		regexp = "filter parameter is not defined"
	)
	expect_false(suppressWarnings(validate_query(q)))
})

test_that("issues warning on ratio query without filter2 param", {
	q <- set_endpoint(q, "ratio", append = TRUE)
	expect_warning(
		validate_query(q), 
		regexp = "filter2 parameter needs to be defined in ratio queries."
	)
	expect_false(suppressWarnings(validate_query(q)))
})

test_that("issues specific warning on endpoint with unavailable grouping", {
	q <- set_endpoint(q, "groupBy/foo", append = TRUE)
	expect_warning(
		validate_query(q), 
		regexp = "Only the following groupings are allowed with"
	)
	expect_false(suppressWarnings(validate_query(q)))
})

test_that("issues specific warning on endpoint that allows no grouping", {
	q <- ohsome_query("elements/geometry", grouping = "tag")
	expect_warning(
		validate_query(q), 
		regexp = "Grouping is not allowed"
	)
	expect_false(suppressWarnings(validate_query(q)))
})
