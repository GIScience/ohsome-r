# simple valid query:
q <- ohsome_query(
	"elements/count", 
	boundary = "0,0,1000",
	filter = "highway=*",
	time = "2020-01-01"
)

test_that("silent on valid query", {
  expect_silent(validate_query(q))
})

test_that("issues warning on unknown endpoint", {
	expect_warning(
		validate_query(set_endpoint(q, "foo")), 
		regexp = "ohsome does not know endpoint foo"
	)
})

test_that("issues warning on missing bounding geometry", {
	expect_warning(
		validate_query(set_parameters(q, bcircles = NULL)),
		regexp = "bpolys, bboxes, or bcircles"
	)
})

test_that("issues warning on unknown param", {
	expect_warning(
		validate_query(set_parameters(q, foo = "bar")),
		regexp = "foo is not a known parameter"
	)
})

test_that("issues warning on missing required param", {
	expect_warning(
		validate_query(set_endpoint(q, "groupBy/key", append = TRUE)),
		regexp = "groupByKeys is a required parameter"
	)
})

test_that("issues warning on missing time param", {
	expect_warning(
		validate_query(set_parameters(q, time = NULL)),
		regexp = "time parameter is not defined"
	)
})

test_that("issues warning on missing filter param", {
	expect_warning(
		validate_query(set_parameters(q, filter = NULL)),
		regexp = "filter parameter is not defined"
	)
})

test_that("issues warning on ratio query without filter2 param", {
	expect_warning(
		validate_query(set_endpoint(q, "ratio", append = TRUE)), 
		regexp = "filter2 parameter needs to be defined in ratio queries."
	)
})
