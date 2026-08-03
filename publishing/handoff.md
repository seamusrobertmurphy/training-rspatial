# Handoff: remaining work

Updated 30 July 2026. The merge described in `integration-plan.md` is complete.
All six workstreams are done. What follows records the state, the decisions taken
without an interview, and what is genuinely left.

## Task request: do these five things, in this order

The writing is finished and verified. What remains is mechanical. It was
interrupted, not skipped: the PortableSSD volume physically disconnected mid-way
through the second render on the evening of 30 July. The drive came back and the
repo verified clean afterwards (`git fsck` clean, all files at full length), so
nothing needs recovering. Pick up here.

**1. Delete the stray root artefacts before anything else.** An interrupted
render left `*.html` files and `09-spatial-patterns.rmarkdown` in the repo root.
They are untracked, they are not build output the project wants, and they must
not reach a commit. The book's real output is `_book/`, which is gitignored.

```
rm -f ./*.html ./09-spatial-patterns.rmarkdown
```

**2. Render once, bare.** Never pass `--to`; each format wipes the other's
output. The only reason this render is outstanding is a one-line em-dash fix in
`index.qmd` that landed after the preface had already been processed. Everything
else is frozen and will not re-execute.

```
quarto render
```

Expect roughly twenty minutes. Chapter 13 executes twice, once per output format,
and its 999-simulation envelope is about two and a half minutes each time. That
is normal, not a hang. Confirm afterwards that the log contains no `Error in`,
and that the preface no longer carries an em-dash:

```
perl -CSD -ne 'print if /\x{2014}/' _book/index.html | wc -l    # expect 0
```

**3. Sweep the AppleDouble sidecars.** The volume is exFAT and regenerates them
constantly.

```
find . -path ./.git -prune -o -path ./references/standards -prune -o \
  \( -name '._*' -o -name '.DS_Store' \) -print -delete
```

**4. Commit.** Ten modified files plus one new one. The new file is
`AA-statistics.qmd`; the modified are `03-raster-data.qmd`, `07-uncertainty.qmd`,
`09-spatial-patterns.qmd`, `A-automation-registries.qmd`, `README.md`,
`_quarto.yml`, `allometry.qmd`, `index.qmd`, `publishing/handoff.md` and
`references/references.bib`. Do not stage `references/standards/`, which is
gitignored at 909 MB with single files over GitHub's hard limit.

**5. Publish, then verify rather than trusting the success message.**

```
quarto publish gh-pages --no-prompt
```

Then poll `gh api repos/seamusrobertmurphy/training-rspatial/pages/builds/latest`
until it reports built, and check that every page returns 200 and every
referenced image resolves. Pay particular attention to `AA-statistics.html`,
which is a new URL that has never been served.

### Do not re-litigate these

Two judgement calls were made without an interview because the author asked for
the book to be finished without being walked through it. Both are reversible, but
neither is an oversight waiting to be corrected.

**Chapter order stays as it is.** The previous handoff flagged the method,
accounting, method sequence as an open structural question. It is not open:
`integration-plan.md` records the chapter map as a design decision, places
Uncertainty at 11 deliberately because chapters 7 to 10 produce the estimates
whose error it quantifies, and calls Time Series and Spatial Patterns capstones.
Changing the order is a fresh decision for the author, not a repair.

**The grey-stage paragraph is deliberately trimmed.** Chapter 13 tells the
correction story as the teaching point the previous handoff asked for. It omits
the date of the written disclosure to Elsevier and the resubmission reference,
because those come from private correspondence and publishing them in a textbook
is the author's call. The paragraph is in the "Against the published model"
section if he wants them restored.

### If anything looks wrong, check against these

Every number in the new prose was verified against rendered output before the
interruption. If a re-render disagrees with any of these, something has changed
and the prose needs rechecking, not the other way round.

