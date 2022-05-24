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

# original query:
# ams <- paste(
# 	"9.185889,49.3645403",
# 	"7.1587437,48.8903497",
# 	"5.0183038,49.7603079",
# 	"4.8489984,51.1699332",
# 	"6.9359937,51.7061912",
# 	"9.1311843,50.7703946",
# 	"9.185889,49.3645403",
# 	sep = ","
# )
# q <- ohsome_elements_count(ams, filter = 'building=*', time = '2022-01')
# r <- ohsome_post(q, parse = F)

# original query:
# boundary <- "6.75,51.4,500000"
# q <- ohsome_elements_count(boundary, filter = 'building=*', time = '2022-01')
# r <- ohsome_post(q, parse = F)

r <- readRDS("data/elements-count-buildings-csv.rds")

test_that(
	"correctly converts scientific notation value", {
		p <- ohsome_parse(r)
		expect_equal(p$value[1], 67003817L)
	}
)
