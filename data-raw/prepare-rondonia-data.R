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

# ---------------------------------------------------------------------------
# Multi-band Sentinel-2 surface reflectance over the same 20LMR window, added
# 5 September 2026 for the optical chapter, which needs the bands an index is
# built from and not only the finished index.
#
# Two dates, both Level 2A surface reflectance, both stored as signed integers
# scaled by 10,000 exactly as the NDVI is.
#
#   2022-07-16  the clear dry-season reference date the committed NDVI is from
#   2022-09-02  the same ground under biomass-burning smoke, which raises the
#               blue band 3.6-fold while leaving the near infrared almost
#               unchanged, so every index built on the visible bands moves
#               without anything happening on the ground
#
# Ten bands are kept and the three sits ships as finished indices are not, since
# the chapter computes those itself. Band centres and native ground sample
# distances follow the Sentinel-2 MSI specification and are written to
# data/sentinel2_bands.csv so the chapter can state support rather than assert
# it. The 20 m grid here is the sits harmonisation, not the native resolution.

s2_bands <- c("B02", "B03", "B04", "B05", "B06", "B07", "B08", "B8A", "B11", "B12")

s2_dates <- c("2022-07-16", "2022-09-02")

for (d in s2_dates) {
  files <- sd_path("extdata/Rondonia-20LMR",
                   sprintf("SENTINEL-2_MSI_20LMR_%s_%s.tif", s2_bands, d))
  stopifnot(all(file.exists(files)))
  stack <- rast(files)
  names(stack) <- s2_bands
  out <- sprintf("data/rondonia_s2_%s.tif", d)
  writeRaster(stack, out, overwrite = TRUE, datatype = "INT2S",
              gdal = c("COMPRESS=DEFLATE", "PREDICTOR=2", "ZLEVEL=9",
                       "TILED=YES", "NUM_THREADS=ALL_CPUS"))
  cat("wrote", out, round(file.size(out) / 1e6, 1), "MB\n")
}

# Band metadata. Centre wavelength and full width at half maximum were read on
# 5 September 2026 from the Microsoft Planetary Computer STAC collection
# description for sentinel-2-l2a, field eo:bands, which serves the ESA MSI
# values in micrometres and is converted to nanometres here. gsd_m is the native
# ground sample distance of the band, which is not the 20 m grid these files sit
# on: sits resampled every band to a common 20 m raster, so the 10 m bands were
# coarsened and nothing was sharpened.
bands <- data.frame(
  band      = s2_bands,
  name      = c("Blue", "Green", "Red", "Red edge 1", "Red edge 2",
                "Red edge 3", "NIR", "NIR narrow", "SWIR 1", "SWIR 2"),
  centre_nm = c(490, 560, 665, 704, 740, 783, 842, 865, 1610, 2190),
  fwhm_nm   = c(98, 45, 38, 19, 18, 28, 145, 33, 143, 242),
  gsd_m     = c(10, 10, 10, 20, 20, 20, 10, 20, 20, 20))

write.csv(bands, "data/sentinel2_bands.csv", row.names = FALSE)

cat("wrote data/sentinel2_bands.csv,", nrow(bands), "bands\n")
