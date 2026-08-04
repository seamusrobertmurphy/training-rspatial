# Rebuild data/scbi_stems.csv and data/scbi_stem1.csv from the SCBI ForestGEO
# census. Run this only when the source data changes; the book itself reads the
# committed CSVs and never touches the network.
#
# Source: https://github.com/SCBI-ForestGEO/SCBI-ForestGEO-Data
#   tree_main_census/data/census-csv-files/scbi.stem1.csv     (2008 census)
#   tree_main_census/data/census-csv-files/scbi.spptable.csv
#
# Two things the previous version of these files got wrong, both fixed here:
#   1. Stem positions were uniform random over the plot rather than the surveyed
#      gx/gy, so every map built from them showed noise instead of forest.
#   2. Only 2,287 of the 38,517 living stems were kept, giving 89 stems per
#      hectare where the plot carries about 1,500.
#
# Diameters arrive in millimetres and are converted to centimetres.

library(sf)

base <- "https://raw.githubusercontent.com/SCBI-ForestGEO/SCBI-ForestGEO-Data/master/tree_main_census/data/census-csv-files"

raw <- read.csv(file.path(base, "scbi.stem1.csv"), stringsAsFactors = FALSE)
spp <- read.csv(file.path(base, "scbi.spptable.csv"), stringsAsFactors = FALSE)

for (v in c("dbh", "gx", "gy")) raw[[v]] <- suppressWarnings(as.numeric(raw[[v]]))

stems <- raw[raw$status == "A" &
             !is.na(raw$dbh) & !is.na(raw$gx) & !is.na(raw$gy), ]
stems$dbh <- stems$dbh / 10                       # millimetres to centimetres

stems <- merge(stems, spp[, c("sp", "Genus", "Species", "Family")],
               by = "sp", all.x = TRUE)

# The plot grid sits about 1.8 degrees off UTM north. This affine map carries
# local plot metres to UTM 17N and reproduces the georeferencing the book has
# always used.
easting  <- 747576.842908 + 1.001149 * stems$gx - 0.031246 * stems$gy
northing <- 4308832.00    + 0.031381 * stems$gx + 0.997105 * stems$gy

ll <- st_as_sf(data.frame(easting, northing), coords = c("easting", "northing"),
               crs = 32617) |>
  st_transform(4326) |>
  st_coordinates()

out <- data.frame(
  treeID  = stems$treeID,
  stemID  = stems$stemID,
  dbh     = round(stems$dbh, 1),
  genus   = stems$Genus,
  species = stems$Species,
  family  = stems$Family,
  gx      = stems$gx,
  gy      = stems$gy,
  lon     = round(ll[, 1], 6),
  lat     = round(ll[, 2], 6))

out <- out[order(out$treeID, out$stemID), ]
write.csv(out, "data/scbi_stems.csv", row.names = FALSE)

# The allometry chapter reads the same stems without coordinates.
write.csv(out[, c("treeID", "stemID", "dbh", "genus", "species", "family")],
          "data/scbi_stem1.csv", row.names = FALSE)

# The shapefile companion used in the getting-started chapter.
st_write(st_as_sf(out, coords = c("lon", "lat"), crs = 4326),
         "data/scbi_stems.shp", delete_dsn = TRUE, quiet = TRUE)

cat("wrote", nrow(out), "stems;",
    round(nrow(out) / 25.6), "per hectare\n")
