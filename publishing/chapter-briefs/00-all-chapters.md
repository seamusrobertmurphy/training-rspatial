# Design notes, chapters 2 to 17

Drafted 4 September 2026. One page per chapter. Each records the question, the
entry, the edge, what the chapter owes the spine, the source material in the
library, and what is missing. Chapter 1 has its own longer brief. The arc every
chapter serves is in `book-spine.md`.

The house rule for all of them. Enter through something concrete and physical,
reach a methodological question by the middle, close on a number a verifier would
accept, and state somewhere in the chapter what geometry the arithmetic happened
on and what support the answer has.

---

## Part one. Data

### 2. Reading Reflectance, and What an Index Can Support

**Drafted 5 September 2026.** This chapter now has its own brief at
`02-reflectance.md` and a full draft at `drafts/02-reflectance.qmd`, both of
which supersede the page that stood here. The summary below is kept so the arc
reads continuously.

**Question.** What claim can a spectral index actually carry, and where does it
fail without saying so?

**Entry.** Chlorophyll absorbs the red and leaf structure scatters the near
infrared, so the contrast between two bands is a physical measurement of living
tissue. Landsat 1 opened the record in 1972 and it has not stopped.

**Edge.** Measured on the committed Rondonia scene, the four indices rank in the
reverse of the order projects reach for them on separating forest from clear-cut
regrowth, the burn ratio at 0.823 balanced accuracy and the vegetation index at
0.739, and under biomass-burning smoke on 2 September 2022 the vegetation index
moves 0.283 on forest against the burn ratio's 0.021. The index that separates
worst also breaks worst.

**Owes the spine.** A pixel has support. A 30 metre cell and a 10 metre cell are
not the same measurement of the same ground, and an atmospheric state is a
support condition on a value in the same way a cell size is.

**Boundaries.** Chapter 2 owns one observation. Chapter 10 owns the label and the
confusion matrix. Chapter 11 owns the difference between two dates and its
cause. Chapter 12 owns the time axis. Anything needing a second date to make its
point is not chapter 2.

**Sources.** `03-raster-data` (retires on promotion), `data/rondonia_s2_*`,
Murphy et al. (2026), `woolly-adelgid-signatures`, VM0048, VT0007.

---

### 3. Seeing Through Cloud, and Where Radar Saturates

**Question.** What does a radar return measure in a forest, and at what biomass
does it stop measuring anything?

**Entry.** Radar makes its own light and reads the echo, so it works at night and
through cloud. Polarisation is which way the wave was oscillating when it left
and when it returned, and the difference tells you about the shape of what it
hit. Speckle is the price of a coherent source, noise with a physical cause
rather than sensor error.

**Edge.** C-band saturates over closed canopy almost immediately and L-band near
100 to 150 megagrams per hectare, below the biomass of most forest anyone wants
to credit. That ceiling is why ESA flew BIOMASS at P-band in 2025 and why
interferometric coherence is used as a structure proxy where backscatter has
flattened. GFOI's Methods and Guidance now treats BIOMASS, ALOS-4 and NISAR as
central.

**Owes the spine.** Backscatter integrates over a resolution cell that is not the
pixel it is written into.

**Sources.** None in the library. Grep across every qmd, Rmd, md and R file
returned four hits and all four are glossary entries.

**Missing.** Everything. The author states he has built radar time series; the
data is not under `/Volumes/PortableSSD/Github`. This is the largest single new
chapter and the title now promises it.

---

### 4. Measuring the Third Dimension with Airborne Laser

**Question.** How much of a laser-derived canopy height is the sensor, and how
much is a parameter the analyst chose?

**Entry.** One pulse returns several times, off treetops, branches, ground.
Sorting which return hit soil is the delicate step and everything downstream
inherits its errors. Height above ground is not height above sea level and the
conversion has an order that cannot be reversed.

**Edge.** Two standard ground classifiers agree on nine returns in ten and
disagree on the tenth, concentrated under dense low vegetation and on breaks of
slope. A window function calibrated in a regenerating burn and applied to mixed
conifer overstated stem density by an order of magnitude with no warning. A
terrain model interpolated from an already normalised cloud is flat, valid,
projected and useless, and nothing errors.

**Owes the spine.** A height metric's support is the cell it was aggregated to. A
95th percentile over a cell holding several crowns returns something near the
tallest, which is why upper percentiles predict biomass and are not stand height.

