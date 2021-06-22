with_mock_api({

	.mockPaths("./200")

	# mock response: tests/testthat/200/api.ohsome.org/v1/elements/count-754ee5-POST.csv
	test_that(
		"returns ohsome API response", {

			q <- ohsome_query(
				c("elements", "count"),
				filter = "shop=convenience",
				bcircles = "13.45,52.5,1000"
			)

			expect_s3_class(ohsome_post(q), "response")
	})
})


with_mock_api({

	# mock response: tests/testthat/404/api.ohsome.org/elements/amount-754ee5-POST.R
	.mockPaths("./404")

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
