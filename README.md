# California Fisheries Habitat Suitability Map

## Overview

This project features the creation of a function that creates a habitat suitability map. When provided the data used in this project, the function can create a masked raster for the suitable habitat of any user defined aquatic species.

![](sea-shell.jpg "Bivalve in the ocean.")

## Description

### File Information

Information on the files within this repository...

-   `make_suitability_map.qmd` contains all code that construct the function, and can be used to use the function as well. It also allows the saving of ones map as a .png.
-   `habitat_suitability_function.html` contains all documentation concerning the workflow for it's creation, it's use, and it's dependent datasets.
    -   `habitat_suitability_function_files/` contains associated files for the rendering of the html.

### File Structure

```         
UCSB-EDS-220-Fisheries-Habitat-Suitability
│
├── README.md
│
├── make_suitability_map.qmd
|
├── habitat_suitability_function.html
├── habitat_suitability_function_files/
├── custom.css  # html style information
|
├── UCSB-EDS-223-Fisheries-Habitat-Suitability.Rproj
│
├── sea-shell.jpg # photo for README
├── .gitignore 
```

## Data Access

-   The `average_annual_sst` GeoTIFFs are pre-processed rasters that were derived from NOAA’s 5km Daily Global Satellite Sea Surface Temperature Anomaly v3.1 project. The original data can be accessed from [NOAA Coral Reef Watch's library of 5km satellite data](https://coralreefwatch.noaa.gov/product/5km/index.php).
-   `depth.tif` is directly accessible from the [GEBCO's Gridded Bathymetry Data](https://www.gebco.net/data_and_products/gridded_bathymetry_data/#area) webpage.
-   `wc_regions_clean.shp` is downloadable from the [marineregions.org library of shapefiles](https://www.marineregions.org/downloads.php).

## How to use
To use the function, input your parameters into the lowest code chunks in `make_suitability_map.qmd` and run all.

## References

### Acknowledgements

#### This project is supported in part by:

-   [EDS 223 Geospatial Analysis at UCSB](https://eds-223-geospatial.github.io/)
-   [UCSB Bren School for Environmental Science and Management](https://bren.ucsb.edu/)
-   [The Master of Environmental Data Science degree at Bren](https://bren.ucsb.edu/masters-programs/master-environmental-data-science)
-   [National Center for Ecological Analysis and Synthesis (NCEAS)](https://www.nceas.ucsb.edu/)
-   [Sam Csik](https://samanthacsik.github.io/)

### Data Citations

| Data | Citation | Link |
|------------------------|------------------------|------------------------|
| OpenStreetMap from Geofabrik | Fellows I, Stotz utJlbJP (2023). *OpenStreetMap: Access to Open Street Map Raster Images*. R package version 0.4.0, <https://CRAN.R-project.org/package=OpenStreetMap>. | [Link](https://www.openstreetmap.org) |
| Pacific Geoduck page on SeaLifeBase | Pacific Northwest Shell Club (2014) Pacific Northwest marine molluscan biodiversity. *Pacific Northwest Shell Club*, www.PNWCS.org. <http://www.bily.com/pnwsc/web-content/Northwest%20Marine%20Molluscan%20Biodiversity.html>. | [Link](https://www.sealifebase.ca/summary/Panopea-generosa.html) |
| NOAA’s 5km Daily Global Satellite Sea Surface Temperature Anomaly v3.1. | NOAA Coral Reef Watch (2018). *Daily Global 5km Satellite Sea Surface Temperature Anomaly* (Version 3.1) [Dataset]. Released August 1, 2018. | [Link](https://coralreefwatch.noaa.gov/product/5km/index_5km_ssta.php) |
| GEBCO California Bathymetry Data | GEBCO Bathymetric Compilation Group (2024). *The GEBCO_2024 Grid - a continuous terrain model of the global oceans and land. NERC EDS British Oceanographic Data Centre NOC* [Dataset]. <doi:10.5285/1c44ce99-0a0d-5f4f-e063-7086abc0ea0f> | [Link](https://www.gebco.net/data_and_products/gridded_bathymetry_data/#area) |
| Exclusive Economic Zone Boundaries | Flanders Marine Institute (2024). *Union of the ESRI Country shapefile and the Exclusive Economic Zones* (version 4) [Dataset}]. Available online at <https://www.marineregions.org/>. <https://doi.org/10.14284/698> | [Link](https://www.marineregions.org/eez.php) |
