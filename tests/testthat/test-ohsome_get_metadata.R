with_mock_api({

	unlockBinding(".ohsome_metadata", as.environment("package:ohsome"))

	# mock response: tests/testthat/api.ohsome.org/v1/metadata.json:
	test_that(
		"assigns metadata to ohsome_metadata", {
			ohsome_get_metadata(quiet = T)
			expect_equal(.ohsome_metadata$apiVersion, "99999")
			expect_type(.ohsome_metadata, "list")
			expect_s3_class(.ohsome_metadata, "ohsome_metadata")
	})

	test_that(
		"returns metadata", {
			meta <- ohsome_get_metadata(quiet = T)
			expect_equal(meta$apiVersion, "99999")
			expect_type(meta, "list")
			expect_s3_class(meta, "ohsome_metadata")
	})

	test_that(
		"returns message if quiet = F", {
		expect_message(ohsome_get_metadata(quiet = F))
	})

	# mock response tests/testthat/api.ohsome.org/404/metadata.R:
	test_that(
		"throws error if status code != 200", {
			old_api_url <- ohsome_api_url
			ohsome_api_url <- "https://api.ohsome.org/404"
			on.exit(ohsome_api_url <- old_api_url)

			expect_error(ohsome_get_metadata(quiet = T))
	})
})

