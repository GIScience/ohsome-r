# ohsome 0.2.0

* Added a `NEWS.md` file to track changes to the package.
* Changed behaviour of set_properties(): Removes properties parameter from query 
body by default, accepts "tags" and/or "metadata" and/or "contributionTypes as 
properties argument 
(multiple values provided as comma-separated character or character vector).
* Added `ohsome_query()` wrapper functions `ohsome_extract_elements()`,
`ohsome_elements_bbox`, `ohsome_elements_centroid` and `ohsome_elements_geometry` 
for elements extraction endpoints of ohsome API
* Added `ohsome_query()` wrapper functions `ohsome_extract_elementsFullHisotry()`,
`ohsome_elementsFullHistory_bbox`, `ohsome_elementsFullHistory_centroid` and 
`ohsome_elementsFullHistory_geometry` for elementsFullHistory extraction
endpoints of ohsome API
* Added `ohsome_query()` wrapper functions `ohsome_extract_contributions()`,
`ohsome_contributions_bbox`, `ohsome_contributios_centroid` and 
`ohsome_contributions_geometry` for contributions extraction endpoints of ohsome 
API
* Updated `README` to reflect new features, added hints on boundary polygon
acquisition through third-party packages
* Added `CITATION` file with reference to OSHDB/ohsome API