**Sources.** `training-rspatial/05-lidar-point-clouds`, `lidar-forestry` (five-part
ebook, 364 files), `la-ronge-variable-tree-heights`,
`lidar-dtm-extractor-QGIS-plugin`.

**Missing.** Nothing material. `lidar-forestry` is richer than the current chapter
and should absorb it.

---

### 5. Conditioning a Surface, and What It Destroys

**Question.** Routing water requires every cell drain somewhere. What happens to
a lake that drains nowhere?

**Entry.** An elevation model already contains its drainage and does not contain
it cleanly, because interpolation error and vegetation returns leave pits with no
lower neighbour. A vertical datum is a harder idea than a horizontal one.

**Edge.** Lindsay's hybrid bounds the carving at the depth limit and does not
bound the filling, so Chilwa's bed rises fourteen metres on average and
eighty-three at its deepest and the endorheic sink is gone. The published claim
that a depth constraint preserves deeper basins does not survive measurement. The
stage-area curve is violently asymmetric, so one metre of stage moves the lake's
area by a factor of seven.

**Owes the spine.** EPSG:3857 at fifteen degrees south inflates cell area by about
seven per cent, so `cellSize()` throughout rather than one cell one hectare.
Anything depending on depression shape runs on the raw grid.

**Sources.** `training-rspatial/04-terrain-hydrology`,
`mapping-wetland-inundation-lake-chilwa`, `map-templates` parts 2 to 4.

**Missing.** Nothing. Strongest chapter in the manuscript. Needs reframing to lead
with the elevation model as an observational product with stated vertical error.

---

## Part two. Forest mensuration

### 6. Where the Plots Go, and What Another One Buys

**Question.** What does the next field plot buy, and when does it buy nothing?

**Entry.** A standard deviation describes the forest and does not shrink with
effort. A standard error describes your sample and does. The square root in that
formula governs the economics of every inventory ever designed.

**Edge.** Eligibility is a random variable. The same model against different draws
of validation plots fails at fifteen and passes at twenty on nothing but which
plots were drawn. Stratified allocation, permanent against temporary plots, and
what a five metre fix does to a four hundred square metre plot.

**Owes the spine.** A plot has support and a stand does not inherit it for free.

**Sources.** `darkwoods_seedlings`, `gisborne-forest-stocking-density`,
`GPS-training-material`, `survey-tools`,
`shinyapp-scaling-forest-inventory-data`, `sop-library/sop-plot-grid`.

**Missing.** New chapter. The material exists and has never been written up as
teaching.

---

### 7. The Equation Nobody Checks

**Question.** How much of a reported carbon stock is a measurement, and how much
a modelling decision made elsewhere?

**Entry.** Nobody weighs a standing tree. A crew measures diameter and a model
fitted on felled trees somewhere else converts it to mass. Biomass scales with
roughly the two-and-a-half power of diameter, and that power law is the most
consequential line of code in forest carbon.

**Edge.** Five defensible published equations on the same eighty-four oaks return
totals spanning 4.75-fold, 20 to 97 tonnes, with no field error involved. The
median published equation covers 61 per cent of stems but only 44 per cent of the
carbon, because destructive sampling is dominated by small trees. One equation of
twenty-three remains valid at the largest maple in the plot.

**Owes the spine.** An equation fitted on one size range and applied to another is
a support mismatch wearing a coefficient.

**Sources.** `training-rspatial/07-allometry`, `allometric-model-validation`,
`canadian-allometry-assessments`, `uncertainty/01-allometry`.

**Missing.** Length. 1,536 words for the best argument in the book.

---

### 8. From Tree to Landscape, and Which Multiplier Matters

**Question.** Every term in the chain is uncertain. Which deserves the next dollar?

**Entry.** Biomass per stem sums to plot, divides by area for density, multiplies
by a carbon fraction to become carbon. Trivial arithmetic, and where units go
wrong, because each step changes what the number means as well as its size.

**Edge.** Independent relative errors combine in quadrature, so contribution is
proportional to the square and large terms annihilate small ones. Wood density is
a reference lookup rather than a measurement of these trees. The 0.47 carbon
fraction is a default with its own uncertainty multiplying everything above it.

