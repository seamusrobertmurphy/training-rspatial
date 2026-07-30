# Integration Plan: Uncertainty Ebook into the R-Spatial Textbook

Agreed 30 July 2026. Nine decisions, taken in order, each constraining the next.

## Standing constraints

1. **Do not touch the uncertainty book's publication.** Not
   `training-resource.github.io/uncertainty`, not either quarto.pub site
   (`/uncertainty`, `/redd-uncertainty-training`), not
   `github.com/seamusrobertmurphy/uncertainty`. Retirement happens only after the
   author has reviewed the merged textbook and said so explicitly. Until then the
   ebook stays live and untouched, and the merge only ever adds to this repo.
2. **The book renders offline.** No chapter may require network access to build.
3. **Existing URLs stay valid.** Quarto numbers chapters by their order in
   `_quarto.yml`, not by filename, so renumbering costs nothing as long as
   existing files keep their names.

## The nine decisions

| # | Question | Decision |
|---|---|---|
| 1 | Fate of the ebook | Full merge; retirement deferred pending review |
| 2 | What the book is | Two-audience, method for all readers plus boxed verification tracks |
| 3 | Structure | Flat, thirteen chapters plus appendices; no Parts |
| 4 | Reference-data depth | Teach selection, extract illustratively, cite the source table |
| 5 | Classification code | `terra` + `ranger` in the main text, `sits` in the verification track |
| 6 | Voice | Full rewrite of all imported prose to teaching register |
| 7 | Statistics prerequisites | Assumed in chapters; primers moved to Appendix A |
| 8 | Sequence | Track device first, then allometry, then the rest |
| 9 | Endpoint | The merge is the deliverable; expansion to 400pp happens under contract |

## Chapter map

New chapters take descriptive filenames with no numeric prefix, so that a file
prefix never contradicts a chapter number. Existing files keep their names.

| Ch | Title | File | Source |
|----|-------|------|--------|
| 1 | Getting Started | `01-getting-started.qmd` | existing |
| 2 | Vector Data | `02-vector-data.qmd` | existing |
| 3 | Raster Data | `03-raster-data.qmd` | existing |
| 4 | Terrain and Hydrology | `04-terrain-hydrology.qmd` | existing |
| 5 | LiDAR and Point Clouds | `05-lidar-point-clouds.qmd` | existing |
| 6 | Disturbance and Risk | `06-disturbance-risk.qmd` | existing |
| 7 | Allometry and Biomass | `allometry.qmd` | ebook ch1, 4,972 w |
| 8 | Emission Factors | `emission-factors.qmd` | ebook ch2, 5,385 w |
| 9 | Activity Data and Classification | `activity-data.qmd` | ebook ch3, 6,509 w |
| 10 | Baseline Modelling | `baseline-modelling.qmd` | mostly new writing |
| 11 | Uncertainty | `07-uncertainty.qmd` | existing + ebook ch4 |
| 12 | Time Series | `08-time-series.qmd` | existing |
| 13 | Spatial Patterns | `09-spatial-patterns.qmd` | existing + Darkwoods `kppm` |
| A | Statistical Primers | `AA-statistics.qmd` | ebook index.qmd primers |
| B | Automation, Protocols, Registries | `A-automation-registries.qmd` | existing |

Chapters 7 to 10 sit before Uncertainty deliberately: they produce the estimates
whose error Chapter 11 then quantifies, and the metrics and cross-validation
sections already in Chapter 11 refer back to allometric fitting.

## The verification track

A purpose-built div, not a recycled callout. The ebook already spends its
callouts on ordinary emphasis (13 tips, 8 importants), so reusing them would
carry no signal.

```markdown
::: {.verification}
#### Under VM0048 {.unnumbered .unlisted}
Registry-specific rule, citation, deduction arithmetic.
:::
```

**The `{.unnumbered .unlisted}` on the heading is required, not optional.**
Without it Quarto folds the div into a numbered `<section>`, so the track picks up
a section number (7.5.0.1) and appears in the table of contents, which defeats the
point of a skippable aside. Verified on the Chapter 11 retrofit.

In Word the div passes through unstyled: the content is present and readable but
carries no box. Acceptable, since HTML is the primary format.

Styled in `styles.scss` against the existing `$brand-slate`: left rule, tinted
ground, small-caps label. Collapsible in HTML, retained inline in Word.

