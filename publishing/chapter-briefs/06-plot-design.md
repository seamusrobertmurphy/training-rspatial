# Chapter 6, field plot design

Drafted 8 September 2026 at `drafts/06-plot-design.qmd`, 3,909 words of prose
over thirteen sections and one verification track, rendering in both formats.
Every number in the prose is computed by a chunk on the page.

## The question

What does the next field plot buy, and when does it buy nothing worth having?

## Why this dataset

The Smithsonian Conservation Biology Institute ForestGEO census is committed to
the repository at `data/scbi_stems.csv` and needs no network. It holds 38,517
stems with surveyed positions on a 400 by 640 metre grid, which makes it the one
dataset in the library where a sampling design can be marked against a known
answer rather than defended by an argument. Every design in the chapter was run
two thousand times and its estimates compared against the census.

Basal area is the response throughout, not biomass, because it is measured
rather than modelled. That keeps the allometric equation and its error inside
chapter 7 where they belong.

## What the chapter measured

The estimator was unbiased at every sample size and the nominal 90 per cent
interval covered between 89.3 and 91.6 per cent of the time, so the textbook
arithmetic does what it claims.

Forty plots returned a median 90 per cent half-width of 10.1 per cent against a
10 per cent threshold and passed it in 46 per cent of draws. Fifty-five plots,
38 per cent more fieldwork, passed 95 per cent of the time. A sample size
computed from the standard formula targets the median, so a project installing
exactly that number has designed an inventory that fails about half the time.
This is the chapter's edge and it is the honest version of the brief's claim
that eligibility is a random variable.

A systematic 5 by 8 grid was 11 per cent more precise than simple random
sampling and could not report the fact, because no unbiased variance estimator
exists for a single random start.

Stratifying on a deliberately imperfect map lifted the pass rate from 46 per
cent to 77 for no extra fieldwork, with coverage between 88.3 and 90.4 per cent
so the narrower interval was earned. The gain scaled with the map's correlation
with basal area at plot support, which was 0.47 where the same map correlated
0.90 at 20 metre quadrat support. That support mismatch is the chapter's hand to
chapter 9.

The 400 square metre plot beat 100, 1000 and 2000 square metre plots at a fixed
1.6 hectares of ground measured, passing in 50 per cent of draws against 18, 33
and 20.

Dropping the diameter threshold from 10 centimetres to 1 raised the stems
measured per plot from 13.3 to 60.2 and took 1.7 percentage points off the
coefficient of variation.

## The correction this chapter makes to its own brief

The 4 September brief said positional accuracy compounds sampling error because
a five metre fix on a 400 square metre plot moves which trees are in it. That is
true and it is not why the fix matters. Displacing every plot centre by a
standard deviation of 20 metres, nearly twice the plot radius, left the estimate
unbiased and moved the spread of estimates by 3.4 per cent, because a randomly
placed plot moved at random is still a randomly placed plot.

The fix decides everything for a permanent plot instead, where growth is a
paired comparison between two visits to the same trees. A three metre relocation
error dropped the signal-to-noise ratio on a growth estimate from 16.5 to 0.66,
so the noise became larger than the increment. That is the justification for
monumenting a plot with rebar, and it is the paired comparison rather than the
tree list.

## Boundaries held

Chapter 6 owns the design and the field measurement. Chapter 7 owns the
allometric equation. Chapter 8 owns scaling a plot mean to a landscape and the
error budget. Chapter 9 owns fitting a remotely sensed predictor to these plots
and validating it. Nothing in chapter 6 converts a diameter into mass.

## What is still missing

The stratifier is synthetic, being true quadrat basal area with noise added. A
real canopy height model over Front Royal would make the same argument without
the caveat and would connect the chapter to chapter 4 directly. No lidar
coverage of the plot is committed.

The 3 per cent growth increment is imposed rather than observed, and it is the
only simulated quantity in the chapter. The 2013 and 2018 SCBI censuses would
supply a real increment on the same stems. Only 2008 is committed.

Variable-radius sampling with an angle gauge, which dominates North American
operational inventory, is not covered and would fit either this chapter or
chapter 8.

## Sources

`data/scbi_stems.csv`, rebuilt by `data-raw/prepare-scbi-data.R`. The library
repositories named in the 4 September brief, `darkwoods_seedlings`,
`gisborne-forest-stocking-density`, `GPS-training-material`, `survey-tools`,
`shinyapp-scaling-forest-inventory-data` and `sop-library/sop-plot-grid`, were
not needed for the draft and remain available for the field protocol material if
the chapter is later extended.