**Owes the spine.** Extensive quantities sum, intensive quantities average, and
confusing them is how reported totals inflate.

**Sources.** `enhanced-forest-inventory-model-assessment`,
`ForestVegetationSimulator-Interface`, `la-ronge-variable-tree-heights`.

**Missing.** Split out of the allometry chapter so mensuration reads as a part.

---

### 9. Calibrate, Predict, and Validate Honestly

**Question.** When is a wall-to-wall map an estimate, and when only a stratifier?

**Entry.** Fit on the plots, apply everywhere the sensor saw. Upper height
percentiles beat the mean because they are dominated by the large trees carrying
the mass and insensitive to the understorey the sensor reads poorly.

**Edge.** ACR's Framework for Remotely Sensed Quantification, 27 March 2026, gates
a model on two tests that are not independent. Above about eleven validation
plots the confidence interval test passes automatically whenever the root mean
square error test does, so one test does all the work. Random cross-validation
folds put neighbours on both sides of the split, so the model is scored on ground
it has already seen; blockCV 4.0-0, CRAN 20 August 2026, is the fix.

**Owes the spine.** This is where design-based and model-based inference first
separate, and the final chapter returns to it.

**Sources.** `acr-remote-sensing-demo`, `enhanced-forest-inventory-full-pipeline`,
`enhanced-forest-inventory-model-assessment`, `blockCV`.

**Missing.** New chapter. Source material is unusually complete.

---

## Part three. Landscape monitoring

### 10. Finding the Class You Are Paid to Find

**Question.** When the target class is rare and confusable, can design fix it or
only move the error?

**Entry.** A classifier assigns a label. A confusion matrix says how often it was
right, split by what the map claimed and by what was there. Overall accuracy is
dominated by whichever class is largest and easiest, which is never the class
being paid for.

**Edge.** Stratifying raises producer's accuracy above 0.9 and collapses user's
accuracy, trading omission for commission at close to one for one, and overall
accuracy falls. Only quadrupling the sample fixed it. Margin and entropy as
spatial uncertainty layers, and more than three quarters of errors falling in the
lowest-margin tenth of the scene.

**Owes the spine.** A class label's support is the pixel, and the minimum mapping
unit is a statement about the support at which a class may exist.

**Sources.** `training-rspatial/09-activity-data`, `TREES-bolivia-activity-data`,
`VT0007-deforestation-map`, `uncertainty/03-activity-data`.

**Missing.** The chapter runs on simulated reflectance and reports a VM0048 pass
or fail from it. Rebuild on Rondonia or Bolivia before peer review. This is the
objection most likely to decide the review.

---

### 11. Detecting Change and Naming Its Cause

**Question.** What separates a detection from an attribution, and what evidence
closes the gap?

**Entry.** Index at two dates, subtract, threshold. Everything difficult is in the
last step, and the published severity breaks most projects reach for are defaults
rather than constants.

**Edge.** The low break catches about three quarters of genuinely cleared ground
and the high break well under half, and every miss is omitted deforestation,
which understates emissions. Rectangularity fails outright as an automated
statistic because a classifier's edges are already blocky and Amazonian wetlands
are themselves linear. The rule is a visual prior on one polygon, not a
classifier, and it does not survive averaging.

**Owes the spine.** A change detected at one support is not a change at another.

**Sources.** `training-rspatial/06-disturbance-risk`, `public-disturbance-data`,
`public-boundary-data`, `disturbance-checker`, `darkwoods_beetles`,
`woolly-adelgid-signatures`, `deep-learn-alaska-spruce-beetle`,
`wildfire-fuel-mapping-CFFDRS-2.0`.

**Missing.** The 38 per cent seasonal composite finding is unsourced and rests on
an engagement. It needs a citation, a reproducible demonstration on Rondonia, or
removal. Fire weather index and fuel typing are gaps the library can fill.

---

### 12. The Cube, the Calendar, and Aliasing

**Question.** How much of a measured trend is the phenology of whichever dates
happened to be cloud free?

**Entry.** A cube has three axes and you hold all three at once. Two are the
familiar grid. The third is time, which unlike the others is not regular unless
you force it to be, because a satellite revisits on a fixed cycle and returns a
usable observation only when the sky is clear.

