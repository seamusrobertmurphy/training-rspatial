# Chapter 9, calibration and validation

Drafting began 20 September 2026 at `drafts/09-calibration-validation.qmd`. The
4 September page for this chapter in `00-all-chapters.md` stands, and this file
records what the chapter is built on and what it measured.

## The question

When is a wall to wall map an estimate, and what evidence shows that it is?

## Why these datasets

The 4 September brief said the chapter had no worked example of its own and
needed real plots over real lidar. Three candidates were named, the Gisborne
stand attributes, the United States Forest Inventory and Analysis plots with
their perturbed coordinates, and the enhanced forest inventory pipelines. All
three were set aside. The first and third are engagement work, which the
6 September exclusion covers, and the Forest Inventory and Analysis coordinates
are perturbed by design, which would confound a calibration with a positional
error the chapter is not trying to measure.

Two public pairings replaced them, both of field plots with airborne laser
scanning, and both committed to the repository.

The first is the Smithsonian Conservation Biology Institute census, already the
book's dataset in chapters 1, 6 and 7, under the United States Geological Survey
lidar project VA_NShenandoah_1_2020. The census's own 20 by 20 metre quadrats are
the field plots, which is the support chapter 6 handed forward, and the
alignment between the census grid and the laser is 4 centimetres, so nothing in
the result turns on registration.

The second is Quebec's permanent sample plot network under the province's open
lidar canopy height models, both published under Creative Commons Attribution
4.0. It brings what the first cannot, structural variation across managed and
unmanaged stands, conifer as well as hardwood, and flights whose season is
recorded.

## What the chapter measured

To be completed when the second site's numbers are in. The first site's results
are settled and are these.

Basal area at 20 metre support correlated 0.16 with the 95th percentile of
canopy height across 640 quadrats, and cross-validated models had no skill, an
explained variance of 0.017 for a linear model and below zero for a random
forest.

The same random forest scored on the data it was fitted to reported a root mean
square error of 6.6 square metres per hectare against an honest 14.68, so the
in-sample figure flattered the model by a factor of 2.2. The commonest way to
produce that number by accident is an argument name, because several prediction
functions take new data through `newdata` and silently ignore it when it arrives
as `data`.

Blocked folds and random folds agreed to within 0.4 per cent, which is the
expected result rather than a reassuring one, because a model with no skill has
no borrowed neighbourhood information to lose.

The cause is in the flight rather than in the fitting. The point cloud's
timestamps put the acquisition on 9 and 10 December 2020 over a deciduous
forest, so the laser measured bare branches.

Against the American Carbon Registry's Framework for Remotely Sensed
Quantification of Forest Carbon, version 1.0 of 27 March 2026, now held at
`references/standards/ACR/Remote Sensing/`, the model failed the first test at
42.9 per cent against a limit of 20 and passed the second at 2.79 per cent
against a limit of 10. The two tests are not independent. Equation 5 divides the
root mean square error by the square root of the plot count, so any model inside
the first test satisfies the second from 11 validation plots upward, where
20 per cent times 1.645 over the square root of 11 is 9.92 per cent.

## Boundaries held

Chapter 6 owns the design of the plot network. Chapter 7 owns the allometric
equation, so the response here is basal area, which is measured rather than
modelled, and no biomass column is written by either preparation script.
Chapter 8 owns the error budget that carries a plot estimate to a landscape
total. Chapter 10 owns the classified map and its confusion matrix.

## What the chapter owes the spine

Support on both sides of the fit. The field value is a sum over a quadrat and
the predictor is a summary of laser returns over the same ground, and chapter 6
measured what that mismatch costs, a map correlating 0.90 with basal area at
20 metre quadrat support and 0.47 at plot support.

## Sources

`CAST` for the area of applicability and for nearest neighbour distance
matching, `blockCV` for blocked folds, and the five method papers verified
against CrossRef on 20 September 2026 and listed at the foot of
`publishing/research-integration-blueprint.md`.
