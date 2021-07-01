test_that("correctly detects boundary type for character objects", {

	bboxes1 <- paste(
		"8.5992,49.3567,8.7499,49.4371",
		"9.1638,49.113,9.2672,49.1766",
		sep = "|"
	)
	bboxes2 <- paste(
		"Heidelberg:8.5992,49.3567,8.7499,49.4371",
		"Heilbronn:9.1638,49.113,9.2672,49.1766",
		sep = "|"
	)
	bcircles1 <- paste(
		"8.6528,49.3683,1000",
		"8.7294,49.4376,1000",
		sep = "|"
	)
	bcircles2 <- paste(
		"Circle 1:8.6528,49.3683,1000",
		"Circle 2:8.7294,49.4376,1000",
		sep = "|"
	)
	bpolys1 <- paste(
		"8.65821,49.41129,8.65821,49.41825,8.70053,49.41825,8.70053,49.41129,8.65821,49.41129",
		"8.67817,49.42147,8.67817,49.4342,8.70053,49.4342,8.70053,49.42147,8.67817,49.42147",
		sep = "|"
	)
	bpolys2 = paste(
		"Region 1:8.65821,49.41129,8.65821,49.41825,8.70053,49.41825,8.70053,49.41129,8.65821,49.41129",
		"Region 2:8.67817,49.42147,8.67817,49.4342,8.70053,49.4342,8.70053,49.42147,8.67817,49.42147",
		sep = "|"
	)
	bpolys3 = '{"type":"FeatureCollection","features":[{"type":"Feature","properties":{"id":"Region 1"},"geometry":{"type":"Polygon","coordinates":[[[8.65821,49.41129],[8.65821,49.41825],[8.70053,49.41825],[8.70053,49.41129],[8.65821,49.41129]]]}},{"type":"Feature","properties":{"id":"Region 2"},"geometry":{"type":"Polygon","coordinates":[[[8.67817,49.42147],[8.67817,49.4342],[8.70053,49.4342],[8.70053,49.42147],[8.67817,49.42147]]]}}]}'

	expect_equal(ohsome_boundary(bboxes1)$type, "bboxes")
	expect_equal(ohsome_boundary(bboxes2)$type, "bboxes")
	expect_equal(ohsome_boundary(bcircles1)$type, "bcircles")
	expect_equal(ohsome_boundary(bcircles2)$type, "bcircles")
	expect_equal(ohsome_boundary(bpolys1)$type, "bpolys")
	expect_equal(ohsome_boundary(bpolys2)$type, "bpolys")
	expect_equal(ohsome_boundary(bpolys3)$type, "bpolys")
})

test_that("returns ohsome_boundary object", {

	bpolys <- paste(
		"8.65821,49.41129,8.65821,49.41825,8.70053,49.41825,8.70053,49.41129,8.65821,49.41129",
		"8.67817,49.42147,8.67817,49.4342,8.70053,49.4342,8.70053,49.42147,8.67817,49.42147",
		sep = "|"
	)
	expect_s3_class(ohsome_boundary(bpolys), "ohsome_boundary")
})

test_that("returns ohsome_boundary object with type = bpolys for sf boundaries", {
	expect_equal(ohsome_boundary(mapview::franconia)$type, "bpolys")
})

test_that("returns ohsome_boundary object with type = bpolys for bbox boundaries", {
	expect_equal(ohsome_boundary(sf::st_bbox(mapview::franconia))$type, "bboxes")
})

test_that("throws error on sf with point geometries only", {
	expect_error(ohsome_boundary(mapview::breweries))
})

test_that("issues warning for sf boundaries that contain polygon and other geoms", {
	mixed <- dplyr::bind_rows(mapview::franconia, mapview::breweries)
	expect_warning(ohsome_boundary(mixed))
})

test_that("creates ohsome_boundary object from list of bboxes of various classes", {

	bboxes1 <- c(
		"8.5992,49.3567,8.7499,49.4371",
		"9.1638,49.113,9.2672,49.1766"
	)
	bboxes2 <- osmdata::getbb("Berlin")
	bboxes3 <- sf::st_bbox(mapview::breweries)

	b <- ohsome_boundary(list(bboxes1, bboxes2, bboxes3))
	expect_s3_class(b, "ohsome_boundary")
})
