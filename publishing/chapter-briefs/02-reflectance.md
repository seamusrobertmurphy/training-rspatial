# Chapter 2 brief

Dictated 5 September 2026. Working title **Reading Reflectance, and What an
Index Can Support**. Subject is optical remote sensing at the level of the band,
the retrieval that produced it, and the index built on top of it.

## The question

What claim can a spectral index actually carry, and where does it fail without
saying so?

## Why it sits here

Chapter 1 settled where a measurement is. Chapter 2 settles what a measurement
is. Every later chapter that maps a class, dates a disturbance or estimates a
biomass runs on a number that arrived through the chain this chapter opens, and
almost no project document states which link in that chain it trusted. The
chapter is the first place a reader meets the idea that a reflectance value is a
retrieval with its own error rather than an observation.

## What it must not become

The book has three other chapters on optical data and each owns a boundary that
this one does not cross.

1. Chapter 2 owns a single observation. One date, one scene, the bands and the
   indices built from them.
2. Chapter 10 owns the label and the confusion matrix, and every accuracy
   statistic that follows from a classifier.
3. Chapter 11 owns the difference between two dates and the attribution of a
   cause to it.
4. Chapter 12 owns the time axis, compositing, aliasing and the cube.

Anything that needs a second date to make its point is not chapter 2. The one
deliberate exception is the atmospheric demonstration in section 7, which uses
two dates precisely to show that a difference between them can be entirely
atmospheric, and that exception is what makes chapter 11 possible.

## Structure

Nine numbered sections and a set of exercises, about twenty-three printed pages,
which is the series median and half of what chapter 1 currently runs.

**2.1 Introduction.** The chain from photon to reported number, stated once in
full so the reader knows what the chapter is dismantling. The Landsat record
opened in 1972 and has not stopped, which makes it the longest continuous
measurement of the land surface in existence, and the reason optical data
carries the historical baseline of nearly every forest carbon project.

**2.2 Spectral response.** Why the contrast between red and near infrared is a
physical measurement of living tissue rather than a convention. Chlorophyll
absorbs strongly around 665 nm; the internal cell wall and air space structure
of a leaf scatters near infrared around 842 nm almost without absorbing it.
Measured on the committed scene, intact forest reflects 0.026 in the red and
0.296 in the near infrared, a ratio of 11.4, while cleared ground with bare soil
reflects 0.079 and 0.261, a ratio of 3.3, and open water reflects 0.102 and
0.058, so its near infrared falls below its red and its normalised difference
turns negative. Those three signatures are the whole of optical remote sensing
in one table, and the reader computes them rather than being shown them.

**2.3 Reflectance retrieval.** Top of atmosphere against bottom of atmosphere,
what an atmospheric correction is asked to remove, and why the result is called
a retrieval. The processing baseline is introduced here as a fact about the
product rather than a footnote: Sentinel-2 processing baseline 04.00 entered
operations on 25 January 2022 and shifted the stored dynamic range by a
band-dependent constant, so that surface reflectance is recovered as
`(DN + BOA_ADD_OFFSET) / QUANTIFICATION_VALUE` and not as `DN / 10000`. The
consequence is measured rather than asserted. Applying the committed scene as
delivered and again with an offset of 1,000 digital numbers left unsubtracted,
mean forest normalised difference vegetation index falls from 0.837 to 0.515,
a shift of 0.322 on ground that did not change. The offset value is carried in
the product metadata and is read, never assumed.

**2.4 Band support.** The spine debt, paid at the level of the sensor. Sentinel-2
acquires the blue, green, red and broad near infrared bands at 10 m and the red
edge, narrow near infrared and two shortwave infrared bands at 20 m, and the
committed files sit on a common 20 m grid, so six bands were coarsened and none
was sharpened. A 30 m Landsat cell and a 10 m Sentinel-2 cell are not the same
measurement of the same ground. Aggregating the committed scene to 60 m, 6.5 per
cent of cells straddle the forest boundary and hold a value that describes
neither side. The order of operations is measured too, in that computing the index
from mean reflectance rather than averaging the index differs by a median of
0.0005 and by as much as 0.376 on individual cells. The obvious guess that the
worst cells are all at boundaries is tested and rejected. Mixed cells are 6.3
per cent of the scene and 31.5 per cent of the worst one per cent of
disagreements, over-represented fivefold but nowhere near all of it.

**2.5 Index construction.** Six indices computed from the committed bands, each
with the physical reason for its band pair stated in the sentence that defines
it: the vegetation index on red and near infrared, the moisture index on near
infrared and shortwave infrared 1, the burn ratio on near infrared and shortwave
infrared 2, the red edge index, the green index, and the enhanced vegetation
index with its blue term. Written as one function, since a normalised difference
is one operation applied to different pairs, which is a point about the family
and not about any member of it.

**2.6 Class separability.** The chapter's first hard result. Against the
committed nine-class map, clear-cut regrowth has a median vegetation index of
0.791 while forest has a median of 0.842 and a fifth percentile of 0.783, so the
regrowth median sits at the 6.7th percentile of the forest distribution. The
best single threshold, 0.813, reaches a balanced accuracy of 0.739 and still
calls 35.6 per cent of regrowth forest. The same test on the other three indices
ranks them in the reverse of the order projects reach for them: burn ratio
0.823, moisture index 0.802, red edge index 0.747, vegetation index 0.739. The index
everyone uses is the worst of the four at the job it is used for, because
regrowth differs from forest in canopy water and structure more than in
greenness, and those differences live in the shortwave infrared.

