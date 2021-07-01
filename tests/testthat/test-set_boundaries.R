test_that("removes bcircles parameter when setting new bboxes parameter", {

	q1 <- ohsome_elements_count("8,49,1000")
	q2 <- set_boundary(q1, "8,49,9,50")
	expect_null(q2$body$bcircles)
})
