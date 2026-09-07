# Chapter 4 brief

Compiled 6 September 2026. Working title **Deriving canopy height from airborne
laser scanning, how much is the sensor and how much the analyst**. Subject is
the three-dimensional measurement, from the raw returns to a metric a biomass
model can use.

## The question

How much of a laser-derived canopy height is the sensor, and how much is a
parameter the analyst chose?

## Why it sits here

Chapters 1 and 2 settled where a measurement is and what it is. This chapter is
the first one where the measurement has a third dimension, and it is the first
where the analyst's own choices become a larger error source than the
instrument. That reversal is the chapter.

## What the library holds

`training/lidar-forestry` is a complete five-part ebook and it is richer than the
chapter currently in the manuscript. Its working example is airborne lidar tile
`10SGH1587` from the United States Geological Survey 3D Elevation Program, flown
over the Carr Hirz Delta Fires burn scar in Shasta County, northern California.
Quality Level 1 linear-mode lidar, accepted at 9.8 centimetres or better absolute
vertical accuracy at 95 per cent confidence in open terrain. One square
kilometre at about 78 points per square metre, 78.3 million points. Figures are
built from a one hectare clip centred on the densest-canopy cell, which keeps
every chunk under a million points.

That provenance is worth more than the data. It is a public, copyright-clear,
quality-graded product with a stated vertical accuracy, which is exactly what
chapter 1 spent forty pages arguing every dataset should have and almost none
does. The chapter should say so.

The five parts map onto the chapter as follows. Part one is catalogue
management, ground classification, noise removal, terrain model and height
normalisation. Part two is stem detection by fixed and variable windows and by
the rasterised method. Part three prepares the canopy height model and extracts
dominant height by two routes, points and raster. Part four builds spatial
covariates and trains a model. Part five is validation.

`la-ronge-variable-tree-heights`, 367 megabytes, carries a second canopy height
model and treetop set. `lidar-dtm-extractor-QGIS-plugin` carries the terrain
extraction as a plugin. Both are supporting rather than central.

## The defect to fix before this chapter is drafted

**Part four of the source ebook runs on simulated plot data and a synthetic
species raster, and it says so plainly.** Its own words are that the plot data
are simulated because the 3DEP release is copyright-clear but no public field
inventory plots accompany it, and that the response surface is drawn from the
canopy height model, terrain and a synthetic species raster with additive
Gaussian noise, to preserve the structure of the workflow without depending on
proprietary provincial layers.

That is an honest note and it is the same defect already flagged in the activity
data and time series chapters, where the preface rule is that a constructed
surface carries no reported number. The ebook then reports numbers from it,
including cross-validated root mean square errors of 33 to 47 cubic metres per
hectare and root mean square error ratios of 0.32 to 0.44.

Three ways out, in order of preference.

1. **Find public plots over public lidar.** The United States Forest Service
   Forest Inventory and Analysis programme publishes plot data with fuzzed and
   swapped coordinates, which is itself a positional accuracy lesson this book
   is well placed to teach. Whether the fuzzing defeats a plot-to-metric model at
   one hectare is an empirical question and the answer is worth a section either
   way.
2. **Move the modelling out of this chapter entirely** and into chapter 9, which
   already owns calibration, prediction and spatially blocked cross-validation.
   Chapter 4 then ends at the metric rather than at the model, which is a
   cleaner boundary and shortens a chapter that is already long.
3. **Keep the simulation and report no number from it**, using it only to show
   the shape of the workflow. Weakest, because the interesting failures in the
   source ebook are all numerical.

**Recommendation is the second.** It fixes the defect by moving the boundary
rather than by finding new data, it shortens this chapter, and it gives chapter
9 the worked example it currently lacks.

## Structure

Nine sections, ending at the metric rather than the model.

**4.1 Introduction.** What a return is, why one pulse comes back several times,
and the single sentence that governs the chapter: everything downstream inherits
the classification of the first return that was called ground.

**4.2 The tile and its accuracy.** The 3DEP provenance, the quality level, the
stated vertical accuracy and the point density. Read from the file rather than
from the documentation. This is where chapter 1's specification is met by a real
product for the first time, and the chapter should make that explicit.

**4.3 Ground classification.** Cloth simulation filter against progressive
morphological filter, run on the same returns. The source ebook already runs
both. Report the agreement and, more usefully, where they disagree, which is
under dense low vegetation and on breaks of slope.

**4.4 Terrain and normalisation.** Building the terrain model, subtracting it,
and the order that cannot be reversed. Interpolating a terrain model from an
already normalised cloud returns a flat, valid, projected and useless surface,
and nothing errors. That is the chapter's cheapest and best trap.

**4.5 The canopy height model.** Rasterising, pit filling, and the choice of
cell size, which is the support question from chapter 2 arriving in three
dimensions.

**4.6 Individual tree detection.** Fixed against variable windows. The window
function is the clearest case in the book of a parameter masquerading as a
measurement, because a function calibrated in one stand and applied to another
changes stem density by an order of magnitude without warning.

**4.7 Crown segmentation.** Where the trees become objects, and where the
segmentation algorithm's assumptions start to matter more than the point
density.

**4.8 Area-based metrics.** Height percentiles, cover, density. The 95th
percentile over a cell holding several crowns returns something near the tallest
of them, not the mean, which is why upper percentiles predict biomass well and
why they are not stand height. This is the section that hands to chapter 9.

**4.9 Conclusions.**

## Owes the spine

A height metric's support is the cell it was aggregated to, and it is not the
tree. Section 4.5 pays that at the raster and section 4.8 pays it again at the
metric. The chapter also carries the vertical half of chapter 1's argument,
because height above ground is not height above sea level and the conversion
between them needs a geoid model.

## Data

The one hectare clip and its derived products need committing, and the sizes are
manageable if the clip rather than the tile is committed. The source ebook's
assets directory is 69 megabytes in total. A normalised one hectare cloud, a
terrain model, a canopy height model and a treetop set should come in well under
that.

The tile itself is 78.3 million points and must not be committed. The
`data-raw` script fetches it from the Staged Elevation directory, clips, and
writes the products, on the same pattern as the Rondonia and Chilwa scripts.

## Missing

Nothing blocking. The modelling boundary decision above is the only open
question, and the recommendation is to move it to chapter 9.