**The governing rule: a reader who skips every verification track must still get
a complete and coherent book.** Nothing in the main narrative may depend on
material inside a track. Tracks carry registry rules and standard citations,
deduction arithmetic tied to a named methodology, and operational tooling too
heavy for the core (`sits`). They never carry a definition, a method step, or a
result the following section needs.

## Workstreams, in order

### 0. Track device
Add `.verification` to `styles.scss`, prove it by retrofitting the ART deduction
material already in Chapter 11. Small, and it de-risks the hardest design choice
before any content depends on it.

### 1. Allometry and Biomass (ch 7)
Source: ebook ch1 (4,972 w), already running on `scbi_stem1.csv`, the same SCBI
plot as the textbook, plus `eq_tab_acer.csv` already in `data/`. Covers equation
forms, `allodb` equation selection, model selection, diagnostics
(normality, Breusch-Pagan, heteroscedasticity), Baskerville correction.
Cross-validation and metrics are already written in Chapter 11 and must be
cross-referenced, not repeated. Verification track: ART Equation 11 deduction.

### 2. Emission Factors (ch 8)
Source: ebook ch2 (5,385 w, zero code chunks). Trims to roughly 2,500 words under
decision 4: teach stratification and factor selection, reproduce short extracts
as worked examples, cite IPCC 2006 Vol 4 Ch 5 for the full tables. Adds the
worked arithmetic as runnable R, which the ebook lacks entirely. Verification
track: double-counting rules and SOC timelines.

### 3. Activity Data and Classification (ch 9)
Source: ebook ch3 (6,509 w). Main text rebuilt on `terra` + `ranger` over the
SCBI footprint: training design, confusion matrix, probability surface,
per-pixel uncertainty, active-learning sampling of high-uncertainty pixels.
Verification track: the operational `sits` workflow on
`samples_deforestation_rondonia`, shown with `eval: false` and pre-rendered
figures. The data-cube geometry and temporal normalisation from this chapter are
already integrated into Chapter 12 and must not be duplicated.

### 4. Baseline Modelling (ch 10)
Mostly new writing. The survey found the author's existing material across
VM0048, the TREES repos and VM0010 builds reference levels as a plain arithmetic
mean of historical years, with no trend fitting, no forward projection, no
dynamic-versus-static treatment beyond a single sentence in VM0047, and no
leakage quantification equation anywhere. Reusable: the risk-allocation equations
in `deforisk.qmd` and the TREES Ecuador reference-level and reversal material.

### 5. Darkwoods point processes (ch 13)
Extends Spatial Patterns from description to modelling: covariate-driven `kppm`
Thomas fits, likelihood-ratio covariate screening, `bw.ppl` bandwidth
cross-validation, 999-simulation `Kinhom` envelopes. Source repo has rendered
output to check against.

**Blocker to raise first:** the `kppm` interaction formula in
`darkwoods_seedlings.Rmd` around line 1085 repeats `mpb_red_im*fire_high_im`
twice and never uses `mpb_grey_im*`, so grey-attack interactions are absent from
all eight fits. Confirm against the published manuscript before porting.

### 6. Appendix A, statistical primers
Source: ebook `index.qmd` primers. Distributions, standard error, confidence
intervals, propagation in quadrature, Monte Carlo. Cross-linked from first use in
Chapters 7 and 11.

## Cost and risk

The dominant cost is decision 6. Rewriting 22,000 words from report register to
teaching register is most of this project. Measured gap: the ebook runs 30.7-word
sentences against the textbook's 23.1, 28.8 acronyms per thousand words against
10.0, and addresses the reader 4 times against 49.

| Risk | Mitigation |
|---|---|
| Tracks read as bolted on | Prove the device on one chapter before committing content to it |
| Standards text permissions | Decision 4 keeps reproduction to short extracts; flag to the editor early |
| Duplication with already-merged material | Cube geometry, metrics and cross-validation are done; cross-reference only |
| Darkwoods formula bug | Verify against the manuscript before porting |
| Book stops rendering offline | `sits` confined to `eval: false` track blocks |

## Definition of done

Thirteen chapters and two appendices rendering to HTML and Word with zero
execution errors; every figure generated by code that runs offline; roughly
30,000 words of prose; the verification track applied consistently; the
uncertainty ebook still live and untouched, pending the author's review.
