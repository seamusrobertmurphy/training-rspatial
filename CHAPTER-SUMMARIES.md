# Chapter summaries — *Spatial Data Analysis in R for Forest Carbon*

Quick-review index: one headline and the exercise scope per chapter. 18 chapters, 7 parts. Repos each chapter draws from are noted in *italics*.

---

## Part I — Foundations

**1. R for Spatial Work.** Reproducible R projects and the `sf`/`terra`/`tmap` toolkit; reading the inventory and drawing a first map; a note on field-data provenance (GPS accuracy, digital survey forms). *GPS-training-material, survey-tools.*
*Exercises:* summary stats by stand type; largest trees; per-tree carbon; map by stand type.

**2. Spatial Data Models.** Vector vs raster models, `sf` simple features and `terra` grids, and when to use each.
*Exercises:* bbox area; build a UTM raster; classify phenomena as vector/raster; stack raster layers.

**3. Coordinate Reference Systems.** Geographic vs projected CRS, EPSG codes, `st_transform`, BC Albers, and measuring in metric units.
*Exercises:* reproject and compare bboxes; set-vs-transform a CRS; buffer area in hectares; explain equal-area.

## Part II — Vector data

**4. Vector Data with sf.** Read/write formats, the anatomy of an `sf` object, `dplyr` on spatial data, attribute joins to tree summaries, GeoPackage output.
*Exercises:* format round-trip; join species counts; quadratic mean diameter; CSV export.

**5. Geometric Operations and Spatial Joins.** Buffers, intersection/union/difference, spatial predicates, `st_join` to management blocks, nearest-feature.
*Exercises:* buffer area; carbon by block; plot counts by block; distance to block edge.

## Part III — Raster data

**6. Raster Data with terra.** A real downloaded DEM, map algebra and reclassification, terrain and hillshade, crop/mask/resample.
*Exercises:* relief stats; slope classes; hillshade overlay; resample effect.

**7. Extracting Rasters to Field Plots.** Building a covariate stack and extracting terrain to plots (point vs buffered) to make the analysis table.
*Exercises:* covariate correlations; point vs buffer; aspect classes; save the covariate table.

## Part IV — LiDAR and forest structure

**14. LiDAR for Forest Structure.** Point clouds, CSF ground classification, SOR denoising, DTM, pit-free CHM, variable-window tree detection, and area-based metrics linked to carbon. *lidar-forestry (+ gisborne, la-ronge, ash-dieback methods).*
*Exercises:* point density; CSF vs PMF DTM; fixed vs variable window; p95 height → carbon steps.

## Part V — Analysis and modelling

**8. Cartography.** Thematic maps in `tmap` (classification schemes, scale bar/north arrow, interactive) and `ggplot2` `geom_sf` with facets. *map-templates.*
*Exercises:* classification schemes; two-variable map; satellite basemap; faceting by elevation.

**9. Spatial Autocorrelation and Point Patterns.** Neighbour graphs, Moran's I, local hot spots, and complete-spatial-randomness.
*Exercises:* neighbour definition; compare forest variables; significant hot spots; regular pattern.

**10. Interpolation and Geostatistics.** IDW, the variogram, ordinary kriging with its standard-error map, and cross-validation.
*Exercises:* variogram models; log transform; IDW vs kriging; grid resolution.

**11. Spatial Modelling and Prediction.** Regress carbon on terrain, predict a surface, cross-validate, regression kriging, and an Enhanced Forest Inventory ensemble section. *enhanced-forest-inventory-model-assessment / -full-pipeline.*
*Exercises:* northness; random forest; model-vs-kriging difference; suitability-model sketch.

**12. Raster Time Series and Change Detection.** An NDVI data cube, per-pixel trend mapping, differencing/thresholding for disturbance, and the link to committed emissions. *(topic gap filled from the data-cube curriculum.)*
*Exercises:* undisturbed pixel; threshold trade-off; scene-mean trajectory; real Sentinel-2 swap.

**18. Disturbance Mapping and Classification.** Supervised random-forest classification via `caret`, confusion matrix and kappa, and IPCC first-order fire emissions. *darkwoods_wildfire, darkwoods_beetles, wildfire-fuel-mapping-CFFDRS-2.0, IPCC-wildfire-emissions.*
*Exercises:* extra feature; split ratio; confusion-matrix interpretation; fuel-load sensitivity.

## Part VI — Carbon accounting and verification

**15. Allometry, Biomass and Uncertainty.** Fit and validate allometric equations (RMSE, bias), convert biomass to carbon with CF and root-to-shoot, and propagate uncertainty by Monte Carlo. *allometric-model-validation, VM0010-starter-template.*
*Exercises:* per-species RMSE; log vs nls; add height; Monte Carlo sensitivity.

**16. Forest Carbon Accounting.** Carbon pools, stratified stock estimate, baseline-vs-project emission reductions, harvested wood products, and conservative crediting deductions. *VM0010-starter-template.*
*Exercises:* soil pool; baseline sensitivity; Monte-Carlo-linked deduction; buffer vs uncertainty.

**17. Remote-Sensing MRV and Verification Checks.** Equal-area validation-plot sampling, map-vs-field RMSE/bias/CI, the 20/10 eligibility test, and geometry-validity and area de-duplication checks. *acr-remote-sensing-demo, area-checks, land-eligibility-…-VM0047.*
*Exercises:* seed variability; bias-to-fail; overlap reconciliation; write the accuracy statement.

## Part VII — Applied workflow

**13. Capstone: Forest-Carbon Inventory and Uncertainty.** The full chain, trees → allometry → plot carbon → landscape total → 90% CI → Monte Carlo propagation → reproducible report.
*Exercises:* stratified estimate; allometric CV; autocorrelation caveat; one-page report.

---

## Repos integrated so far

lidar-forestry · allometric-model-validation · VM0010-starter-template · acr-remote-sensing-demo · area-checks · land-eligibility-VM0047 · darkwoods_wildfire/beetles · wildfire-fuel-mapping-CFFDRS-2.0 · IPCC-wildfire-emissions · enhanced-forest-inventory (assessment + pipeline) · map-templates · GPS-training-material · survey-tools · (gisborne, la-ronge, ash-dieback methods folded into the LiDAR chapter).

## Candidate future additions (for the revision workplan)

- **Wetland / SAR-optical mapping** — a chapter from `mapping-wetland-inundation-lake-chilwa` (Google Earth Engine, water indices).
- **Growth-and-yield** — an FVS section from `ForestVegetationSimulator-Interface`.
- **Landscape pattern metrics** — deepen the disturbance chapter with `fragstats-spatial-patterns` / `landscapemetrics`.
- **Jurisdictional REDD+ case studies** — `TREES-charagua`, `TREES-bolivia`, `TREES-ecuador` as a worked activity-data / ART-TREES module.
- **National data access** — a short section using `faostat-mcp` for country-level forestry and emissions statistics.
- **QGIS no-code route** — the `lidar-dtm-extractor` plugin as an appendix for non-R users.
- **SOP / reproducibility appendix** — from `TREES-demo-repository`, `sop-library`, `ipcc-guidebook`.
