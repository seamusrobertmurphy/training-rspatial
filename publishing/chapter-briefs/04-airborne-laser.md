# Chapter 4 brief

Compiled 6 September 2026, rewritten the same day after the author supplied two
further repositories. Working title **Deriving canopy height from airborne laser
scanning, how much is the sensor and how much the analyst**.

## The question

How much of a laser-derived canopy height is the sensor, and how much is a
parameter the analyst chose?

That question now has an answer the chapter can demonstrate rather than assert,
and the demonstration comes from the author's own working repositories.

## The finding that organises the chapter

Two of the three source repositories detect tree tops with a variable window
function. A variable window function is a rule that says how wide to search for
a treetop as a function of how tall the canopy is, on the assumption that taller
trees have wider crowns. It is two coefficients.

`la-ronge-variable-tree-heights` defines it as

```r
wf_Popescu <- function(x) { a = 0.05; b = 0.6; y <- a * x + b; return(y) }
```

and introduces it as "Popescu and Wynne's function (2004) which was developed in
pine forests".

`gisborne-forest-stocking-density` defines it as

```r
wf_plowright <- function(x) { a = 0.05; b = 0.6; y <- a * x + b; return(y) }
```

and labels its plot "Plowright, 2018; y=0.05*x+0.6", with the code comment "Used
Plowright's window function as temporary fix here", followed by a link to the
ForestTools package vignette.

**The two functions are identical to the digit.** Same slope, same intercept,
two different attributions, applied to boreal spruce and jack pine in northern
Saskatchewan and to plantation forest near Gisborne in New Zealand. Neither was
calibrated to its own stand. One is explicitly labelled a temporary fix. Both
produced operational outputs, and in the Gisborne case those outputs were
compared against an official stand-level inventory and used to propose a
remapping.

That is the chapter. Not as an accusation, because the code says plainly what it
did in both cases, but as the clearest available demonstration that the largest
single lever on a stem count is a two-coefficient line the analyst borrowed.

**To verify before print.** Popescu and Wynne (2004) published species-specific
window functions for pine and deciduous stands, and the linear form
`0.05x + 0.6` appears to be the ForestTools vignette's own illustrative example
rather than anything in that paper. Open the paper and check the attribution.
If it is wrong it must be corrected in both repositories, and the correction is
itself worth a sentence in the chapter, because a misattributed parameter is
harder to audit than an uncalibrated one.

## What each repository brings

**`lidar-forestry`**, a five-part ebook, brings the raw measurement chain.
Working example is airborne lidar tile `10SGH1587` from the United States
Geological Survey 3D Elevation Program over the Carr Hirz Delta Fires burn scar
in Shasta County, California. Quality Level 1, accepted at 9.8 centimetres or
better absolute vertical accuracy at 95 per cent confidence in open terrain, one
square kilometre at about 78 points per square metre, 78.3 million points, with
figures built from a one hectare clip. That provenance is the point. It is a
public, copyright-clear, quality-graded product with a stated vertical accuracy,
which is exactly the specification chapter 1 spends its length arguing for and
which almost no dataset in this field meets. Parts one to three carry ground
classification, noise removal, terrain model, height normalisation, fixed and
variable window detection, and dominant height extraction by two routes.

**`la-ronge-variable-tree-heights`** brings the support argument. It works from
a one metre digital surface model and digital elevation model from the Canadian
High Resolution Digital Elevation Model repository, differences them into a
canopy height model, detects treetops, and classifies the landscape into Height
Heterogeneity Areas by the standard deviation of tree height. Its stated purpose
is to tell inventory crews where to add plots or shrink sampling units. That is
the spine's support argument arriving from the field side, and it hands directly
to chapter 6 on plot design.

**`gisborne-forest-stocking-density`** brings the validation. Working from
LINZ digital surface and elevation models, it derives a stem map and a stocking
density layer at ten metre resolution, and compares the result against official
stand-level attributes. That comparison is what the chapter needs and it is what
the simulated modelling in `lidar-forestry` part four was standing in for.

## A second finding, to verify before use

The Gisborne workflow computes stems per hectare as

