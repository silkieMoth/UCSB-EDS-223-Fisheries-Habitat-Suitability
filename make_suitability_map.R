# This script contains all code to create and use the habitat suitability function. Include source("file/path/make_suitability_map.R") in your Quarto documents to access it. 

# all preliminary loading of libraries and data, transformations, subsetting

# ---
library(tidyverse)
library(tmap)
library(sf)
library(stars)
library(terra)
library(testthat)

# west coast exclusive economic zones
eez <- st_read(here::here('data', 'wc_regions_clean.shp'), quiet = TRUE)

# general bathymetric chart of the oceans
bathy <- rast(here::here('data', 'depth.tif'))

# sea surface temperature rasters from 2008 - 2012
sst <- c(rast(here::here('data', 'average_annual_sst_2008.tif')),
         rast(here::here('data', 'average_annual_sst_2009.tif')),
         rast(here::here('data', 'average_annual_sst_2010.tif')),
         rast(here::here('data', 'average_annual_sst_2011.tif')),
         rast(here::here('data', 'average_annual_sst_2012.tif')))

# transforming all crs to california albers
eez <- st_transform(eez, crs = 'epsg:4326')
crs(bathy) <- 'epsg:4326'
crs(sst) <- 'epsg:4326'
# ---

# processing data for function

# ---
# get mean of all sst rasters by cell
mean_sst <- mean(sst)

# convert average sst from kelvin to celsius
mean_sst_c <- mean_sst - 273.15

# crop depth raster to equal that of sst raster
# these don't match exactly, will this be a problem?
bathy_crop <- crop(bathy, mean_sst_c)

# resample bathymetry to match resolution of sst
bathy_resample <- resample(bathy_crop, mean_sst_c, method = 'near')
# ---

# creating generalized function
# ---
eez_map <- function(species, min_depth, max_depth, min_temp, max_temp) {
  
  # make bathymetry reclass matrix based on parameters
  bathy_reclass <- matrix(c(-Inf, min_depth, 0,
                            min_depth, max_depth, 1,
                            max_depth, Inf, 0), 
                          ncol = 3,
                          byrow = TRUE)
  
  # make sst reclass matrix based on parameters
  sst_reclass <- matrix(c(-Inf, min_temp, 0, 
                          min_temp, max_temp, 1, 
                          max_temp, Inf, 0), 
                        ncol = 3,
                        byrow = TRUE)
  
  # reclassify bathymetry for suitable habitat
  bathy_habitat <- classify(bathy_resample, bathy_reclass)
  
  # reclassify sst for suitable habitat
  sst_habitat <- classify(mean_sst_c, sst_reclass)
  
  # reclassify cells that are suitable for both sst and bathymetry
  suitability <- lapp(c(bathy_habitat, sst_habitat), fun = function(x, y){ ifelse(x == 1 & y == 1, 1, 0)})
  
  # change all 0 values to NA in suitability raster
  suitability[suitability == 0] <- NA
  
  # vectorizing suitable habitat raster
  suitability_vec <- suitability %>% 
    as.polygons() %>% 
    st_as_sf()
  
  # get all eez zones that intersect with suitable habitat
  suitable_eez <- eez %>% 
    st_filter(suitability_vec, .predicate = st_intersects)
  
  # template raster for rasterizing suitable eez
  eez_rast_template <- rast(ext(mean_sst_c),
                            resolution = res(mean_sst_c),
                            crs = crs(suitable_eez))
  
  # rasterizing suitable eez raster
  suitable_eez_rast <- terra::rasterize(suitable_eez, eez_rast_template, field = 'rgn_id')
  
  # get area per cell in suitability raster
  suitability_km <- cellSize(suitability,
                             mask = TRUE,
                             unit = 'km')
  
  # get total suitable area by suitable eez zone
  suitable_area <- zonal(suitability_km, 
                         vect(suitable_eez), 
                         fun = 'sum', 
                         na.rm = TRUE)
  
  # rename suitable area df 'area' col
  colnames(suitable_area) <- 'suitable_area'
  
  # attach suitable area calculations to respective eez
  eez_totals <- cbind(suitable_eez, suitable_area)
  
  # set osm variable
  osm <- tmaptools::read_osm(st_bbox(c(xmin = -140, 
                                       xmax = -106, 
                                       ymax = 50, 
                                       ymin = 29), 
                                     crs = st_crs(eez)), 
                             type = 'esri-topo')
  
  # create the map
  tm_shape(osm) + 
    tm_rgb() +
    tm_shape(eez_totals) +
    tm_polygons(col = 'suitable_area', 
                palette = 'Blues', 
                style = 'cat', 
                title = paste0('Area (km', common::supsc(2), ")"),
                lwd = 1.5) + 
    tm_layout(title = paste('Most Suitable Exclusive Economic Zones for', species), 
              asp = 1, 
              inner.margins = c(0.02,0.02,0.1,0.02), 
              legend.position = c(0.75, 0.6), 
              legend.frame = 'grey60',
              title.position = c(0.05, 'top')) + 
    tm_compass(size = 3, 
               type = '4star',
               position = c('left', 0.14)) + 
    tm_scale_bar(position = c('left', 0.08))
  
}
# ---