**2.7 Atmospheric sensitivity.** The chapter's second hard result and the reason
the two dates are committed. Under biomass burning smoke on 2 September 2022 the
same ground shows scene-mean blue reflectance 3.60 times its clear-date value,
green 2.43, red 2.49, near infrared 1.16 and shortwave infrared 2 1.30, because
scattering by fine aerosol falls off steeply with wavelength. Mean forest
vegetation index therefore falls from 0.837 to 0.554, and 99.8 per cent of
forest cells drop below the 0.813 threshold that worked on the clear date,
against 16.6 per cent on that date. The burn ratio, both of whose bands are long
wavelength, moves 0.021. The index that separates worst also breaks worst, and
the pairing of those two results is the chapter's thesis. The enhanced vegetation
index, whose blue term exists to resist aerosol, moves the wrong way and rises
0.098 on forest, because a coefficient of -7.5 on the blue band was calibrated
for a modest perturbation and heavy smoke drives its denominator down. A
correction outside its design range is not a weaker correction, it is a
different error.

**2.8 Disturbance signatures.** The section the closing arc is planted in, kept
to framing and worked examples rather than method. Insect attack and fire are the
two disturbances that dominate forest carbon landscapes and each has an optical
signature with a physical cause and a known failure. Mountain pine beetle
(*Dendroctonus ponderosae* Hopkins) kills the phloem, the needles lose water
in the red stage, the first twelve to twenty-four months after attack, while
sapwood and foliar moisture decline alongside the reddening, so which index to
use is an empirical question. Murphy et al. (2026) answered it by measurement,
selecting the normalised difference moisture index over the wetness, greenness
and brightness components of the tasselled cap transform to map red-stage attack
in the southern Selkirk Mountains. Its
overall accuracy of 0.824 in that study sits beside a commission error of 0.750
on the red-attack class itself, which is the whole of what this chapter has to
say about what an index can support: a headline accuracy dominated by the large
easy class, and three false alarms in four on the class the study was about.
Fire is the mirror case: the burn ratio was the strongest of five candidate
indices against field composite burn index scores, at an R-squared of 0.879,
because combustion removes canopy water and chars the surface, and both effects
move the shortwave infrared hard. The section closes by naming where the book is
going. A disturbance is an event in a system that has states, and the last part
of the book returns to these signatures as observations of a dynamical system
rather than as maps, taking up bifurcation and tipping behaviour, regime shift
in forest carbon flux, and Markov chain Monte Carlo as the machinery for
inference about such systems. Nothing of that is done here. It is named so the
reader knows the index they have just computed is the measurement the argument
will eventually rest on.

**2.9 Conclusions.** What the chapter established, in the register of the series.

## Owes the spine

A pixel has support. Section 2.4 pays it directly at the level of the sensor and
section 2.7 pays it again in a form the reader will not expect, because an
atmospheric state is a support condition on the value as surely as a cell size
is: the number describes the ground and the column of air above it, and the
retrieval is what tries to separate them.

## Data

Three files, all extracted by `data-raw/prepare-rondonia-data.R` from the
`sitsdata` package and committed, so the chapter needs neither network nor
`sits` to build.

1. `data/rondonia_s2_2022-07-16.tif`, ten Sentinel-2 Level-2A surface
   reflectance bands over the 20LMR window, 1,200 by 1,200 cells at 20 m in
   EPSG:32720, signed integers scaled by 10,000. The clear dry-season reference
   date, and the date the already committed NDVI file was computed from.
2. `data/rondonia_s2_2022-09-02.tif`, the same ten bands over the same ground
   under biomass burning smoke.
3. `data/sentinel2_bands.csv`, band centre wavelength, full width at half
   maximum and native ground sample distance, read on 5 September 2026 from the
   Microsoft Planetary Computer STAC collection description for
   sentinel-2-l2a, field `eo:bands`.

The already committed `rondonia_class_2022.tif`, `rondonia_legend.csv` and
`rondonia_validation.csv` supply the classes the separability tests run against.
Within the 20LMR window the nine-class map is 49.4 per cent forest, 14.0 per cent
clear cut with bare soil, 11.6 per cent wetland, 11.5 per cent water, 8.1 per
cent riparian forest, 2.9 per cent clear cut with regrowth, 2.1 per cent
seasonally flooded and 0.4 per cent clear cut and burned.

The class map is in EPSG:3857 at about 20.26 m and is projected onto the tile
grid by nearest neighbour before any extraction, which is stated in the chapter
because it is exactly the kind of step that usually is not.

## Sources

`training-rspatial/03-raster-data` supplies the Rondonia material this chapter
absorbs, and that file retires when the draft is promoted. Murphy et al. (2026),
*Forest Ecology and Management* 618, 123985, supplies the beetle and fire
signatures and their measured accuracies. `woolly-adelgid-signatures` supplies
the index set and the topographic illumination correction that precedes it.
VM0048 and VT0007 supply the registry framing that chapters 10 and 11 develop.

## Missing

Nothing blocking. Two items would improve it. A Landsat scene over the same
ground would let section 2.4 make the 30 m against 10 m comparison by
measurement rather than by aggregation, and the library does not hold one. And
the scene-classification layer that accompanies a Level-2A product is not in
`sitsdata`, so cloud masking is described and not executed, which is honest but
weaker than the rest of the chapter.
