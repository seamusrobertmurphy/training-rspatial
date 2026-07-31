# Handoff: remaining work

Written 30 July 2026 at the end of a long session, so that the two outstanding
chapters can be written from disk without reconstructing anything from
conversation.

## State

Thirteen chapters plus two appendices, about 19,000 words of prose, 34 figures,
eleven verification tracks, rendering to HTML and Word with zero execution
errors. Live and verified.

Merge progress against `integration-plan.md`: workstreams 0 through 4 are done
(track device, allometry, emission factors, activity data, baseline modelling).
Two remain.

## Remaining item 1: Darkwoods point processes

Extends Spatial Patterns from description to modelling. The chapter currently
stops at Ripley's K, nearest neighbour and Clark-Evans.

**Source material** is in `/Volumes/PortableSSD/Github/training/darkwoods_seedlings/`.
The `.Rmd` has the code; the committed `README.md` beside it has rendered console
output including full model summaries, so fitted coefficients can be checked
without re-running anything.

What to add, in rough order of value:

1. Covariate-driven `kppm` Thomas cluster fits, with terrain, climate and
   disturbance covariates, epanechnikov kernel, isotropic correction, and a
   bandwidth from `bw.ppl` likelihood cross-validation.
2. Likelihood-ratio screening of covariates against an intercept-only `ppm`,
   which is the model-selection step and small enough to reproduce whole.
3. Monte Carlo envelope tests with `Kinhom`, 999 simulations, global envelopes.
4. The naive-versus-cluster-corrected standard error contrast in
   `summary(kppm)`, which is an excellent teaching point about why clustering
   inflates uncertainty and why a naive standard error is wrong here.

**Read `publishing/darkwoods-grey-stage-note.md` first.** It records the
published, corrected grey-stage figures and two things that matter:

- The source `.Rmd` predates the correction. Its `kppm` interaction formula
  repeats `mpb_red_im*fire_high_im` twice and never uses `mpb_grey_im*`, so
  grey-attack interactions are absent from all eight fits. It cannot be ported
  as written.
- The published article is internally inconsistent on the grey-stage
  coefficient: Table 9 gives -0.0233, the Discussion gives 0.173. Both are
  reported non-significant so no conclusion turns on it. The author has been
  told; the corrigendum decision is theirs.

Reproduce the published values, not the repo's. The teaching point is a good one
in its own right: a covariate that a threshold error briefly made significant,
and that honest re-checking returned to null.

Note the source rasters (`./SpatialData/*.tif`) are **not in that repo**, so the
covariate pipeline is not reproducible as-is. Either simulate covariates over the
plot footprint in the book's usual way, or restrict the chapter to what
`darkwoods_seedlings.csv` supports, which is already in `data/`.

## Remaining item 2: statistics appendix

Source is the primers in the uncertainty ebook's `index.qmd`
(`/Volumes/PortableSSD/Github/training/uncertainty/index.qmd`), roughly 1,900
words including the preface material that is not needed.

Three sections: distributions, standard error and confidence intervals;
propagation in quadrature; Monte Carlo methods. Cross-link from first use in the
allometry and uncertainty chapters. Per decision 7 these are an appendix, not a
chapter, so the chapters keep moving and the rusty reader has somewhere to go.

## A structural question to raise, not to answer unilaterally

The book currently runs method (1-6), accounting (7-10), then back to method
(11-13). Uncertainty, Time Series and Spatial Patterns sit after the accounting
chapters because that is where they already were, not because anyone decided it.

There is a case for moving Uncertainty to immediately follow the accounting
chapters it serves, or for moving Time Series and Spatial Patterns earlier so the
book does not switch register twice. There is also a case for leaving it, since
the two capstones genuinely are capstones and belong at the end.

This was not among the nine decisions taken in the design interview. Ask before
reordering; it is cheap to do (`_quarto.yml` order only, filenames unchanged) and
expensive to do twice.

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

## Publication thread

Separate from the merge. `publishing/book-proposal.md` and
`publishing/publisher-routes.md` hold the CRC pitch. An email to David Grubbs and
Lara Spieker at Chapman & Hall is **drafted and unsent** in the author's Gmail;
it references Pebesma and Bivand's *Spatial Data Science* by ISBN as the
comparable title. Verify the recipient addresses against the live Routledge page
before sending: they were decoded from obfuscated mailto links, and one entry
(`irma.shagla@taylorandfrancis.com`) is listed under a different display name and
looks like a legacy alias.
