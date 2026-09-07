# Session notes, 6 September 2026

Written at the end of the session, before a reboot. Two Claude sessions ran in
parallel today. This one compiled substantive content, structure and sequence;
the other revised prose for the accepted proposal's audience. Both committed to
`chapter-02-reflectance`.

## Where the book stands

Four chapters are drafted, render in both formats, and have every prose number
computed by a chunk on their own page.

| Draft | Words | Anchor dataset | State |
|---|---|---|---|
| `drafts/01-positional-accuracy.qmd` | ~6,600 | SCBI stems | restructured, then prose-revised |
| `drafts/02-reflectance.qmd` | ~3,800 | Rondonia Sentinel-2 | drafted, then prose-revised |
| `drafts/04-airborne-laser.qmd` | ~3,400 | lidR `MixedConifer.laz` | drafted, then prose-revised |
| `drafts/05-terrain-conditioning.qmd` | ~4,800 | Chilwa DEM, SoilGrids | drafted, then prose-revised |

Also `drafts/preamble.qmd` and `drafts/table-of-contents.qmd`, both rendering to
`drafts/_out` as docx for review.

## Decisions taken today, and standing

**Client material is excluded from the book in any form**, for copyright
reasons. `drafts/archive/` was deleted, every reference to the named engagements
was stripped, and git history was rewritten and force-pushed so the strings
appear in no commit. The published GitHub Pages site was checked and carries no
client identifier. `TREES-ecuador-repository` must not be used at all.

**Chapter 1 is not split.** Length is managed by cutting content through the
prose session, not by dividing chapters. Do not raise the split again.

**Chapter 4 ends at the height metric.** All plot-to-metric modelling moved to
chapter 9, which already owned calibration and spatially blocked
cross-validation and had no worked example. This removed the simulated plot data
and synthetic species raster from chapter 4 without needing new data.

**Wetland organic soils are built from the IPCC primary source over Chilwa**,
not from client repositories with the country renamed. Renaming leaves the work
derived from client material; replacement removes the derivation.

## Findings that changed the book

**The conditioning parameter destroys what it is named to protect.** Running all
five WhiteboxTools conditioning algorithms on the Chilwa grid showed that
`max_depth = 3` cannot carve an outlet from a 400 metre basin, so it fills
instead, raising the lake bed 14.1 m on average and 83.5 m at most. Run
unconstrained it raises no cell, leaves the bed at its raw 623 m, carves one
395.4 m channel, and still returns zero depressions and normal routing. The
standing claim in `CLAUDE.md` that a terminal sink cannot survive conditioning
was wrong and is corrected there.

**The variable window function is a bigger lever than the allometric equation.**
Sweeping its two coefficients across their published range moves stem density
from 368 to 4,373 per hectare on one cloud, 11.9-fold, against the allometry
chapter's 4.75-fold across five published equations.

**The same window function appears in two of the author's repositories under two
attributions.** `wf_Popescu` in `la-ronge-variable-tree-heights` and
`wf_plowright` in `gisborne-forest-stocking-density` are byte-identical at
`0.05x + 0.6`, on two continents, neither calibrated locally, one labelled a
temporary fix.

**Chilwa is not a peatland.** SoilGrids Histosol probability peaks at 7 per cent
across the basin and no cell exceeds 10. That selects the IPCC method: stock
change against a reference, not an area-based annual emission factor.

**The IPCC tropical drained organic soil factor spans zero.** 5.3 t CO2-C per
hectare per year on 21 sites, 95 per cent interval −0.7 to 9.5, so the published
Tier 1 default cannot establish whether such a soil emits or removes.

**Chapter 2's indices rank in reverse of the order projects use them.** On
separating forest from clear-cut regrowth, burn ratio 0.823, moisture index
0.802, red edge 0.747, vegetation index 0.739, and under smoke the vegetation
index moves 13 times as far as the burn ratio on unchanged ground.

**The Murphy Table 8 figures were misread and are corrected.** Kappa is the
first column, so the NDMI classification is kappa 0.750 and overall accuracy
0.824, with commission 0.198 on red attack, not commission 0.750 and kappa
0.166.

## Open, in the order they block work

1. **Push.** Eleven commits are unpushed at the time of writing, including the
   other session's prose revisions. `git push origin chapter-02-reflectance`.
2. **Verify the Popescu and Wynne attribution** against the paper. That paper
   published species-specific functions; the linear form looks like a package
   vignette's example. If wrong, correct both source repositories.
3. **Verify the Gisborne stems-per-hectare conversion.** It multiplies a
   `grid = 10` treetop count by 10 where ten metre cells would need 100.
   `ForestTools::sp_summarise` is no longer exported so it could not be run.
   Deliberately not asserted anywhere.
4. **Confirm the SoilGrids `ocs` scale factor** against ISRIC documentation. The
   service returns a placeholder unit and no scale factor. Raw median 34 over
   the basin is plausible as t/ha and implausible as tenths. The layer is
   deliberately not committed.
5. **Fix `data-raw/prepare-chilwa-data.R`.** Its header asserts a 100 m cell is
   exactly one hectare and refutes itself two paragraphs later. A cell is 0.925
   ha; the identity overstates area by 8.1 per cent.
6. **Obtain Climate Action Reserve protocol 5.1.** The Washington revisions lean
   on it throughout and it is not in the library. Three URLs returned 404; the
   author said they would source it.
7. **Decide the two candidate chapters**, 18 on risk mapping and 19 on natural
   disturbance disaggregation. Candidate 19 is recommended to take the
   dynamical-systems close, which settles the first open decision on the board.
8. **`_quarto.yml` still names the book's output files `TUVSUD_Training_...`**,
   which puts an employer's name on an Elsevier submission.

## Next chapter

Chapter 6 on field plot design. Chapter 4 hands to it directly through the
height heterogeneity section, and chapter 9 needs real plots, for which the
Gisborne stand attributes were cleared today.

Chapter 3 on radar remains the only true gap. Nothing in the library carries
radar and the title promises it. Either the author's own radar time series is
located, or public Sentinel-1 is fetched over the same Rondonia window as
chapter 2 so radar and optical land on identical ground.

## Artefacts

Chapter board, nineteen cards including the two candidates, with each chapter's
question, entry, edge, spine debt and full section outline:
<https://claude.ai/code/artifact/4499bb90-ae13-4fdd-8051-ee6e63d01c74>
