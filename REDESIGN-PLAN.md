# Redesign plan — a keystone-anchored spatial verification course

## The core recommendation

Redesign the book so that **each chapter is anchored on one of your real training/verification projects**, and teaches the foundational GIS it rests on *through* that project. The current book teaches foundations well but the applied work sits only in exercises; your instinct is right that the milestones should become the spine, not the footnotes. Keep a short foundations primer up front so no prerequisite is skipped, then let every subsequent chapter be a keystone.

This keeps the two things you want at once: complete coverage of foundational GIS, and a book that is unmistakably *forest-carbon-verification* and unmistakably yours.

## Proposed structure

Front matter: Preface + a compact **Foundations** primer (from the current book, condensed): R for spatial work · spatial data models · geometries · coordinate & spherical systems · vector data, attributes and support · spatial operations · raster data and extraction · cartography. These stay as the opening chapters so every reader has the toolkit before the keystones begin.

Then the keystone chapters, in your order:

| # | Keystone chapter | Anchored on (your repos) | Foundational GIS it teaches |
|---|---|---|---|
| K1 | **Area checks** | area-checks, TREES-charagua, alma-disturbance-check, hiawatha-area-disturbance-checks | geometry validity, overlays, area reconciliation, audit reporting (flextable→Word) |
| K2 | **LiDAR** *(mid-book, moving toward rasters)* | lidar-forestry, gisborne, la-ronge, ash-dieback | point clouds, DTM/CHM, tree detection, raster extraction |
| K3 | **Allometry & biomass** | allometric-model-validation, VM0010-starter-template | model fitting, validation (RMSE/bias), biomass→carbon |
| K4 | **Uncertainty** *(the central keystone)* | **uncertainty** book (allometry · emission factors · activity data · Monte Carlo), TREES-monte-carlo-app | error propagation, Monte Carlo, confidence intervals, ART-TREES deductions |
| K5 | **Land use & remote sensing** | TREES-bolivia / TREES-ecuador activity data, GEE scripts, acr-remote-sensing-demo | image classification, land-change, accuracy — feeding uncertainty |
| K6 | **Wetland & hydrology** | mapping-wetland-inundation-lake-chilwa, map-templates (watersheds/streams/topography) | SAR-optical fusion, water indices, cartographic templates |
| K7 | **Disturbance & risk** | darkwoods (wildfire/beetles), VM0048 (deforisk), VT0007, acr-remote-sensing (accuracy) | change detection, supervised classification, ACR accuracy assessment, VM0048 risk modelling |
| K8 | **Time series** *(final keystone project)* | IPCC-wildfire-emissions (burn area → fuel → consumption → emission factors), darkwoods time series | data cubes, temporal reduction, change→emissions chain |
| K9 | **Automation, protocols & registries** *(close)* | sop-library, TREES-demo-repository (renv/git/QAQC/safeguards), GPS/survey SOPs, faostat-mcp | runtime automation, reproducible workflow tools, ISO spatial-data governance, ART-TREES/VERRA/ACR registry practice |

## How the current book folds in

- The current foundational chapters (1–8) **become the Foundations primer**, lightly condensed. Nothing is thrown away.
- The current statistics chapters (point patterns, geostatistics, areal data, spatial regression) **distribute into the keystones**: geostatistics and regression into Allometry/Uncertainty; point patterns and areal data into Disturbance & Risk.
- Uncertainty is promoted from a theme to **the central chapter (K4)**, built directly on your `uncertainty` book's four-part structure — the pedagogical heart of the whole course.
- Time series moves to the **end** as the capstone (K8), realised as the IPCC-wildfire emissions pipeline you already built.

## The three decisions I need from you

1. **Primer length.** Keep the foundations as ~8 short chapters up front (thorough), or compress to ~3–4 (faster to the keystones)?
2. **Data.** Keep the single simulated Alberni forest dataset across all keystones for consistency, or let each keystone use its own real project data (Charagua area check, Chilwa wetland, Darkwoods disturbance, etc.) so the examples are genuine?
3. **Depth vs. deadline.** Nine keystone chapters is a large build. Do you want all nine now, or a prioritised first wave (I'd suggest Area checks → LiDAR → Allometry → **Uncertainty** → Time series as the backbone, then the rest)?

Tell me those three and I'll rebuild the `_quarto.yml` around the keystones and start composing, in your voice, from your actual project code.