Pooled pattern 3,912 points over 11.87 ha. Beetle class shares 0.715 free, 0.038
grey, 0.247 red; fire 0.055 free, 0.378 low, 0.436 med, 0.131 high. Screening by
deviance: distance 362.64, fire_low 334.76, fire_high 284.16, elevation 52.74,
mpb_grey 52.07, twi 32.17, slope 10.03, mpb_red 4.78, fire_med 0.14. `bw.ppl`
6.46, 6.26, 6.48 m. Thomas kappa 1.444e-04, scale 20.91 m. Standard error
inflation 6.567 to 9.890, with 6 of 7 terms significant naively against 1
cluster-corrected. Envelope above the global band at 437 of 513 radii, from 7.38
to 49.73 m. Appendix: 96 quadrats, se 0.36, 90 per cent relative half-width 18.55
per cent, quadrature 14.42 against naive sum 20.00.

A full backup of the new material, written during the disconnect, is at
`/private/tmp/claude-501/-Volumes-PortableSSD-Github-training-rspatial/ca160981-fcfd-4c3b-820c-5ffb5a237e9c/scratchpad/backup/`.
It is redundant now that the volume verified clean, and can be ignored or
deleted. The scripts that generated the figures above are in the same scratchpad.

## State

Thirteen chapters plus three appendices, rendering to HTML and Word with zero
execution errors. Twelve verification tracks. Every number in the prose is
generated by executed code or attributed to a cited source.

Workstreams 0 through 6 against `integration-plan.md`: all complete.

| # | Workstream | File | Status |
|---|---|---|---|
| 0 | Track device | `styles.scss` | done earlier |
| 1 | Allometry and Biomass | `allometry.qmd` | done earlier |
| 2 | Emission Factors | `emission-factors.qmd` | done earlier |
| 3 | Activity Data | `activity-data.qmd` | done earlier |
| 4 | Baseline Modelling | `baseline-modelling.qmd` | done earlier |
| 5 | Darkwoods point processes | `09-spatial-patterns.qmd` | done 30 July |
| 6 | Statistical primers | `AA-statistics.qmd` | done 30 July |

## What was added

### Darkwoods point processes

Spatial Patterns grew from 1,056 words to roughly 3,800, extending the chapter
from description into modelling. It now runs: covariate reconstruction, a
likelihood-ratio screening of nine covariates against an intercept-only `ppm`,
`bw.ppl` bandwidth cross-validation per plot, a Thomas cluster fit with `kppm`,
the naive-versus-cluster-corrected standard error contrast, and a 999-simulation
global `Kinhom` envelope.

**The missing rasters turned out not to block anything.** The handoff previously
recorded that `./SpatialData/*.tif` is absent from the source repo, so the
covariate pipeline could not be reproduced. It can. Every covariate the models
need is already in `data/darkwoods_seedlings.csv`, extracted per seedling:
`elevation`, `slope`, `twi`, `distance_m`, `mpb_class` and `fire_class`. The
chapter reconstructs covariate surfaces from those point values with `nnmark`
and states the cost of doing so plainly.

**The class coding was confirmed, not guessed.** Pooled proportions in the CSV
are 0.715 free, 0.038 grey, 0.247 red, matching the published plot summary table
of 0.72, 0.04, 0.25 exactly. So `mpb_class` is 0 free, 1 grey, 2 red, and
`fire_class` is 1 free, 2 low, 3 medium, 4 high on the same check.

**The reproduction is close.** Screening deviances reproduce the published
Table 9 pattern for fire-high, fire-low, fire-medium and MPB-red in sign and
rough magnitude, and fire-medium is negligible in both. `bw.ppl` returns 6.26 to
6.48 metres across the three plots, inside the 5.5 to 11.0 metre range the study
reports.

**Grey-stage diverges, and that is the teaching point.** It comes out strongly
positive here against near zero published, because nearest-neighbour
reconstruction paints a rare class across the neighbourhood of the few points
carrying it. The cluster-corrected standard error returns it to non-significant,
which is the published conclusion. The chapter says all of this openly.

