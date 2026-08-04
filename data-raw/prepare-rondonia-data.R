# Extract the Rondonia land-cover material used by the raster chapter from the
# sitsdata package into data/. Run this only when the source data changes; the
# book reads the committed files and needs neither sitsdata nor sits to build.
#
# Source: sitsdata 1.3 (https://github.com/e-sensing/sitsdata), which ships the
# outputs of a sits Sentinel-2 classification of Rondonia, Brazil, for 2022.
#   extdata/Rondonia-20LMR/            one 24 km window, 23 dates, 13 bands
#   extdata/Rondonia-Class-2022-Mosaic/ the 9-class map and its validation sample
#
# Two things about the source are worth recording.
#
# The NDVI rasters store the index multiplied by 10,000 as signed integers, so
# the chapter divides by 1e4 to recover the conventional -1 to 1 range.
#
# The shipped validation CSV carries a `class_n` column that disagrees with the
# raster's own legend in `rondonia_2022.qml`: Mountainside_Forest is coded 4
# rather than 3, and Wetland and Seasonally_Flooded are swapped. The QML is
# authoritative for the raster it styles, and extracting map values at the
# validation points against it gives 83 per cent agreement with a clean
# diagonal, which would collapse if the legend were wrong. So this script joins
# on the `label` text and discards `class_n`.

library(terra)

sd_path <- function(...) system.file(..., package = "sitsdata")

# The legend, transcribed from the paletteEntry elements of rondonia_2022.qml.
legend <- data.frame(
  id     = 1:9,
  label  = c("Clear_Cut_Bare_Soil", "Clear_Cut_Burned_Area", "Mountainside_Forest",
             "Forest", "Riparian_Forest", "Clear_Cut_Vegetation", "Water",
             "Seasonally_Flooded", "Wetland"),
  cover  = c("Clear cut, bare soil", "Clear cut, burned", "Mountainside forest",
             "Forest", "Riparian forest", "Clear cut, regrowth", "Water",
             "Seasonally flooded", "Wetland"),
  colour = c("#D7C49C", "#EC7063", "#229C59", "#1E8449", "#00B29E",
             "#D8DA83", "#2980B9", "#3ABABA", "#A0B9C8"),
  forest = c(FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE))

write.csv(legend, "data/rondonia_legend.csv", row.names = FALSE)

# The 9-class map for the whole state, recompressed from 38.5 MB to about 19.
mosaic <- rast(sd_path("extdata/Rondonia-Class-2022-Mosaic",
                       "SENTINEL-2_MSI_MOSAIC_2022-01-05_2022-12-23_class_mosaic.tif"))
writeRaster(mosaic, "data/rondonia_class_2022.tif", overwrite = TRUE,
            datatype = "INT1U",
            gdal = c("COMPRESS=DEFLATE", "PREDICTOR=2", "ZLEVEL=9",
                     "TILED=YES", "NUM_THREADS=ALL_CPUS"))

# One real Sentinel-2 NDVI composite over the 20LMR window, for the imagery step.
ndvi <- rast(sd_path("extdata/Rondonia-20LMR",
                     "SENTINEL-2_MSI_20LMR_NDVI_2022-07-16.tif"))
writeRaster(ndvi, "data/rondonia_ndvi_2022-07-16.tif", overwrite = TRUE,
            datatype = "INT2S",
            gdal = c("COMPRESS=DEFLATE", "PREDICTOR=2", "ZLEVEL=9", "TILED=YES"))

# The validation sample, joined to the legend on label text.
val <- read.csv(sd_path("extdata/Rondonia-Class-2022-Mosaic",
                        "rondonia_samples_validation.csv"))
val$cover <- legend$cover[match(val$label, legend$label)]
stopifnot(!anyNA(val$cover))

write.csv(val[, c("id", "cover", "longitude", "latitude")],
          "data/rondonia_validation.csv", row.names = FALSE)

cat("wrote", nrow(val), "validation points and",
    nrow(legend), "legend classes\n")