```r
ttops_height <- ForestTools::sp_summarise(ttops, grid = 10, variables = "height", ...)
stem_count_ha <- 10 * stem_count_rast
```

If `grid = 10` produces ten metre cells, each cell covers 100 square metres and
the conversion to stems per hectare is a factor of 100, not 10. As written the
layer would report stems per thousand square metres under a hectare label, low
by an order of magnitude. `sp_summarise` is no longer exported by the installed
ForestTools, so this could not be checked by running it and **must not be stated
in the chapter until it has been**. If it holds it is the most valuable single
paragraph in the chapter, because it is a units error inside a layer that was
compared against official records and passed.

## The modelling boundary, now settled

Part four of `lidar-forestry` runs on simulated plot data and a synthetic
species raster, says so, and reports cross-validated errors from it. That breaks
the preface rule that a constructed surface carries no reported number.

**Decision taken 6 September 2026: chapter 4 ends at the metric, and all
plot-to-metric modelling moves to chapter 9.** Chapter 9 already owns
calibration, prediction and spatially blocked cross-validation and had no worked
example. This fixes the defect by moving a boundary rather than by finding new
data, shortens a long chapter, and fills a hole elsewhere. Chapter 9 then needs
real plots, and the Gisborne stand attributes are the strongest candidate in the
library.

## Structure

Nine sections. The chapter ends at the metric.

**4.1 Introduction.** One pulse, several returns. The sentence that governs
everything downstream is that every later number inherits the classification of
the returns called ground.

**4.2 The tile and its accuracy.** Read the 3DEP provenance, quality level,
stated vertical accuracy and point density from the file. First dataset in the
book that meets chapter 1's specification.

**4.3 Two ways in.** Raw returns against a differenced surface model. Most
operational foresters never see a point cloud; they are handed a digital surface
model and a digital elevation model and they subtract. La Ronge and Gisborne
both do this and it has different failure modes from the point cloud route,
because the vendor's own ground classification is baked in and cannot be
inspected.

**4.4 Ground classification.** Cloth simulation filter against progressive
morphological filter on identical returns. Report where they disagree, which is
under dense low vegetation and on breaks of slope.

**4.5 Normalisation, and the order that cannot be reversed.** Interpolating a
terrain model from an already normalised cloud returns a surface that is flat,
valid, projected and useless, and nothing errors.

**4.6 The window function.** The chapter's core. Plot `0.05x + 0.6` against
height, then vary the two coefficients across published ranges and report how
stem count moves. Then the La Ronge and Gisborne case, the identical function
under two names on two continents.

**4.7 Height metrics and their support.** Upper percentiles, cover, density. A
95th percentile over a cell holding several crowns returns something near the
tallest of them, not the mean, which is why upper percentiles predict biomass
and are not stand height.

**4.8 Where the metric decides the fieldwork.** Height Heterogeneity Areas from
La Ronge. Using the variance of a derived metric to allocate sampling effort,
which is the support argument running backwards from the sensor to the plot, and
the hand-off to chapter 6.

**4.9 Conclusions.**

## Owes the spine

A height metric's support is the cell it was aggregated to, and it is not the
tree. Section 4.7 pays it at the metric and 4.8 pays it again by using it to
size a sample. The chapter also carries the vertical half of chapter 1, because
height above ground is not height above sea level.

## Data

Commit the one hectare Carr clip and its derived products, not the tile. A
normalised cloud, terrain model, canopy height model and treetop set should come
in well under the 69 megabytes the source ebook's assets occupy. The 78.3 million
point tile is fetched by `data-raw` on the same pattern as the Rondonia and
Chilwa scripts.

La Ronge and Gisborne need a decision. Both work on public national elevation
products, HRDEM in Canada and LINZ in New Zealand, so both are copyright-clear
in principle. Gisborne's official stand attributes may not be, and the
comparison is the valuable part. Confirm before committing anything from it.

## Open

1. Verify the Popescu and Wynne attribution against the paper.
2. Verify the stems per hectare conversion factor by running it.
3. Confirm the Gisborne stand attributes are clear for publication.
