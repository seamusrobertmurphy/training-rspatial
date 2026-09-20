# Builds the lidar side of the calibration chapter over the Smithsonian
# Conservation Biology Institute ForestGEO plot, and the field side from the 2018
# census of the same ground. Run this only when the source data changes; the book
# reads the committed outputs and never touches the network.
#
# Writes:
#   data/scbi_chm_2020.tif          1 m canopy height model over the plot
#   data/scbi_lidar_plots.csv       lidar metrics and field reference per subplot
#
# The lidar is two years after the census, which the chapter states.

library(lidR)
library(sf)
library(terra)

cache <- "data-raw/cache/scbi-lidar"
dir.create(cache, recursive = TRUE, showWarnings = FALSE)
options(timeout = 3600)   # the tiles are about 105 MB each

# SCBI ForestGEO stem map, 2008 census, committed by prepare-scbi-data.R
# https://github.com/SCBI-ForestGEO/SCBI-ForestGEO-Data
stems <- st_read("data/scbi_stems.shp", quiet = TRUE)
aoi <- st_transform(st_as_sfc(st_bbox(stems)), 32617)
aoi_buf <- st_buffer(aoi, 40)

# USGS 3DEP Lidar Point Cloud, project VA_NShenandoah_1_2020, flown 2020, public
# domain. The whole project runs to 38.7 billion points, so only the plot window
# is read, through the cloud-optimised Entwine index on the public AWS bucket.
# https://www.usgs.gov/3d-elevation-program
# https://registry.opendata.aws/usgs-lidar/
# Needs the MacPorts pdal port; the index is published in EPSG:3857.
laz <- file.path(cache, "scbi_plot.laz")
if (!file.exists(laz)) {
  b <- st_bbox(st_transform(aoi_buf, 3857))
  pipeline <- sprintf('{"pipeline":[
    {"type":"readers.ept",
     "filename":"https://s3-us-west-2.amazonaws.com/usgs-lidar-public/VA_NShenandoah_1_2020/ept.json",
     "bounds":"([%f,%f],[%f,%f])"},
    {"type":"filters.reprojection","out_srs":"EPSG:32617"},
    {"type":"writers.las","compression":"laszip","a_srs":"EPSG:32617","filename":"%s"}]}',
    b["xmin"], b["xmax"], b["ymin"], b["ymax"], laz)
  json <- tempfile(fileext = ".json")
  writeLines(pipeline, json)
  system2("pdal", c("pipeline", json))
}

las <- readLAS(laz, filter = "-drop_class 7 18")
las <- normalize_height(las, tin())
chm <- rasterize_canopy(las, res = 1, algorithm = p2r(subcircle = 0.15))
chm <- mask(crop(chm, vect(aoi)), vect(aoi))
writeRaster(chm, "data/scbi_chm_2020.tif", overwrite = TRUE,
            gdal = c("COMPRESS=DEFLATE", "PREDICTOR=3"))

# SCBI ForestGEO stem table, 2018 census, the census nearest the 2020 flight
# https://github.com/SCBI-ForestGEO/SCBI-ForestGEO-Data
#   tree_main_census/data/census-csv-files/scbi.stem3.csv
census <- read.csv(paste0(
  "https://raw.githubusercontent.com/SCBI-ForestGEO/SCBI-ForestGEO-Data/",
  "master/tree_main_census/data/census-csv-files/scbi.stem3.csv"
), stringsAsFactors = FALSE, na.strings = c("NA", "NULL", ""))

# Diameters arrive in millimetres, and the census writes missing ones as NULL,
# so the column reads back as text unless those are declared missing above.
census$dbh <- as.numeric(census$dbh)
census$gx <- as.numeric(census$gx)
census$gy <- as.numeric(census$gy)

census <- census[census$status == "A" & !is.na(census$dbh) & census$dbh >= 100, ]
census$dbh_cm <- census$dbh / 10                      # census stores millimetres
census$ba <- pi * (census$dbh_cm / 200)^2             # basal area, square metres

# Basal area is the response, as in chapter 6, because it is measured rather
# than modelled. Converting a diameter into mass belongs to the allometry
# chapter and no biomass column is written here.

# Subplots are the census's own 20 by 20 metre quadrats, which is the support the
# field crew worked at and the support the chapter calibrates on.
census$qx <- floor(census$gx / 20) * 20
census$qy <- floor(census$gy / 20) * 20
keep <- census$qx >= 0 & census$qx < 400 & census$qy >= 0 & census$qy < 640
census <- census[keep & !is.na(census$gx), ]

field <- aggregate(ba ~ qx + qy, data = census, FUN = sum)
names(field)[3] <- "ba_m2"
field$ba_ha <- field$ba_m2 / 0.04                     # 20 by 20 m is 0.04 ha
field$stems <- aggregate(dbh ~ qx + qy, data = census, FUN = length)$dbh

# The census grid runs about 1.8 degrees off UTM north, so quadrat corners are
# placed by rotating the local grid onto the surveyed stem positions rather than
# by assuming axis-aligned cells.
grid <- data.frame(gx = stems$gx, gy = stems$gy,
                   X = st_coordinates(st_transform(stems, 32617))[, 1],
                   Y = st_coordinates(st_transform(stems, 32617))[, 2])
fit_x <- lm(X ~ gx + gy, data = grid)
fit_y <- lm(Y ~ gx + gy, data = grid)
corner <- function(gx, gy) {
  nd <- data.frame(gx = gx, gy = gy)
  cbind(predict(fit_x, nd), predict(fit_y, nd))
}

quads <- lapply(seq_len(nrow(field)), function(i) {
  g <- field[i, ]
  p <- corner(c(g$qx, g$qx + 20, g$qx + 20, g$qx, g$qx),
              c(g$qy, g$qy, g$qy + 20, g$qy + 20, g$qy))
  st_polygon(list(unname(p)))
})
quads <- st_sf(field, geometry = st_sfc(quads, crs = 32617))

metrics <- terra::extract(chm, vect(quads), fun = NULL, ID = TRUE)
names(metrics)[2] <- "z"
agg <- function(f) tapply(metrics$z, metrics$ID, f)
quads$h_mean <- as.numeric(agg(function(z) mean(z, na.rm = TRUE)))
quads$h_max <- as.numeric(agg(function(z) max(z, na.rm = TRUE)))
quads$h_p95 <- as.numeric(agg(function(z) quantile(z, 0.95, na.rm = TRUE)))
quads$h_sd <- as.numeric(agg(function(z) sd(z, na.rm = TRUE)))
quads$cover <- as.numeric(agg(function(z) mean(z > 2, na.rm = TRUE)))

out <- st_drop_geometry(quads)
out$x <- st_coordinates(st_centroid(quads))[, 1]
out$y <- st_coordinates(st_centroid(quads))[, 2]
out <- out[, c("qx", "qy", "x", "y", "stems", "ba_ha",
               "h_mean", "h_max", "h_p95", "h_sd", "cover")]
write.csv(out, "data/scbi_lidar_plots.csv", row.names = FALSE)

cat(nrow(out), "subplots written\n")
