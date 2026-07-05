# setup.R — install every package the course uses. Run once.
#
#   source("setup.R")
#
# Notes:
#  - sf, terra and gstat depend on the system libraries GDAL, GEOS and PROJ.
#    On macOS these come with the CRAN binary packages; on Linux you may need
#    to install libgdal-dev, libgeos-dev and libproj-dev first.
#  - Chapters 6, 7 and 11 download a real elevation model (elevatr) and need
#    an internet connection; Chapter 12 runs offline on a simulated cube.

pkgs <- c(
  "sf", "terra", "dplyr", "tidyverse",   # core spatial + data wrangling
  "tmap", "ggplot2",                      # cartography and graphics
  "gstat", "spdep",                       # geostatistics and autocorrelation
  "elevatr", "rnaturalearth",             # open terrain and boundaries
  "car",                                  # variance inflation factors (Ch 11)
  "MODISTools",                           # real NDVI time series (Ch 12, optional)
  "ranger", "spatstat",                   # used in the exercises
  "spatstat", "spatialreg",               # point patterns, spatial regression
  "lidR", "ForestTools", "RCSF",          # optional: applied LiDAR exercises
  "caret", "randomForest"                 # optional: applied classification exercises
)

to_install <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(to_install)) {
  message("Installing: ", paste(to_install, collapse = ", "))
  install.packages(to_install)
} else {
  message("All course packages are already installed.")
}

# Confirm everything loads
loaded <- vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)
if (all(loaded)) {
  message("Setup complete: all ", length(pkgs), " packages available.")
} else {
  warning("Not available: ", paste(pkgs[!loaded], collapse = ", "))
}
