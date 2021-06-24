with_mock_api({

	.mockPaths("./mock_api/200")

	# mock response: tests/testthat/mock_api/200/api.ohsome.org/v1/elements/count-754ee5-POST.csv
	test_that(
		"returns ohsome API response if parse = FALSE", {

			q <- ohsome_query(
				c("elements", "count"),
				filter = "shop=convenience",
				bcircles = "13.45,52.5,1000"
			)

			expect_s3_class(ohsome_post(q, parse = FALSE), "response")
	})

	test_that(
		"returns data.frame if parse = TRUE", {

			q <- ohsome_query(
				c("elements", "count"),
				filter = "shop=convenience",
				bcircles = "13.45,52.5,1000"
			)

			expect_s3_class(ohsome_post(q, parse = TRUE), "data.frame")
		})
})


with_mock_api({

	# mock response: tests/testthat/mock_api/404/api.ohsome.org/elements/amount-754ee5-POST.R
	.mockPaths("./mock_api/404")

	test_that(
		"throws error on API request fail", {

			q <- ohsome_query(
				c("elements", "amount"),
				filter = "shop=convenience",
				bcircles = "13.45,52.5,1000"
			)

			expect_error(ohsome_post(q))
		})
})