**Edge.** Seasonality accounts for almost all the variance and the trend, the
thing carbon monitoring exists to measure, is a per cent or two. Sampling at
drifting phase recovers the right slope on average and scatters it several times
wider than the trend, so more than a third of draws report a declining pixel as
greening. Compositing to a fixed window is not data cleaning, it is the cheapest
uncertainty reduction in the book.

**Owes the spine.** This is the terminus. A cell has support in space and in time
at once, and the array is a claim about what each value means rather than a
container.

**Sources.** `training-rspatial/12-time-series`, `forest-fire-index-trends`,
`budworm-beetle-attribution-test`, `chaos-in-beetle-outbreaks`,
`mapping-wetland-inundation-lake-chilwa` (harmonic fit, clear-observation count),
`sits`, `training-rspatial-research/sdsr`.

**Missing.** The chapter is entirely simulated, including its reported burned area
and emission. It needs a real multi-date stack. Chilwa already has one, with a
clear-observation raster that makes the extrapolation visible. Tools chapter for
`stars` and `gdalcubes` belongs here.

---

### 13. Pattern, Process, and Standard Errors You Should Not Trust

**Question.** Once spatial dependence is admitted, how much of the information in
a dataset is actually there?

**Entry.** Point pattern analysis asks about the locations themselves rather than
values measured at them. Clustered, random or regular, and Ripley's K asks it at
every distance rather than settling for one number.

**Edge.** Fitting an independence model to clustered data leaves coefficients
roughly unbiased and standard errors far too small. Correcting inflates them six
and a half to ten times and six of seven significant terms stop clearing. Variance
scales as the square, so the naive fit treated the data as carrying fifty to a
hundred times more information than it holds. Effective sample size falls from
3,912 to a few dozen cohorts.

**Owes the spine.** Effective sample size is support seen from the inference side.

**Sources.** `training-rspatial/13-spatial-patterns`, `darkwoods_seedlings`,
`fragstats-spatial-patterns`, `VM0048/deforisk`, `VT0007-deforestation-map`.

**Missing.** The chapter has no Earth observation content. Needs an observational
framing, and detected clearings as a point pattern is the obvious one. Spatial
risk modelling now belongs here, four of its eight methods being gaps.

---

## Part four. Greenhouse gas inventory

### 14. Counting Hectares When the Map Is Not the Estimate

**Question.** Why does a defensible area come from a probability sample rather
than from counting classified pixels?

**Entry.** Activity data is the extent of the thing happening and it is the term
spatial analysis is actually for. The IPCC separates three ways of collecting it
and the distinction is about whether transitions are located.

**Edge.** The Olofsson stratified estimator adjusts a mapped area against a
reference sample and attaches an interval, and the direction of that correction
is not guessable. Early in a record omitted change scattered through a vast stable
stratum pushes the estimate up; later, as user's accuracy falls, commission
dominates and the reported figure overstates by thirty per cent.

**Owes the spine.** Design-based inference in its purest form. The map stratifies
and the sample estimates.

**Sources.** `TREES-bolivia-activity-data` (Winrock national-scale worked
example), `VT0007-deforestation-map`, `VM0048`, `uncertainty/03-activity-data`.

**Missing.** The Bolivia work is alluded to twice in the current manuscript and
never shown. Bring it in.

---

### 15. The Factor You Assumed, and the Error Budget

**Question.** Given a fixed budget, which term should a project measure better?

**Entry.** Almost every greenhouse gas estimate in land use reduces to extent
times consequence per unit extent. Analysts spend their effort on the term they
measured and none on the term they assumed, and the assumed term is usually the
larger error.

**Edge.** Stated uncertainty in a single IPCC reference table spans eighteenfold,
one cell resting on 781 measured soil profiles and another on none at all with a
nominal ninety per cent placeholder. In a Tier 1 agroforestry chain, eliminating
area uncertainty entirely moves the total from 71.2 per cent to 70.5.

**Owes the spine.** Support governs which factor applies. A depth convention, a
climate zone, a stratum.

**Sources.** `training-rspatial/08-emission-factors`, `IPCC-wildfire-emissions`
(four-part ebook), `ipcc-guidebook`, `uncertainty/02-emission-factors`.

**Missing.** Peatland, wetland and mineral soil pools as distinct accounting.
Flux-based methods against stock-change and the buffer trade-off. This is where
the book's climate framing belongs, because the argument is that money should
follow variance.

---

