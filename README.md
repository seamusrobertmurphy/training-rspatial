# Spatial Data Analysis in R for Forest Carbon

A Quarto book by Dr Seamus Murphy: a practical GIS and remote-sensing course in R for forest, carbon, and organic-agriculture auditors. The running example is a coastal temperate-rainforest study area in the Alberni Valley, Vancouver Island.

## Contents

**Part I — Foundations**
1. R for spatial work
2. Spatial data models (vector and raster)
3. Coordinate reference systems and projections

**Part II — Vector data**
4. Vector data with `sf`
5. Geometric operations and spatial joins

**Part III — Raster data**
6. Raster data with `terra`
7. Extracting rasters to field plots

*Part IV (cartography, spatial autocorrelation, interpolation, modelling) and Part V (forest-carbon capstone) are in preparation.*

## Data

Forest inventory plot and tree data in `data/` are **simulated** for teaching, from realistic coastal-BC species compositions and biomass–diameter relationships. Terrain and imagery layers are real and downloaded from open services (elevation, MODIS/Sentinel, OpenStreetMap) at render time.

## Build

```bash
rm -rf .quarto && quarto render --to html   # HTML book to _book/
```

The `rm -rf .quarto` avoids a stale-index error on exFAT drives. Styling is in `styles.scss`; the bibliography and Word reference document live in `references/`.
