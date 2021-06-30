
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ohsome

<!-- badges: start -->
<!-- badges: end -->

This *ohsome* R package grants access to the power of the *ohsome* API
from R. ohsome is … OSHDB …

## Installation

If you have access to the repository and a
<a href="https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html" target="blank">personal access token</a>,
you can install the development version of *ohsome* from GitLab:

``` r
Sys.setenv(GITLAB_PAT = your_personal_access_token)

remotes::install_gitlab(
    repo = "giscience/big-data/ohsome/libs/ohsome-r@develop",
    host = "https://gitlab.gistools.geog.uni-heidelberg.de"
)
```

## Getting started

Upon attaching the *ohsome* package, a metadata request is sent to the
*ohsome* API. The package message provides some essential metadata
information, such as the current temporal extent of the underlying
OSHDB:

``` r
library(ohsome)
#> Data: © OpenStreetMap contributors https://ohsome.org/copyrights
#> ohsome API version: 1.5.0
#> Temporal extent: 2007-10-08 to 2021-06-20 20:00:00
```

The metadata is stored in *.ohsome\_metadata*. You can print it to the
console to get more details.

### Aggregate OpenStreetMap elements

This early version of the *ohsome* R package provides wrapper functions
for the elements aggregation endpoints only. With these functions you
can query the *ohsome* API for the aggregated amount, length, area or
perimeter of OpenStreetMap elements with given properties, within given
boundaries and at given points in time.

Here, we create a query for the total amount of breweries on OSM in the
German region of Franconia. The first argument to
*ohsome\_elements\_count()* is the *sf* object *franconia* that is
included in the *mapview* package:

``` r
library(mapview)

q <- ohsome_elements_count(franconia, filter = "craft=brewery")
```

The resulting *ohsome\_query* object can be sent to the *ohsome* API
with *ohsome\_post()*. By default, *ohsome\_post()* returns the parsed
API response which is a simple data.frame in this case.

``` r
ohsome_post(q)
#> Warning: Time parameter is not defined and defaults to latest available
#> timestamp within the underlying OSHDB. You can use set_time() to set the time
#> parameter.
#>             timestamp value
#> 1 2021-06-20 20:00:00   125
```

We now know that there were 125 breweries in Franconia on OSM at a
certain point in time. However, *ohsome\_post()* has issued a warning
that the time parameter of the query was not defined. Thus, the *ohsome*
API returned the number of elements at the latest available timestamp.

The
<a href="https://docs.ohsome.org/ohsome-api/stable/time.html" target="blank">time parameter</a>
allows to access the OSM history through the *ohsome* API. This would
create a query of the number of breweries at January 1st of each year
between 2010 and 2020:

``` r
franconia |> 
    ohsome_elements_count(filter = "craft=brewery", time = "2010/2020/P1Y")
```

Alternatively, we can update the existing *ohsome\_query* object *q*
with the *set\_time()* function, pipe the modified query directly into
*ohsome\_post()* and make a quick visualisation with *ggplot2*:

``` r
library(ggplot2)

q |> 
    set_time("2010/2020/P1Y") |>
    ohsome_post() |>
    ggplot(aes(x = timestamp, y = value)) +
    geom_col()
```

<img src="man/figures/README-pipe-1.png" width="100%" />

What if we want to know not the total number of breweries in all of
Franconia, but rather per each district of Franconia? The
*set\_endpoint()* function can be used to change or append to the
endpoint path of an API request. In this case, we would want to append
`/groupBy/boundary` to the `elements/count` endpoint. The endpoint path
can either be given as a single string (`/groupBy/boundary`) or as a
character vector[1] as in this example:

``` r
q <- set_time(q, "2021-06-01")

q |>
    set_endpoint(c("groupBy", "boundary"), append = TRUE) |>
    ohsome_post()
#> Simple feature collection with 37 features and 3 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 8.975926 ymin: 48.8625 xmax: 12.27535 ymax: 50.56422
#> Geodetic CRS:  WGS 84
#> First 10 features:
#>    value groupByBoundaryId  timestamp                       geometry
#> 1      6          feature1 2021-06-01 MULTIPOLYGON (((10.92581 49...
#> 2      6          feature2 2021-06-01 MULTIPOLYGON (((11.58157 49...
#> 3      0          feature3 2021-06-01 MULTIPOLYGON (((10.95355 50...
#> 4      1          feature4 2021-06-01 MULTIPOLYGON (((11.93067 50...
#> 5     13          feature5 2021-06-01 MULTIPOLYGON (((10.87615 50...
#> 6     13          feature6 2021-06-01 MULTIPOLYGON (((11.70656 50...
#> 7      6          feature7 2021-06-01 MULTIPOLYGON (((10.88654 50...
#> 8      8          feature8 2021-06-01 MULTIPOLYGON (((11.26376 49...
#> 9      4          feature9 2021-06-01 MULTIPOLYGON (((11.91989 50...
#> 10     1         feature10 2021-06-01 MULTIPOLYGON (((11.36979 50...
```

By default, *ohsome\_post()* returns an *sf* object whenever the
*ohsome* API is capable of delivering GeoJSON data – which is the case
for elements extraction queries as well as for aggregations grouped by
boundaries.

It is thus possible to easily create a choropleth map from the query
results. As it makes more sense to visualise amounts normalised by area
rather than absolute amounts on such a map, “density” can be added to
the endpoint path to query for the amount of breweries per square
kilometer:

``` r
q |>
    set_endpoint(c("density", "groupBy", "boundary"), append = TRUE) |>
    ohsome_post() |>
    mapview(zcol = "value")
```

<img src="man/figures/README-density-1.png" width="100%" />

### Other queries

### Bounding geometries

[1] The order of the elements in the character vector is critical!
