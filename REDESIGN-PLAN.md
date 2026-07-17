# Redesign blueprint — eight progressive chapters, each closing on a keystone

## The design

Eight short foundational chapters, ordered simple → complex. Each teaches its GIS concept on the running forest dataset, then **closes with a working example from one of your real verification projects**. Foundations and keystones are fused: the concept earns the example, the example proves the concept. The current 16 chapters consolidate into these 8; nothing foundational is lost, it is redistributed.

## The eight chapters

| # | Chapter (concept, simple → complex) | Closing working example (keystone) | Source repo / data |
|---|---|---|---|
| 1 | **Getting started** — R for spatial work, vector vs raster, coordinate & spherical systems, a first map | A first real map + CRS check | forest dataset, map-templates |
| 2 | **Vector data** — points, lines, polygons, shapefiles, geometry types, attributes & support, spatial operations | **Area checks** — validity, overlap reconciliation, area audit report | area-checks, TREES-charagua, alma, hiawatha |
| 3 | **Raster data** — grids, values, raster algebra, reclassification, extraction | **Land-use / land-cover reclassification** | LULC reclassification (Bolivia carried to Ch 7) |
| 4 | **Terrain & hydrology** — DEM, slope/aspect/curvature, hillshade, flow derivatives | **Hydrological analysis** — watersheds, inundation | mapping-wetland-inundation-lake-chilwa, map-templates |
| 5 | **LiDAR & point clouds** — point clouds, returns/waveform, ground classification, DTM/CHM, tree detection | **lidar-forestry** working example | lidar-forestry (+ gisborne, la-ronge, ash-dieback) |
| 6 | **Disturbance & spatial risk** — change detection, supervised classification, accuracy assessment, risk modelling | **Disturbance checks + VM0048 risk + ACR accuracy** | darkwoods, VM0048 (deforisk), VT0007, acr-remote-sensing |
| 7 | **Uncertainty statistics** — sampling error, propagation, Monte Carlo, confidence intervals, ART-TREES deductions | **Uncertainty ebook + Bolivia full land-cover classification** | uncertainty book, TREES-bolivia, TREES-monte-carlo |
| 8 | **Time series — capstone** — data cubes, temporal reduction, trends, change → emissions | **IPCC Tier 1 fire emissions** (burn area → fuel → consumption → emission factors) | IPCC-wildfire-emissions |

## Where the current chapters go

- Geometries, attributes & support → **Ch 2**. Cartography → distributed across **Ch 1, 4**.
- Point patterns, areal data → **Ch 6**. Geostatistics, spatial regression → **Ch 7**.
- Raster extraction → **Ch 3**; terrain from the raster chapter → **Ch 4**.
- Allometry & carbon accounting → fold into **Ch 7** (uncertainty is where they matter most).

## Appendix (preserves the "closing" material you mentioned earlier)

**Appendix A — Automation, protocols & registries:** runtime automation / simple workflow tools, spatial-data protocols and ISO governance, and ART-TREES / VERRA / ACR registry practice. Sources: sop-library, TREES-demo-repository (renv/git/QAQC/safeguards), GPS/survey SOPs, faostat-mcp. Kept as an appendix so it does not break the eight-chapter progression.

## My one assumption (correct me and I'll adjust)

Each chapter **teaches on the simulated Alberni forest dataset** (for a clean, always-runnable progression), then the **closing working example uses the real keystone project's data/outputs** so the example is genuine. If you'd rather each chapter run entirely on its keystone's real data, say so.

On your word I'll consolidate the 16 chapters into these 8, add the keystone closings, and rebuild `_quarto.yml`.