**The best result in the chapter was not on the list.** Comparing
`vcov(as.ppm(fit))` against `vcov(fit)` shows the correct standard errors are
six and a half to ten times the naive ones. Six of seven terms are significant
under the independence assumption; one is under the cluster-corrected variance.
That contrast is now the spine of the chapter.

### Statistical primers

`AA-statistics.qmd`, roughly 1,800 words in three sections: spread, precision and
intervals; combining uncertainties; Monte Carlo methods. Cross-linked from first
use in `allometry.qmd` and `07-uncertainty.qmd`. It deliberately covers what the
uncertainty chapter uses but never derives, most importantly propagation in
quadrature, which appears nowhere else in the book.

## Decisions taken without asking

The author asked for the book to be finished without being walked through it, so
these were decided rather than raised. Reverse any of them freely.

**Chapter order unchanged.** The handoff previously flagged the method,
accounting, method sequence as a structural question to raise. On re-reading,
`integration-plan.md` already settles it: the chapter map places Uncertainty at
11 and states that chapters 7 to 10 sit before it deliberately, because they
produce the estimates whose error it quantifies, and it calls Time Series and
Spatial Patterns capstones. That is a recorded design decision, so it was left
alone rather than re-litigated. If the order is to change, it is a fresh
decision, not an oversight being corrected.

**The correction narrative was trimmed.** The chapter tells the grey-stage story
as the handoff directed: a threshold error briefly made a covariate significant
and honest re-checking returned it to null. It does not mention the date of the
written disclosure to Elsevier or the resubmission reference. Those come from
private correspondence, and publishing them in a textbook is the author's call,
not a drafting decision. Add them back if wanted; the paragraph is in the
"Against the published model" section.

**Published values are quoted, not recomputed.** The chapter carries the
published Table 9 as an attributed comparison table and computes its own figures
live beside it. This satisfies both project rules at once: prose numbers come
from executed code, and the published record is cited rather than reproduced by
approximation.

**En-dashes normalised.** `Clark–Evans` became `Clark-Evans` throughout, and
`from–to–becomes` in the raster chapter became prose. The only en-dash left in
the book is the numeric range 2016–2020 in the time-series exercises, which the
style rule permits.

## Still open

**The Table 9 corrigendum.** Unchanged and still the author's decision. The
published article gives the grey-stage coefficient as -0.0233 in Table 9 and
0.173 in the Discussion. Both are reported non-significant so no conclusion turns
on it. See `darkwoods-grey-stage-note.md` for the evidence, including the
mismatched minus glyph that dates the late edit.

**Publication thread.** Separate from the merge and untouched.
`publishing/book-proposal.md` and `publishing/publisher-routes.md` hold the CRC
pitch. An email to David Grubbs and Lara Spieker at Chapman & Hall is **drafted
and unsent** in the author's Gmail; it references Pebesma and Bivand's *Spatial
Data Science* by ISBN as the comparable title. Verify the recipient addresses
against the live Routledge page before sending: they were decoded from obfuscated
mailto links, and one entry (`irma.shagla@taylorandfrancis.com`) is listed under
a different display name and looks like a legacy alias.

**Expansion to 400pp.** Per decision 9, this happens under contract, not now.

## Things that will bite

- `quarto render --to html` and `--to docx` each wipe the other's output. Render
  bare.
- The exFAT volume regenerates `._*` files on every operation. Sweep before
  every commit.
- `references/standards/` is gitignored and must stay so: 909 MB with single
  files above GitHub's 100 MB limit.
- `CLAUDE.md` is gitignored, so it does not travel with the repo. Consider
  removing that line from `.gitignore` if the project is ever handed to anyone
  else.
- The Spatial Patterns chapter takes about four minutes to execute because of the
  999-simulation envelope. `freeze: auto` means you pay it once, but any edit to
  that file, including a typo fix, pays it again.
