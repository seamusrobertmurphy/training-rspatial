# prepare-ipcc-strata.R
#
# Builds the three global layers an IPCC Tier 1 estimate stratifies on, which are
# climate region, ecological zone and soil type. Table 3.1 of the 2019 Refinement,
# Volume 4, Chapter 3 names climate and soil, and the ecological zone enters
# through Table 4.1 and Tables 4.7 to 4.10 of Chapter 4, which give biomass
# stocks and growth rates by ecological zone and continent.
#
# The layers are committed small so the book renders offline. The originals stay
# in the gitignored data-raw/cache/ and run to 4.3 GB unpacked.
#
# Sources, fetched and verified 8 September 2026.
#
# 1. Climate region. Lewis, M. (2022). IPCC Climate Zones (from the 2019
#    Refinement to the 2006 IPCC Guidelines for National Greenhouse Gas
#    Inventories). Zenodo. doi:10.5281/zenodo.7303808. CC BY 4.0. Half a degree,
#    twelve classes, built by running the Figure 3A.5.2 decision tree over CRU
#    TS3.25 monthly climate for 1985 to 2015 with ETOPO1 elevation.
#
#    This is a recreation and not the IPCC's own file. Its author states that he
#    could not find the published layer in spatial form, and lists where his
#    output differs from Figure 3A.5.1, in tropical wet against tropical moist in
#    South America, in tropical montane in Africa, and in boreal dry against polar
#    in northern Russia and Canada. The chapter says so where it uses the layer.
#
# 2. Ecological zone. FAO (2012). Global Ecological Zones for FAO Forest
#    Reporting, 2010 Update. FRA Working Paper 179, FAO, Rome. CC BY 4.0, from
#    the FAO map catalogue record 2fb209d0-fd34-4e5e-a3d8-a13c241eb61b. Twenty
#    zones plus water, supplied as a 96 MB shapefile of twenty-one multipolygons.
#    The 2010 update renamed tropical moist deciduous forest to tropical moist
#    forest, keeping the code TAwa, so the zone names differ from those in
#    Table 4.1 of the Guidelines while the codes match.
#
# 3. Soil type. Batjes, N.H. (2009). IPCC default soil classes derived from the
#    Harmonized World Soil Data Base. Report 2009/02, Carbon Benefits Project and
#    ISRIC, Wageningen, reissued as 2009/02b with the data set in November 2010.
#    Data set version 1.2, CC BY 3.0. The archive holds the HWSD mapping unit
#    raster at 30 arc-seconds and an Access database keying every mapping unit to
#    its dominant IPCC soil class. Class definitions are read from pages 4 to 6 of
#    the report, which gives the seven IPCC classes and keeps Salt Flats, Rock
#    Outcrops, Water Bodies and Land Ice as themselves. The lookup was last revised on 12 March 2021,
#    correcting 184 units where sand above 70 per cent and clay below 8 per cent
#    had not been coded sandy.
#
# Reading the Access database needs mdbtools, from sudo port install mdbtools.
#
# Run from the repository root with
#   Rscript data-raw/prepare-ipcc-strata.R

library(terra)
library(sf)

terraOptions(memfrac = 0.4)

cache <- "data-raw/cache"
dir.create(cache, showWarnings = FALSE, recursive = TRUE)

fetch <- function(url, dest) {
  if (!file.exists(dest)) download.file(url, dest, mode = "wb", quiet = FALSE)
  dest
}

# ---------------------------------------------------------------- climate ----

cz_tif <- fetch(paste0("https://zenodo.org/records/7303808/files/",
                       "IPCC_Climate_Zones_ts_3.25.tif?download=1"),
                file.path(cache, "IPCC_Climate_Zones_ts_3.25.tif"))

