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

test_that("issues warning on defaulting time param", {
	q <- set_parameters(q, time = NULL)
	expect_warning(
		validate_query(q),
		regexp = "time parameter is not defined and defaults"
	)
	expect_false(suppressWarnings(validate_query(q)))
})

test_that("does not issue warn on missing time param when time has default", {
	q <- set_parameters(q, time = NULL)
	suppressWarnings(expect_failure(	
		expect_warning(
			validate_query(q),
			regexp = "time is a required parameter"
		)
	))
	expect_false(suppressWarnings(validate_query(q)))
})

test_that("does not warn on defaulting time param when time is required", {
	q <- set_endpoint(q, "elementsFullHistory/centroid")
	q <- set_parameters(q, time = NULL)
	suppressWarnings(expect_failure(
		expect_warning(
			validate_query(q),
			regexp = "time parameter is not defined and defaults"
		)
	))
	expect_false(suppressWarnings(validate_query(q)))
})

test_that("issues warning on missing time param when time is required", {
	q <- set_endpoint(q, "elementsFullHistory/centroid")
	q <- set_parameters(q, time = NULL)
	expect_warning(
		validate_query(q),
		regexp = "time is a required parameter"
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

# original_query
# q <- ohsome_elements_geometry(
# 	rgeoboundaries::gb_adm0("Germany"), 
# 	filter ="amenity=hospital", 
# 	time="2022-01-01",
# 	timeout = 200
# )
# r <- ohsome_post(q, parse = FALSE, validate = FALSE)
# content <- httr::content(r, as = "text", encoding = "utf-8")

content <- readRDS("data/elements-geometry-amenity-hospitals-Germany-content.rds")

test_that(
	"throws error on invalid JSON with 413 timeout message", {
		expect_error(
			validate_json(content),
			"Invalid JSON in ohsome API response.\nThe given query is too large"
		)
	}
)
