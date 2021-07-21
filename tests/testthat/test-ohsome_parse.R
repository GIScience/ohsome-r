# original query:
# q <- ohsome_query(
# 	c("elements", "count"),
# 	filter = "shop=convenience",
# 	bcircles = "13.45,52.5,1000",
# 	format = "csv"
# )
# r <- ohsome_post(q, parse = FALSE, validate = FALSE)

r <- readRDS("data/elements-count-shop-convenience-bcircles-csv.rds")

test_that(
	'returns data.frame by default when content CSV', {
		expect_s3_class(ohsome_parse(r), "data.frame")
})

test_that(
	'converts timestamp to POSIXct in data.frame', {
		p <- ohsome_parse(r)
		expect_s3_class(p$timestamp, "POSIXct")
})

test_that(
	'issues warning and returns data.frame if returnclass = "sf" and content not GeoJSON', {
		expect_warning(ohsome_parse(r, returnclass = "sf"))
		expect_s3_class(suppressWarnings(ohsome_parse(r, returnclass = "sf")), "data.frame")
})

test_that(
	'returns list if returnclass = "list"', {
		expect_type(ohsome_parse(r, returnclass = "list"), "list")
})

test_that(
	'returns character if returnclass = "character"', {
		expect_type(ohsome_parse(r, returnclass = "character"), "character")
})



# original query:
# q <- ohsome_query(
# 	c("elements", "centroid"),
# 	filter = "shop=convenience",
# 	bcircles = "13.45,52.5,1000"
# )
# r <- ohsome_post(q, parse = FALSE, validate = FALSE)

r <- readRDS("data/elements-centroid-shop-convenience-bcircles.rds")

test_that(
	'returns sf by default when content GeoJSON', {
		expect_s3_class(ohsome_parse(r, returnclass = "sf"), "sf")
})

test_that(
	'converts @snapshotTimestamp to POSIXct in sf objects', {
		p <- ohsome_parse(r)
		expect_s3_class(p$`@snapshotTimestamp`, "POSIXct")
})

test_that(
	'returns data.frame when returnclass = "data.frame" and content GeoOJSON', {
		expect_s3_class(ohsome_parse(r, returnclass = "data.frame"), "data.frame")
})

test_that(
	'returns list if returnclass = "list" and content GeoJSON', {
		expect_type(ohsome_parse(r, returnclass = "list"), "list")
})

test_that(
	'does not issue warning if no geometries are omitted when omit_empty = TRUE', {
		expect_silent(ohsome_parse(r, returnclass = "sf", omit_empty = TRUE))
})

# original query:
# q <- franconia |>
# 	mutate(id  = NUTS_ID) |>
# 	ohsome_elements_count(filter = "building=*", time = "2015/2020", format = "csv") |>
# 	set_endpoint("groupBy/boundary/groupBy/tag", reset_format = FALSE, append = TRUE) |>
# 	set_groupByKey("building:levels")
# r <- ohsome_post(q, parse = FALSE, validate = FALSE)

r <- readRDS("data/elements-count-buildings-groupby-boundary-groupby-tag-csv.rds")

test_that(
	'succesfully parses csv response of groupBy/boundary/groupBy/tag query', {
		expect_s3_class(ohsome_parse(r), "data.frame")
})

# original query:
# q <- ohsome_query(
# 	"elementsFullHistory/geometry", 
# 	bboxes = "-180,-90,180,90", 
# 	filter = "id:way/625011340", 
# 	time = "2008-01-01,2020-01-01"
# )
# r <- ohsome_post(q, parse = FALSE, validate = FALSE)

r <- readRDS("data/elements-fullHistory-geometry-id-way-625011340.rds")

test_that(
	"parses GeoJSON FeatureCollection with faulty feature (way without nodes)", {
		expect_s3_class(
			suppressWarnings(ohsome_parse(r, returnclass = "sf")), 
			"sf"
		)
})

test_that(
	"issues warning when omitting empty geometry features", {
		expect_warning(ohsome_parse(r, returnclass = "sf"))
})
