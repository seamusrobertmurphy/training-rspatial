# Builds the second calibration dataset for the chapter on fitting and
# validating a lidar model, from Quebec's permanent sample plot network under
# the province's open lidar canopy height models. Run this only when the source
# data changes; the book reads the committed output and never touches the
# network.
#
# Writes data/qc_lidar_plots.csv, one row per plot.
#
# The canopy height models are about 1 GB per map sheet, so nothing is
# downloaded whole. Each sheet is opened over HTTP and only the windows holding
# plots are read.

library(sf)
library(terra)

# Without the timeouts a single stalled read hangs the whole run, because the
# default is to wait indefinitely.
Sys.setenv(GDAL_DISABLE_READDIR_ON_OPEN = "YES", VSI_CACHE = "TRUE",
           GDAL_HTTP_MAX_RETRY = "3", GDAL_HTTP_RETRY_DELAY = "2",
           GDAL_HTTP_TIMEOUT = "60", GDAL_HTTP_CONNECTTIMEOUT = "20",
           CPL_VSIL_CURL_CHUNK_SIZE = "1048576")

cache <- "data-raw/cache/qc"
gpkg <- file.path(cache, "pep/PEP.gpkg")

# Placettes-échantillons permanentes, Ministère des Ressources naturelles et des
# Forêts du Québec, CC BY 4.0. Unpacked from PEP_GPKG.zip.
# https://www.donneesquebec.ca/recherche/dataset/placettes-echantillons-permanentes-1970-a-aujourd-hui
plots <- st_read(gpkg, "placette", quiet = TRUE)
mes <- st_read(gpkg, query = "SELECT id_pe, id_pe_mes, date_sond FROM placette_mes",
               quiet = TRUE)
mes$year <- as.integer(substr(as.character(mes$date_sond), 1, 4))

# Lidar acquisition footprints with their year, from the metadata shipped with
# the derived products, CC BY 4.0.
# https://www.donneesquebec.ca/recherche/dataset/produits-derives-de-base-du-lidar
acq <- st_read(list.files(file.path(cache, "meta"), pattern = "shp$",
                          full.names = TRUE, recursive = TRUE)[1], quiet = TRUE)

# Download links for the canopy height model of every 1:20 000 map sheet.
links <- read.csv(file.path(cache, "URL_Lidar.csv"), stringsAsFactors = FALSE)

plots <- plots[plots$in_gps == "O", ]
acq <- st_transform(acq, st_crs(plots))
plots <- st_join(plots, acq["AN_ACQ"], join = st_intersects, left = FALSE)

# Keep the measurement closest in time to the flight, and only where the two are
# within two years of each other, so the field and the laser describe one forest.
mes <- merge(mes, st_drop_geometry(plots)[, c("id_pe", "AN_ACQ")], by = "id_pe")
mes$AN_ACQ <- as.integer(as.character(mes$AN_ACQ))
mes$gap <- abs(mes$year - mes$AN_ACQ)
mes <- mes[order(mes$id_pe, mes$gap), ]
mes <- mes[!duplicated(mes$id_pe) & mes$gap <= 2, ]

plots <- merge(plots, mes[, c("id_pe", "id_pe_mes", "year", "gap")], by = "id_pe")
plots <- plots[plots$feuillet %in% links$Feuillet20K, ]

# Take the sheets holding the most plots, which keeps the reading local while
# still spreading the sample over several acquisitions.
counts <- sort(table(plots$feuillet), decreasing = TRUE)
sheets <- names(counts)[counts >= 8][1:14]
plots <- plots[plots$feuillet %in% sheets, ]

# Basal area per hectare from the tree table. Standing live stems only, which
# the dictionary's ETAT sheet codes 10 live standing, 30 missed live standing,
# 40 live recruit standing and 50 renumbered live standing. Each tree carries
# its own expansion factor in st_ha for the 400 square metre plot.
live <- "'10','30','40','50'"
trees <- st_read(gpkg, quiet = TRUE, query = sprintf(
  "SELECT id_pe_mes, SUM(st_ha) AS ba_ha, SUM(tige_ha) AS stems_ha,
          MAX(dhp) AS dhp_max, COUNT(*) AS n_trees
   FROM dendro_arbres WHERE etat IN (%s) GROUP BY id_pe_mes", live))

plots <- merge(plots, trees, by = "id_pe_mes")
plots <- plots[!is.na(plots$ba_ha) & plots$ba_ha > 0, ]

# Plot radius. A Quebec permanent plot is 400 square metres, which the tree
# table confirms through an expansion factor of 25 stems per hectare per tree.
radius <- sqrt(400 / pi)

# One plot at a time, each a crop of a few rows out of a sheet of 19 000 by
# 14 000 cells, so a stalled sheet costs one sheet rather than the run. Progress
# and partial results are written as they come.
log_file <- file.path(cache, "extract-log.txt")
part_file <- file.path(cache, "metrics-partial.csv")
write("sheet plots seconds", log_file)

metrics <- do.call(rbind, lapply(sheets, function(sheet) {
  started <- Sys.time()
  url <- links$MHC[match(sheet, links$Feuillet20K)]
  chm <- try(rast(paste0("/vsicurl/", url)), silent = TRUE)
  if (inherits(chm, "try-error")) return(NULL)
  here <- plots[plots$feuillet == sheet, ]
  buf <- st_buffer(st_transform(here, crs(chm)), radius)

  rows <- lapply(seq_len(nrow(buf)), function(i) {
    window <- try(crop(chm, ext(vect(buf[i, ]))), silent = TRUE)
    if (inherits(window, "try-error")) return(NULL)
    z <- try(terra::extract(window, vect(buf[i, ]))[[2]], silent = TRUE)
    if (inherits(z, "try-error") || all(is.na(z))) return(NULL)
    data.frame(id_pe_mes = buf$id_pe_mes[i],
               h_mean = mean(z, na.rm = TRUE),
               h_max = max(z, na.rm = TRUE),
               h_p95 = quantile(z, 0.95, na.rm = TRUE),
               h_sd = sd(z, na.rm = TRUE),
               cover = mean(z > 2, na.rm = TRUE))
  })

  out <- do.call(rbind, rows)
  write(paste(sheet, length(rows),
              round(as.numeric(difftime(Sys.time(), started, units = "secs")))),
        log_file, append = TRUE)
  if (!is.null(out)) {
    write.table(out, part_file, sep = ",", row.names = FALSE,
                col.names = !file.exists(part_file), append = file.exists(part_file))
  }
  out
}))

out <- merge(st_drop_geometry(plots), metrics, by = "id_pe_mes")
out$x <- st_coordinates(plots)[match(out$id_pe_mes, plots$id_pe_mes), 1]
out$y <- st_coordinates(plots)[match(out$id_pe_mes, plots$id_pe_mes), 2]
out <- out[, c("id_pe_mes", "feuillet", "x", "y", "latitude", "longitude",
               "year", "AN_ACQ", "gap", "n_trees", "stems_ha", "dhp_max",
               "ba_ha", "h_mean", "h_max", "h_p95", "h_sd", "cover")]
names(out)[names(out) == "year"] <- "census_year"
names(out)[names(out) == "AN_ACQ"] <- "lidar_year"
out <- out[complete.cases(out), ]

write.csv(out, "data/qc_lidar_plots.csv", row.names = FALSE)
cat(nrow(out), "plots written from", length(unique(out$feuillet)), "sheets\n")
