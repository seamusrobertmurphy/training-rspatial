# Darkwoods grey-stage correction: authoritative values

Resolved 30 July 2026 from the proof correspondence and the published article.
This supersedes the `darkwoods_seedlings.Rmd` source in the training repo, whose
`kppm` interaction formula predates the correction.

## What happened

During revisions requested by Reviewer 2, the point-process analysis was re-run,
which required recomputing the Monte Carlo envelopes and refitting the Cox
process models. A value-threshold error in the grey-stage beetle layer entered
during that rebuild and mis-stated the extent of grey-stage attack. The layer was
corrected, verified against an independent red-stage reference, and the affected
models refitted. Disclosed to Elsevier in writing on 19 June 2026 before
resubmission (FORECO 123985).

The error briefly rendered the grey-stage covariate significant. It was
non-significant in the originally reviewed model and the corrected refit returns
it to non-significant. The red-stage reduction in lodgepole pine is unchanged, so
the correction reinforces the paper's conclusions rather than altering them.

## Published values (Forest Ecology and Management 618:123985)

**Grey-stage derivation, Section 2.4.** A pixel is grey-stage if it carried a
red-attack NDMI classification in any year between 2005 and 2011, so at least
four years had elapsed by the 2015 Mt Midgeley fire for needle fall and crown
collapse. This satisfies the operational 3 to 15 year window of Carlson et al.
(2017). The 2012 annual raster is absent from the archive, so a pixel attacked
only in 2012 and not re-registered in 2011 or 2013 is not captured. Detections in
2013 and 2014 are retained as red-stage only, because needle fall is incomplete
within two years of attack. Stored as `mpb_grey_na.tif` on the 30 m native grid,
entered as a binary covariate (1 grey, 0 not grey).

**Extent.**

| Scope | Cells (30 m) | Area |
|---|---|---|
| Region-wide | 1,541 | 138.7 ha |
| Plot 1 | 18 | 1.62 ha |
| Plot 2 | 47 | 4.23 ha |
| Plot 3 | 3 | 0.27 ha |
| Plots pooled | 68 | 6.12 ha |

Plot counts use all-touched edge inclusion, so cells straddling the 200 m by
200 m plot boundary are counted; the pooled figure therefore exceeds what a
strict within-boundary count would give.

**Coefficients, Table 9 (likelihood ratio test of covariate importance).**

| Covariate | beta | Deviance | LR test |
|---|---|---|---|
| MPB-grey | -0.0233 | 0.47 | 0.492 (not significant) |
| MPB-red | -0.1461 | 14.85 | 0.001 *** |
| Fire-high | -0.6430 | 211.64 | 0.001 *** |
| Fire-low | 0.5682 | 276.87 | 0.001 *** |
| Fire-med | 0.0188 | 0.34 | 0.563 (not significant) |

Species-level red-stage effects, unchanged by the correction: lodgepole pine
beta = -0.167, p < 0.001; western white pine beta = -1.151, p < 0.05.

## Two things to check

**A numerical inconsistency survives in the published text.** Table 9 gives the
grey-stage coefficient as -0.0233. The Discussion, in the passage beginning
"whereas grey-stage outbreaks showed no significant negative associations", gives
it as 0.173. These differ in both magnitude and sign. Both are reported as
non-significant so no conclusion turns on it, but the published record disagrees
with itself. This is the signature of a late edit that updated the table and
missed the prose, and it is worth deciding whether to seek a corrigendum.

**Physical evidence of the late edit.** In Table 9 every negative coefficient is
typeset with the same minus glyph (U+2198 as extracted) except MPB-grey, which
uses an ASCII hyphen-minus (U+002D). One cell in that table was hand-edited in a
different pass from the rest, consistent with the correction timeline.

## Consequence for the textbook

Chapter 13 must reproduce the published, corrected values above. The
`darkwoods_seedlings.Rmd` source in the training repo predates the correction and
its interaction formula repeats `mpb_red_im*fire_high_im` while never using
`mpb_grey_im*`, so it cannot be ported as-is. Fit the grey-stage main effect from
the corrected layer and report it as non-significant, which is the teaching point
anyway: a covariate that a threshold error briefly made significant, and that
honest re-checking returned to null.