### 16. The Thing That Did Not Happen

**Question.** How do you constrain a number that by construction cannot be
observed?

**Entry.** A credit is the difference between what happened and what would have
happened otherwise, and the second term is unobservable. It is also the number
most exposed to the proponent's discretion, since the proponent proposes it.

**Edge.** Fit a trend to five noisy years with no underlying trend and project it,
and the crediting level spans twelvefold across the choice of window alone.
Mandating an average removes the dial. Read the rules as forecasting methods and
they look crude; read them as anti-gaming devices and they are carefully built.
Allocation must conserve the zonal total or projects in aggregate are credited
against more deforestation than the jurisdiction has.

**Owes the spine.** A baseline is a claim at jurisdictional support allocated down
to project support, and the allocation is where the argument happens.

**Sources.** `training-rspatial/10-baseline-modelling`, `VM0048` baseline and
leakage, `public-jurisdictional-data`, `VT0007-deforestation-map`.

**Missing.** Non-permanence risk and buffer determination. Deforestation risk
modelling as a worked example rather than an aside.

---

### 17. What the Number Is Worth

**Question.** What does imprecision cost, who decides, and why does the same
statistic cost three different amounts?

**Entry.** A carbon figure without an uncertainty is not conservative, it is
incomplete. Reducing uncertainty is worth money and quantifying it honestly is
the whole of the auditor's job.

**Edge.** At thirty per cent uncertainty the same nominal statistic at the same
nominal ninety per cent confidence costs twenty per cent of credits under ACR and
under eight under VM0048, and the ordering reverses at about fifteen. ART deducts
from the first per cent with no threshold at all. Ninety per cent confidence is
not a comparable unit across registries.

**Owes the spine.** The closing move. Show the reader the polygon from chapter 1
and ask what its area is. The answer depends on the geometry, the engine, the
support and the inferential frame, all four of which they can now state. Land on
design-based against model-based inference, citing Pebesma's chapter on
statistical modelling.

**Sources.** `training-rspatial/11-uncertainty`, `uncertainty/04-monte-carlo`,
`TREES-monte-carlo-app`, `TREES-demo-repository`, `area-verification`,
`verra-tasks1-2`, `sop-library`.

**Missing.** ART equation numbers are out of date. The uncertainty adjustment
factor moved from Equation 11 in TREES 2.0 to Equations 7 and 8 in TREES 3.0,
approved June 2026. The area-adjusted series is hand-specified rather than
derived. Markov chain Monte Carlo and Bayesian inference are named nowhere and
are on the author's list.

---

## What blocks what

Three items block more than one chapter and should be scheduled first.

**Radar data.** Blocks chapter 3 entirely and half of chapter 12. Nothing in the
library carries it and the title promises it.

**Real optical time series.** Blocks chapter 12 and would rescue chapter 10.
Chilwa already has a multi-date stack with a clear-observation raster.

**Clearance for audit material.** Blocks chapters 1, 11 and 17, each of which
rests on a named engagement.

---

## The disturbance ecology thread

Added 5 September 2026 with the spine amendment. The closing message of the book
is disturbance ecology, so the chapters that observe disturbance carry an
obligation beyond their own result and each must hand something forward.

Chapter 2 introduces the beetle and fire signatures as measurements and names the
closing debate without attempting it. Chapter 11 dates and attributes change and
is where a detection first becomes an event. Chapter 12 builds the cube and is
where a series of events first becomes a trajectory. Chapter 13 admits spatial
dependence and is where the count of observations stops being the amount of
information. The final part asks whether the system has states, whether it moved
between them, and whether a record of this length could tell, which is the same
support question the book opened with, asked along the time axis.

The library already holds the material for that closing. `chaos-in-beetle-outbreaks`
reads mountain pine beetle damage across eight British Columbia regions spanning
6.7 degrees Celsius from 1.17 million aerial survey polygons since 1961, and
finds two period levels at 32.5 and 21.7 years whose ratio is 1.5, so a
period-doubling cascade needing three levels in ratios near two is not
detectable in 65 annual observations. That is the strongest support argument in
the whole corpus and it belongs at the end of this book.

Two decisions are open. Whether one of the last chapters carries the
dynamical-systems argument explicitly, since the seventeen-chapter outline as
briefed spreads it across three. And whether the subtitle going to Elsevier
names it.
