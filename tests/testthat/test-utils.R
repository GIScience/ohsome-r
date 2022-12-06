test_that("correctly converts temporal extent when seconds are missing", {
	
	expectedTimestamp <- convert_temporalExtent("2020-10-02T16:00:00Z")
	toTimestamp <- "2020-10-02T16:00Z"
	expect_equal(
		convert_temporalExtent(toTimestamp),
		expectedTimestamp
	)
})
