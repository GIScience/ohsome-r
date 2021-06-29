
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ohsome

<!-- badges: start -->
<!-- badges: end -->

The goal of ohsome is to …

## Installation

If you have access to the repository and a
<a href="https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html" target="blank">personal access token</a>,
you can install the development version of ohsome from gitlab:

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
console to get more details:

``` r
.ohsome_metadata
#> $attribution
#> $attribution$url
#> [1] "https://ohsome.org/copyrights"
#> 
#> $attribution$text
#> [1] "© OpenStreetMap contributors"
#> 
#> 
#> $apiVersion
#> [1] "1.5.0"
#> 
#> $timeout
#> [1] 600
#> 
#> $extractRegion
#> $extractRegion$spatialExtent
#> Geometry set for 1 feature 
#> Geometry type: POLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -180 ymin: -90 xmax: 180 ymax: 90
#> Geodetic CRS:  WGS 84
#> POLYGON ((-180 -90, 180 -90, 180 90, -180 90, -...
#> 
#> $extractRegion$temporalExtent
#> [1] "2007-10-08 00:00:00 UTC" "2021-06-20 20:00:00 UTC"
#> 
#> $extractRegion$replicationSequenceNumber
#> [1] 76885
#> 
#> 
#> $apiversion
#> [1] '1.5.0'
#> 
#> attr(,"status_code")
#> [1] 200
#> attr(,"date")
#> [1] "2021-06-29 13:42:53 UTC"
#> attr(,"class")
#> [1] "ohsome_metadata"
```

### Aggregate OpenStreetMap elements

### Other queries

### Bounding geometries
