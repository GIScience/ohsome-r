# ohsome 0.2.0

* Added a `NEWS.md` file to track changes to the package.
* Changed behaviour of set_properties(): Removes properties parameter from query 
body by default, accepts "tags" and/or "metadata" as properties argument 
(multiple values provided as comma-separated character or character vector).
* Added `ohsome_query()` wrapper functions `ohsome_extract_elements()`,
`ohsome_elemets_bbox`, `ohsome_elemets_centroid` and `ohsome_elemets_geometry` 
for elements extraction endpoints of ohsome API
* Updated `README` to reflect new features