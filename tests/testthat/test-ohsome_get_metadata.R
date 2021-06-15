with_mock_api({
	test_that(
		"ohsome_get_metadata assigns metadata to ohsome_metadata", {
			ohsome_get_metadata()
			expect_equal(ohsome_metadata$apiVersion, "1.4.1")
			expect_type(ohsome_metadata, "list")
		})

	test_that(
		"ohsome_get_metadata returns metadata", {
			meta <- ohsome_get_metadata()
			expect_equal(meta$apiVersion, "1.4.1")
			expect_type(meta, "list")
		})
})

