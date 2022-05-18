# ohsome 0.2.0

* Added a `NEWS.md` file to track changes to the package.
* Added `strict`argument to `ohsome_post`. When set to TRUE (default), an error
is thrown on invalid queries and the request is **not** sent to the API. Queries 
with undefined filter or time parameters are considered as invalid in strict 
mode.
* All `ohsome_query()` wrapper functions (but not `ohsome_query()` itself) are 
defined with an appropriate default for the `time` parameter. The default values
are drawn from ohsome API metadata requested on loading the package.
* Changed behavior of `set_properties()`: Removes properties parameter from 
query body by default, accepts *tags* and/or *metadata* and/or 
*contributionTypes* as properties argument (multiple values provided as 
comma-separated character or character vector).
* Changed behavior of `set_time()`, `set_filter()`, `set_groupByKeys()`, 
`set_groupByKey()` and `set_groupByValues`: Return unmodified query object if
parameter argument is missing (e.g. `set_filter(query)`), but remove parameter 
from body if explicitly set to NULL (e.g. `set_filter(query, filter = NULL)`)
* Added `grouping` argument to `ohsome_query()` and `set_grouping()`function. 
Based on `grouping`, the endpoint URL is appended so that aggregations are 
grouped accordingly.
* Added `return_value` argument to `ohsome_aggregate_elements()`. Based on 
`return_value`, the endpoint URL is appended so that either absolute aggregate 
values, densities or ratios are requested from the ohsome API.
* Added `ohsome_query()` wrapper functions `ohsome_extract_elements()`,
`ohsome_elements_bbox`, `ohsome_elements_centroid` and `ohsome_elements_geometry` 
for elements extraction endpoints of ohsome API
* Added `ohsome_query()` wrapper functions `ohsome_extract_elementsFullHistory()`,
`ohsome_elementsFullHistory_bbox()`, `ohsome_elementsFullHistory_centroid()` and 
`ohsome_elementsFullHistory_geometry()` for elementsFullHistory extraction
endpoints of ohsome API
* Added `ohsome_query()` wrapper functions `ohsome_extract_contributions()`,
`ohsome_contributions_bbox()`, `ohsome_contributios_centroid()` and 
`ohsome_contributions_geometry()` for contributions extraction endpoints of ohsome 
API
* Added `ohsome_query()` wrapper functions `ohsome_contributions_count()` for 
contributions aggregation endpoints of ohsome API
* Added `ohsome_query()` wrapper function `ohsome_users_count()` for user 
aggregation endpoints of ohsome API
* `ohsome_medata` and `ohsome_temporalExtent` are assigned on loading (not on
attaching) the package
* Added endpoint-specific check for missing required parameters to query 
validation
* `ohsome_parse()` throws appropriate error if the response content contains a 
status code 413 message (timeout)
* Updated `README` to reflect new features, added hints on boundary polygon
acquisition through third-party packages
* Added `CITATION` file with reference to OSHDB/ohsome API and technical paper
