# Build the Lake Chilwa terrain and hydrology data used by the terrain chapter.
# Run this only when the source data changes; the book reads the committed files
# and needs no network to build.
#
# The area of interest is the one used throughout the author's map-templates
# ebook (https://seamusrobertmurphy.quarto.pub/map-templates/): Lake Chilwa in
# southern Malawi, a shallow endorheic lake whose area swings by a factor of
# several between wet and dry years, and which dried out entirely in 1968, 1995
# and 2012. It is the reference case for wetland inundation mapping in this
# book, and its closed drainage makes it a hard test of watershed delineation.
#
# Two sources.
#
# The hydrography is HydroSHEDS v1.0: the lake from HydroLAKES, the catchment
# from HydroBASINS level 12 with lakes, the channels from HydroRIVERS. Those
# global archives are 1 to 3 GB each, so this script reads the Chilwa subsets
# already clipped in the map-templates repository rather than re-downloading
# them. Set MAP_TEMPLATES to wherever that repository sits.
#
# The elevation is the AWS Terrain Tiles mosaic reached through elevatr. Zoom 10
# returns roughly 5-arc-second cells at this latitude, which resample cleanly to
# a 100 m grid: at 100 m each cell is exactly one hectare, so flow accumulation
# counts convert to contributing area by multiplying by 0.01 to get square
# kilometres. That identity is used in the chapter's prose.
#
# Three traps are worth recording.
#
# The DEM is stored as signed 16-bit integers. Elevation over the basin runs
# from about 570 m to about 1,700 m, so nothing is lost, and the file drops from
# roughly 12 MB to under 4. Hydraulic conditioning outputs are floating point
# and are regenerated at render time, not committed.
#
# EPSG:3857 is not an equal-area projection. At 15 degrees south its scale
# factor is about 1.035, so a nominal 100 m cell covers about 93 m of ground and
# any area read straight off the 3857 grid is inflated by about 7 per cent. The
# chapter states areas in EPSG:32736 (UTM zone 36S) for that reason, and keeps
# 3857 only for the raster grid, matching the map-templates workflow.
#
# The lake polygon is the HydroLAKES maximum extent, not the surface on any
# given date. Comparing it against a DEM threshold therefore compares a
# long-run maximum against an instantaneous stage, which is the point of the
# rating curve in the chapter but would be an error if read as validation.

library(sf)
library(terra)
library(elevatr)
library(stars)

sf_use_s2(FALSE)

MAP_TEMPLATES <- "/Volumes/PortableSSD/Github/training/map-templates"
crs_master    <- st_crs("EPSG:3857")

src <- function(f) file.path(MAP_TEMPLATES, "assets/inputs", f)

# --- Hydrography ------------------------------------------------------------

lake <- st_read(src("lakes_site.shp"), quiet = TRUE) |>
  st_transform(crs_master) |>
  subset(select = c(Lake_name, Lake_area, Shore_len, Depth_avg, Wshd_area))

basin <- st_read(src("chilwa_watershed_4326.shp"), quiet = TRUE) |>
  st_transform(crs_master) |>
  subset(select = c(HYBAS_ID, SUB_AREA, UP_AREA, ENDO))

rivers <- st_read(src("rivers_site.shp"), quiet = TRUE) |>
  st_transform(crs_master) |>
  subset(select = c(HYRIV_ID, LENGTH_KM, UPLAND_SKM, ORD_STRA, ORD_FLOW))

dst <- "data/chilwa_hydro.gpkg"
if (file.exists(dst)) file.remove(dst)
st_write(lake,   dst, layer = "lake",   quiet = TRUE)
st_write(basin,  dst, layer = "basin",  quiet = TRUE, append = TRUE)
st_write(rivers, dst, layer = "rivers", quiet = TRUE, append = TRUE)

# --- Elevation --------------------------------------------------------------

# Sixty kilometres of margin around the lake, so the catchment divide falls
# inside the grid and delineation is not simply reading back its own boundary.
bbox <- lake |>
  st_buffer(dist = 60000) |>
  st_bbox() |>
  st_as_sfc() |>
  st_sf()

dem <- get_elev_raster(bbox, z = 10, clip = "locations") |> rast()
names(dem) <- "elevation"

dem_100m <- st_warp(st_as_stars(dem), cellsize = 100, crs = crs_master) |>
  rast()
names(dem_100m) <- "elevation"

writeRaster(dem_100m, "data/chilwa_dem.tif", overwrite = TRUE,
            datatype = "INT2S", gdal = c("COMPRESS=DEFLATE", "PREDICTOR=2"))

# --- Report -----------------------------------------------------------------

d <- rast("data/chilwa_dem.tif")
cat("DEM      ", ncol(d), "x", nrow(d), "cells at", res(d)[1], "m\n")
cat("elevation", paste(round(unlist(global(d, range, na.rm = TRUE))), collapse = " to "), "m\n")
cat("file     ", round(file.size("data/chilwa_dem.tif") / 1e6, 1), "MB\n")
cat("lake     ", round(as.numeric(st_area(st_transform(lake, 32736))) / 1e6, 1), "km2\n")
cat("basin    ", round(as.numeric(st_area(st_transform(basin, 32736))) / 1e6, 1), "km2\n")
cat("rivers   ", nrow(rivers), "reaches\n")