# Class order and colours are read off the author's own script, which builds the
# twelve layers in this order and plots them with these hex values. The .clr
# file in the same archive carries the identical colours as RGB triples.
cz_levels <- data.frame(
  id = 1:12,
  zone = c("Tropical montane", "Tropical wet", "Tropical moist", "Tropical dry",
           "Warm temperate moist", "Warm temperate dry",
           "Cool temperate moist", "Cool temperate dry",
           "Boreal moist", "Boreal dry",
           "Polar moist", "Polar dry"),
  colour = c("#6699cd", "#448970", "#89cd66", "#f5f57a",
             "#73dfff", "#ffd37f", "#cdf57a", "#c29ed7",
             "#9eaad7", "#d7d79e", "#d9ffe8", "#e1e1e1"))

cz <- rast(cz_tif)
names(cz) <- "climate_zone"
levels(cz) <- cz_levels[, c("id", "zone")]
coltab(cz) <- data.frame(value = cz_levels$id, col = cz_levels$colour)

writeRaster(cz, "data/ipcc_climate_zones.tif",
            datatype = "INT1U", overwrite = TRUE,
            gdal = c("COMPRESS=DEFLATE", "PREDICTOR=2"))
write.csv(cz_levels, "data/ipcc_climate_zones.csv", row.names = FALSE)

# ------------------------------------------------------------- ecological ----

gez_zip <- fetch(paste0("https://storage.googleapis.com/fao-maps-catalog-data/",
                        "uuid/2fb209d0-fd34-4e5e-a3d8-a13c241eb61b/resources/",
                        "gez2010.zip"),
                 file.path(cache, "gez2010.zip"))

gez_dir <- file.path(cache, "gez2010")
if (!file.exists(file.path(gez_dir, "gez_2010_wgs84.shp")))
  unzip(gez_zip, exdir = gez_dir)

gez <- vect(file.path(gez_dir, "gez_2010_wgs84.shp"))

# Rasterised at five arc-minutes. The zones are drawn at 1:1 million or coarser
# and their boundaries are climatic rather than surveyed, so a nine-kilometre
# cell loses nothing a Tier 1 lookup uses, and it turns 96 MB into 300 KB.
tmpl <- rast(ext(-180, 180, -90, 90), resolution = 1 / 12, crs = "EPSG:4326")
gz   <- rasterize(gez, tmpl, field = "gez_code")

gez_levels <- as.data.frame(gez)
gez_levels <- gez_levels[order(gez_levels$gez_code),
                         c("gez_code", "gez_name", "gez_abbrev")]
names(gez_levels) <- c("id", "zone", "abbrev")

# Hue carries the climate domain and lightness the zone within it, so that the
# five tropical zones read as one family rather than five unrelated classes.
# The FAO codes are blocked by domain already, 11 to 16 tropical, 21 to 25
# subtropical, 31 to 35 temperate, 41 to 43 boreal, 50 polar and 90 water.
ramp <- function(pal, n) hcl.colors(n + 2, pal)[1:n]
gez_levels$colour <- c(ramp("Greens 3", 6), ramp("Oranges", 5),
                       ramp("Blues 3", 5), ramp("Purples", 3),
                       "#e1e1e1", "#cfe8f3")

names(gz) <- "ecological_zone"
levels(gz) <- gez_levels[, c("id", "zone")]
coltab(gz) <- data.frame(value = gez_levels$id, col = gez_levels$colour)

writeRaster(gz, "data/fao_gez_2010.tif",
            datatype = "INT1U", overwrite = TRUE,
            gdal = c("COMPRESS=DEFLATE", "PREDICTOR=2"))
write.csv(gez_levels, "data/fao_gez_2010.csv", row.names = FALSE)

# ------------------------------------------------------------------ soil ----

soil_zip <- fetch(paste0("https://files.isric.org/public/other/",
                         "IPCC_default_soil_classes_derived_from_the_",
                         "Harmonized_World_Soil_Data_Base_version_1_2.zip"),
                  file.path(cache, "ipcc_soil_classes_hwsd12.zip"))

# Only these members are unpacked. The archive also holds a 1.4 GB ERDAS copy of
# the same grid, its pyramids, and a world boundary shapefile, none of which are
# needed here.
soil_dir <- file.path(cache, "ipcc_soil")
want <- c("CBP_GlobalIPCCsoilclassses.mdb", "ISRIC_Report_2009_02.pdf",
          "HWSD_raster/hwsd.bil", "HWSD_raster/hwsd.hdr",
          "HWSD_raster/hwsd.blw", "HWSD_raster/hwsd.bil.aux.xml")
