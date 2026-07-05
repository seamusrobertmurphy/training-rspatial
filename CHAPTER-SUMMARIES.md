# Chapter summaries — foundational geospatial data science in R

Foundations-first course: the standard geospatial data science curriculum is the backbone; the applied forest/carbon/ecology work appears only as supplementary *(Applied)* exercises. 16 numbered chapters in 4 parts, forest inventory as the running teaching dataset. One headline + exercise scope per chapter.

---

## Part I — Spatial data

**1. Spatial R Basics.** Reproducible R projects, the `sf`/`terra` toolkit, reading the data, a first map; a note on field-data provenance.
*Exercises:* summaries by stand type; largest trees; per-tree carbon; map by stand type.

**2. Spatial Data Models.** Vector vs raster models and when to use each.
*Exercises:* bbox area; build a UTM raster; classify phenomena; stack layers.

**3. Geometries.** The simple-features standard: the seven geometry types, WKT/WKB, dimensions (XYZ/M), and validity. *(Applied: LiDAR XYZ points.)*
*Exercises:* build each type; polygon with a hole; WKT round-trip; XYZ tree tops.

**4. Coordinate Reference Systems.** Geographic vs projected CRS, datums, `st_transform`, and measuring in metric units.
*Exercises:* reproject and compare; set-vs-transform; buffer area; explain equal-area.

**5. Spherical Geometry.** Planar vs geodesic computation and the S2 engine that `sf` uses for lon/lat.
*Exercises:* geodesic vs planar distance; box area two ways; continental extent; great circles.

## Part II — Attributes and operations

**6. Vector Data.** Reading/writing formats, `sf` anatomy, `dplyr` on spatial data, attribute joins.
*Exercises:* format round-trip; join species counts; QMD; CSV export.

**7. Attributes and Support.** The attribute–geometry relationship: support, extensive vs intensive attributes, correct aggregation, change of support. *(Applied: stand-table totals.)*
*Exercises:* classify columns; correct vs wrong aggregation; support and uncertainty; density→total.

**8. Spatial Operations.** Buffers, overlays (intersection/union/difference), predicates, spatial joins, nearest-feature. *(Applied: boundary overlap reconciliation.)*
*Exercises:* buffer area; carbon by block; point-in-polygon counts; distance to edge; area de-duplication.

**9. Raster Data.** A real DEM, map algebra, terrain and hillshade, crop/mask/resample. *(Applied: canopy height model.)*
*Exercises:* relief stats; slope classes; hillshade overlay; resample effect; CHM from DSM−DTM.

**10. Raster Extraction.** Covariate stacks and point/buffered extraction to the plots.
*Exercises:* covariate correlations; point vs buffer; aspect classes; save the table.

**11. Data Cubes.** The array/cube data model (x, y, band, time); building a raster time series, per-pixel trends, and change detection. *(Applied: supervised disturbance classification.)*
*Exercises:* undisturbed pixel; threshold trade-off; scene-mean trajectory; real Sentinel-2 swap; classification workflow.

## Part III — Visualisation

**12. Cartography.** Thematic maps in `tmap` (classification, furniture, interactive) and `ggplot2` `geom_sf` with facets.
*Exercises:* classification schemes; two-variable map; satellite basemap; faceting.

## Part IV — Spatial statistics

**13. Point Patterns.** CSR, intensity, clustering, and Ripley's K with `spatstat`. *(Applied: distinguishing clustered clearings.)*
*Exercises:* CSR test; nearest-neighbour ordering; intensity map; K for illegal-harvest fronts.

**14. Interpolation and Geostatistics.** IDW, the variogram, ordinary kriging with its error map, cross-validation. *(Applied: allometric Monte Carlo uncertainty.)*
*Exercises:* variogram models; log transform; IDW vs kriging; grid resolution; combined uncertainty.

**15. Areal Data.** Neighbour graphs, Moran's I, and local hot-spot detection with `spdep`.
*Exercises:* neighbour definition; compare variables; significant hot spots.

**16. Spatial Regression.** Regress a response on covariates, predict a surface, cross-validate, and account for residual autocorrelation with spatial lag/error models. *(Applied: enhanced-forest-inventory ensemble.)*
*Exercises:* northness; random forest; residual Moran's I + spatial lag; EFI ensemble sketch.

---

## Where the applied (supplementary) work now lives

Your domain expertise is dissolved into the *(Applied)* exercises above rather than standalone chapters: **LiDAR** (Geometries, Raster Data), **allometry & Monte Carlo** (Geostatistics), **carbon accounting** (Attributes and Support), **MRV / area checks** (Spatial Operations), **disturbance classification** (Data Cubes), and **enhanced forest inventory** (Spatial Regression). The fuller worked treatments from your repos remain available to promote back into a dedicated "Applications" appendix later if you want them.

## Candidate future additions (revision workplan)

Wetland/SAR mapping · growth-and-yield (FVS) · landscape pattern metrics · jurisdictional REDD+ case studies · FAOSTAT data access · QGIS no-code appendix · SOP/reproducibility appendix.
