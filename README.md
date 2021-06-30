
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
remotes::install_gitlab(
    repo = "giscience/big-data/ohsome/libs/ohsome-r@develop",
    host = "https://gitlab.gistools.geog.uni-heidelberg.de",
    auth_token = personal_access_token
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
#>              timestamp value
#> 1 2021-06-20T20:00:00Z 125.0
```


### Other queries

### Bounding geometries
