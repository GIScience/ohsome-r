with_mock_api({

	.mockPaths("./mock_api/200")

	# mock response: tests/testthat/mock_api/200/api.ohsome.org/v1/elements/count-754ee5-POST.csv
	q <- ohsome_query(
		c("elements", "count"),
		filter = "shop=convenience",
		bcircles = "13.45,52.5,1000",
		format = "csv"
	)
	r <- ohsome_post(q, parse = FALSE)

	test_that(
		'returns data.frame by default when content CSV', {
			expect_s3_class(ohsome_parse(r), "data.frame")
		})

	test_that(
		'issues warning and returns data.frame if return_class = "sf" and content not GeoJSON', {
			expect_warning(ohsome_parse(r, return_class = "sf"))
			expect_s3_class(suppressWarnings(ohsome_parse(r, return_class = "sf")), "data.frame")
		})

	test_that(
		'returns list if return_class = "list"', {
			expect_type(ohsome_parse(r, return_class = "list"), "list")
		})

	test_that(
		'returns character if return_class = "character"', {
			expect_type(ohsome_parse(r, return_class = "character"), "character")
		})
})

with_mock_api({

	.mockPaths("./mock_api/200")

	# mock response: tests/testthat/mock_api/200/api.ohsome.org/v1/elements/centroid-ba0611-POST.csv
	q <- ohsome_query(
		c("elements", "centroid"),
		filter = "shop=convenience",
		bcircles = "13.45,52.5,1000"
	)
	r <- ohsome_post(q, parse = FALSE)

	test_that(
		'returns sf by default when content GeoJSON', {
			expect_s3_class(ohsome_parse(r, return_class = "sf"), "sf")
		})

	test_that(
		'returns data.frame when return_class = "data.frame" and content GeoOJSON', {
			expect_s3_class(ohsome_parse(r, return_class = "data.frame"), "data.frame")
		})

	test_that(
		'returns list if return_class = "list" and content GeoJSON', {
			expect_type(ohsome_parse(r, return_class = "list"), "list")
		})
})
