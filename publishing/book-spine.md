# The spine

Drafted 4 September 2026 from the author's dictation. This records the thread
that opens in chapter 1, is picked up in every chapter, and closes in the final
part. It exists so that no chapter can be written without knowing what it owes
the arc.

## The thread

**The geometry you compute on, and the support your answer has.**

Both halves are needed and they are not the same question. Geometry is where the
arithmetic happens, on a plane, on a sphere, on an ellipsoid, in a projected grid
that distorts area with latitude. Support is what the answer refers to, the area
or the interval or the volume over which a value was measured and to which it
applies. Every number in forest carbon accounting has both, almost no report
states either, and the errors that survive to an audit are nearly always one of
them.

## Why this thread and not another

It is the only question that is genuinely present in every chapter of the book,
from reading a shapefile to reporting a deduction, and it is the question the
field's own literature treats as settled and does not.

It also has a natural terminus. A spatio-temporal data cube is the point where
geometry and support stop being separable, because a cell has an extent in space,
an extent in time, and a value whose meaning depends on both. That is why the
cube belongs late in the book rather than early. It is not an advanced file
format, it is the structure that forces the reader to confront what they have
been assuming since chapter 1.

## Where it appears

**Chapter 1 opens it.** Which plane, which engine, which library version. A
bounding box and a convex hull disagree by 6.6 per cent on the same stems because
the grid runs 1.8 degrees off north. `sf_use_s2()` changes the answer by about
6.4e-05, which is small, and saying so teaches the reader to rank error sources
rather than fear them equally. The chapter closes on the rule that an area
without its engine stated is not reproducible.

**Chapters 2 and 3 carry it into the sensor.** A pixel has support. A 30 metre
Landsat cell and a 10 metre Sentinel-2 cell are not the same measurement of the
same ground, and a radar backscatter value integrates over a resolution cell that
is not the pixel it is written into.

**Chapter 4 makes it three-dimensional.** A canopy height is a difference between
two surfaces, each interpolated, and the support of a height metric is the cell
you aggregated it to. The 95th percentile over a cell containing several crowns
returns something near the tallest of them, not the mean, which is why upper
percentiles predict biomass well and why they are not stand height.

**Chapter 5 is where the geometry bites hardest.** EPSG:3857 at fifteen degrees
south inflates cell area by about seven per cent, so `cellSize()` rather than the
one-cell-one-hectare shortcut. A conditioned surface has had its depressions
removed, so anything depending on depression shape must run on the raw grid.

**Chapters 6 to 9 make it statistical.** A plot has support and a stand does not
inherit it for free. An allometric equation fitted on trees of one size range and
applied to another is a support mismatch wearing a coefficient. Extensive
quantities sum, intensive quantities average, and confusing the two is how
reported totals silently inflate.

**Chapters 10 and 11 make it categorical.** A class label has support equal to the
pixel, and the minimum mapping unit is a statement about the support at which a
class is allowed to exist. VM0048 requires the benchmark map at 30 metres and
sample imagery at 10 metres, and the split follows from the map not being the
estimator.

**Chapter 12 is the terminus and the payoff.** A cube cell has support in space
and in time at once. Compositing to a fixed seasonal window is a decision about
temporal support, and it is the cheapest uncertainty reduction in the book,
because sampling at drifting phase makes a third of draws report a declining
pixel as greening. This is where the reader is shown that the array is not a
container, it is a claim about what each value means.

**Chapters 13 to 17 close the loop.** Effective sample size is support seen from
the inference side. Cluster-corrected standard errors run six to ten times the
naive ones because the data carry far less independent information than their
count suggests. And the final distinction is the one Pebesma sets out in his
chapter on statistical modelling, between design-based and model-based inference.
That split is exactly the split this book has been building toward. Area
estimation from a probability sample is design-based, and the map only
stratifies. Biomass mapped from a plot-to-metric model is model-based, and its
error applies everywhere the model was applied. A project that reports one as
though it were the other has misstated its own uncertainty, and no amount of
downstream care recovers it.

## The closing move

The last chapter should return explicitly to the first. The reader is shown the
same polygon from chapter 1 and asked what its area is now, and the honest answer
is that it depends on the geometry, the engine, the support and the inferential
frame, all four of which they can now state. That is the arc, and it is the
difference between a book that teaches operations and one that teaches judgement.

## Sources for the closing

Pebesma and Bivand, *Spatial Data Science with Applications in R*, chapter on
statistical modelling of spatial data. The author holds a copy of that chapter at
`~/Downloads/10-Models.qmd`. Its sections on support and statistical modelling,
on time in predictive models, and on design-based against model-based inference
are the theoretical frame the book's final part should land on and should cite.

## Outstanding

The author has sourced two ebooks that present geospatial data objects
effectively without overwhelming the reader, and wants chapter 1 aligned with
them. Neither was supplied with the dictation. Names or paths needed before the
alignment can be done.

## Amendment, 5 September 2026

Dictated while chapter 2 was being drafted. The thread above is unchanged and
still runs from chapter 1 to the cube. What changes is the terminus.

The closing message of the book is **disturbance ecology**, and the cube is the
instrument that makes it arguable rather than the destination. By the final part
the reader has a spatio-temporal data cube fit for spatial modelling, and the
question the book then asks of it is whether a forest carbon landscape has
states, whether it can pass between them, and whether a monitoring system built
from these observations could tell. That takes the argument into bifurcation and
tipping behaviour, regime shift in ecosystem change and forest carbon flux, and
Markov chain Monte Carlo as the machinery for inference about a dynamical system
observed with error.

That does not displace the design-based against model-based distinction after
Pebesma. It subsumes it. Asking whether a system has changed regime is a
question about what the data can support, and the honest answer needs the
inferential frame the earlier chapters built. The final part therefore closes on
both, and the sentence the reader should be able to say at the end is that they
know the geometry, the support, the inferential frame, and what all three
together permit them to claim about whether the forest is the same forest.

The seed is planted in chapter 2, section 2.8, where the beetle and fire
signatures are introduced as measurements and the closing debate is named
without being attempted. Every disturbance chapter between there and the end
inherits the obligation to keep that thread live.

Two consequences follow for the outline and both need the author's decision.

The book's own library already holds the material. `chaos-in-beetle-outbreaks`
attempts an empirical bifurcation diagram for mountain pine beetle across eight
British Columbia regions spanning 6.7 degrees Celsius of mean annual
temperature, built from 1.17 million aerial survey polygons since 1961, and its
central result is that the archive supplies two period levels at 32.5 and 21.7
years whose ratio is 1.5, so a cascade needing at least three levels in ratios
near two is not detectable in 65 annual observations. That is an argument about
support seen from the temporal side and it belongs to this book's spine
exactly.

And the seventeen-chapter outline as briefed has no chapter that carries the
dynamical-systems argument. It is currently distributed across chapters 12, 13
and the final part. Either one of the last chapters takes it explicitly, or the
subtitle and the outline going to Elsevier promise something the manuscript does
not deliver.