absent <- want[!file.exists(file.path(soil_dir, want))]
if (length(absent)) unzip(soil_zip, files = absent, exdir = soil_dir)

lut_csv <- file.path(cache, "ipcc_soil_lookup.csv")
if (!file.exists(lut_csv))
  system2("mdb-export",
          c(shQuote(file.path(soil_dir, "CBP_GlobalIPCCsoilclassses.mdb")),
            "CBP_IPCCsolclas"), stdout = lut_csv)

lut <- read.csv(lut_csv)
stopifnot(!anyDuplicated(lut$MU_GLOBAL))

soil_levels <- data.frame(
  id = 1:12,
  code = c("HAC", "LAC", "SAN", "POD", "VOL", "WET", "ORG",
           "WR", "GG", "RK", "ST", "ND"),
  class = c("High activity clay", "Low activity clay", "Sandy", "Spodic",
            "Volcanic", "Wetland", "Organic",
            "Water body", "Land ice", "Rock outcrop", "Salt flat", "No data"),
  colour = c("#8c510a", "#bf812d", "#dfc27d", "#9970ab", "#d6604d",
             "#4393c3", "#053061",
             "#cfe8f3", "#f7f7f7", "#969696", "#fddbc7", "#d9d9d9"))

lut$id <- match(lut$DOM_IPCCsoilclass, soil_levels$code)
lut <- lut[!is.na(lut$id), ]

hwsd <- rast(file.path(soil_dir, "HWSD_raster", "hwsd.bil"))
crs(hwsd) <- "EPSG:4326"

soil30 <- subst(hwsd, from = lut$MU_GLOBAL, to = lut$id, others = NA,
                filename = file.path(cache, "ipcc_soil_30s.tif"),
                datatype = "INT1U", overwrite = TRUE,
                gdal = c("COMPRESS=DEFLATE", "PREDICTOR=2"))

# Onto the same five arc-minute grid as the ecological zones, by majority. The
# 30 arc-second original stays in the cache; the chapter reads the fine grid
# only over its own basin, which is committed below.
soil5 <- aggregate(soil30, fact = 10, fun = "modal", na.rm = TRUE)
soil5 <- as.int(soil5)

names(soil5) <- "soil_class"
levels(soil5) <- soil_levels[, c("id", "class")]
coltab(soil5) <- data.frame(value = soil_levels$id, col = soil_levels$colour)

writeRaster(soil5, "data/ipcc_soil_classes.tif",
            datatype = "INT1U", overwrite = TRUE,
            gdal = c("COMPRESS=DEFLATE", "PREDICTOR=2"))
write.csv(soil_levels, "data/ipcc_soil_classes.csv", row.names = FALSE)

# The Chilwa window at the full 30 arc-seconds, so the chapter can show what the
# majority rule threw away when the global layer was coarsened.
basin  <- st_read("data/chilwa_hydro.gpkg", layer = "basin", quiet = TRUE)
window <- ext(vect(st_transform(basin, 4326))) + 0.25

chilwa_soil <- crop(soil30, window)
levels(chilwa_soil) <- soil_levels[, c("id", "class")]
coltab(chilwa_soil) <- data.frame(value = soil_levels$id, col = soil_levels$colour)

writeRaster(chilwa_soil, "data/chilwa_ipcc_soil.tif",
            datatype = "INT1U", overwrite = TRUE,
            gdal = c("COMPRESS=DEFLATE", "PREDICTOR=2"))

cat("\nWritten:\n")
print(file.info(c("data/ipcc_climate_zones.tif", "data/ipcc_climate_zones.csv",
                  "data/fao_gez_2010.tif", "data/fao_gez_2010.csv",
                  "data/ipcc_soil_classes.tif", "data/ipcc_soil_classes.csv",
                  "data/chilwa_ipcc_soil.tif"))["size"])
