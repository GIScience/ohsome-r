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
		'returns character if return_class = "character"', {
			expect_type(ohsome_parse(r, return_class = "character"), "character")
		})

	test_that(
		'returns list if return_class = "list"', {
			expect_type(ohsome_parse(r, return_class = "list"), "list")
		})

	test_that(
		'issues warning and returns data.frame if return_class = "sf" and content not GeoJSON', {
			expect_warning(ohsome_parse(r, return_class = "sf"))
			expect_s3_class(suppressWarnings(ohsome_parse(r, return_class = "sf")), "data.frame")
		})

	test_that(
		'returns data.frame if return_class = "default" and content CSV', {
			expect_s3_class(ohsome_parse(r, return_class = "default"), "data.frame")
		})
})
