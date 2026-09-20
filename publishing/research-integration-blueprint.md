# Research folder blueprint

Drafted 17 September 2026 from a full read of `research/`, which held 13 loose files
of the author's earlier work and 12 cloned third-party repositories, 4.1 GB in all.
Every loose file was read line by line. Seven repositories (`sdsr`, `sdsr_exercises`,
`mstp`, `ethz`, `madrid`, `sswr`, `spacetime`) were read in full through delegated
reads whose licence claims were then checked against the licence files. The other
five were surveyed directly through their licences, package descriptions, tables of
contents and headings, with the `CAST` cross-validation and area of applicability
vignettes read in full. Nothing in `research/` was changed.

The plan runs in four parts. The first sets out three gates that every item must
pass before it enters a chapter. The second maps what passes onto the nineteen
chapters. The third lists defects in the author's own earlier code that are worth
more to the book than the code itself, because each one is a live example of an
error a chapter already argues about. The fourth orders the work.

## Three gates

### Client material

Three loose files are audit work for named clients and fall inside the standing
exclusion of 6 September 2026, so no part of them, method or output, enters the book.

| File | Engagement |
|---|---|
| `ACR_FC_Hiawatha_RP4_DisturbanceCheck_V1-0_053024.Rmd` and its 22 MB `.html` render | Disturbance check, ACR562, carries the verifier's logo and client file paths |
| `ARB_FC_Alma_RP7_DisturbanceCheck_V1-0_060524.Rmd` | Disturbance check, CAR1208, same template |
| `area-checks.qmd` | Area check, ACR990, with SharePoint links to client submissions |

Five more files are paid work whose status the author has not ruled on. The data
behind most of them are public, but the exclusion turns on the work, not the data,
so each needs a ruling before it is used even as a teaching counterexample.

| File | Work | Data |
|---|---|---|
| `land-eligibility-hazard-degradation-check-VM0047.Rmd` and `.html` | VM0047 eligibility check of a site in the southern Philippines | Sentinel-2, ESA land cover, trends.earth |
| `0_EFI-TCC-modelling-pipeline.Rmd` | Whole stem volume model for a BC Timber Sales operating area | FAIB permanent sample plots, VRI, provincial fire perimeters, all BC open data |
| `0_LiDAR-FAIB-WSVHA-raster-to-raster-production-v10.Rmd` and its `.pdf` | The same model across 16 operating areas in the Williams Lake timber supply area | As above, plus contractor lidar mosaics |
| `hills_forest_stocking.Rmd` and its `.pdf` | Stocking remap of cutblock HILL-0341-009, New Zealand | LINZ lidar, forest owner stand records |
| `ash-dieback-stem-map.Rmd` | Stem detection at Shavington | Contractor lidar |

The remaining loose files are the author's own research and are clear to use. They
are the three Darkwoods files, analysis code written for the Darkwoods beetle, fire
and seedling manuscripts, whose data files are not in the folder,
`la-ronge-variable-tree-heights.Rmd` on public HRDEM surfaces, and
`0_Monte_Carlo_Modelling_Pilot.Rmd`, which is an unfinished stub that refers to an
object it never creates (line 67) and is not usable.

### Licence

No repository allows text, code or figures to be pasted into a commercial Elsevier
book on its own terms except the ETH Zurich course. Everything else is cited and
rewritten on the book's own data, or used through the package as a dependency.

| Repository | Licence as found | What the book can do |
|---|---|---|
| `sdsr` (Pebesma and Bivand) | CC BY-NC-SA 4.0, `LICENSE.md` line 1 | Cite and quote briefly. No adapted text, code or figures without permission. Also a competing CRC title in the proposal |
| `sdsr_exercises` | No licence | Cite the idea only |
| `ethz` (Pebesma, April 2025) | CC0 1.0 | Adapt freely. Three bundled items (`turbines.png`, `geopythonR.png`, the turbine GeoPackage) came from others and are excluded |
| `madrid` | No licence | Skip. It duplicates `ethz`, which is more complete |
| `sswr` | CC BY-SA, `README.md` line 47 | Cite and rewrite. ShareAlike rules out adapted text |
| `mstp` | LGPL 3 applied to lecture notes | Cite and rewrite |
| `spacetime` | GPL 2 or later, `DESCRIPTION` line 13 | Cite the vignette and its journal article |
| `CAST` | GPL 2 or later | Call the package, cite the method papers |
| `sp` | GPL 2 or later | Nothing needed. The book runs on `sf` and `terra` |
| `R-Tutorials` (Crego) | GPL 3 | Cite at most |
| `geog-312` (Wu) | CC BY 4.0 | Generic Python course, nothing needed |
| `seasonalbook.content` | No licence found | Concepts only |

This reads the licence files, not the law, and permissions for anything beyond
brief quotation go to the rights holder before the text is written.

### Offline build

None of the 13 loose files runs as it stands. The spreadsheets and rasters they read
sit on drives that are not in the repository, and most of them load `rgdal`,
`rgeos`, `maptools` or `gdalUtils`, all retired. Several third-party chapters fetch
data at render time, including the remote `de_nuts1.gpkg`, the Zenodo `aq` archive,
a live STAC query in `sswr/day5.qmd` and the PM2.5 GeoPackage in
`CAST/vignettes/cast03-CV.Rmd`. Every example is therefore rebuilt on data committed
under `data/`, and no number from any of these files is quoted until a chunk in the
book reproduces it.

## Chapter map

Kinds of use are a worked example to rebuild, a defect to teach from, a framework
to follow, or a citation.

| Chapter | Source | Use | Kind |
|---|---|---|---|
| 1 Positional accuracy | `ethz/part2.qmd` 92 to 119, the same buffer on flat and spherical engines at the equator and 40 degrees north | Rebuild on the SCBI hull | Worked example |
| 1 | `sdsr/07-Introsf.qmd` 503 to 545, point in polygon under s2 and GEOS; `sdsr/02-Spaces.qmd` 386 to 409, one distance four ways | A four-way area table for the SCBI plot | Citation |
| 1 | `sswr/day2.qmd` 116 to 148, planar against geodetic area at 80 degrees north | Short aside | Citation |
| 1 | `sdsr_exercises/05.qmd`, the North Carolina AREA field in square degrees | End-of-chapter exercise | Idea |
| 4 Airborne laser | `la-ronge-variable-tree-heights.Rmd`, variable window tree tops on public HRDEM | Rebuild on the 3DEP tile, with the defects below | Worked example and defect |
| 6 Plot design | `ethz/part1.qmd` 405 to 447, design-based inference, "Note the randomness in S, not in z"; `ethz/part2.qmd` 265 to 270, `st_sample` designs | Adapt onto SCBI | Framework |
| 8 Tree to landscape | `sdsr/05-Attributes.qmd` 313 to 385, area-weighted interpolation for extensive and intensive variables | The chapter's spine argument | Framework and citation |
| 8 | `ethz/part2_ex.qmd` 42 to 59, which total survives interpolation | Adapt with tonnes and tonnes per hectare | Worked example |
| 8 | `mstp/si5.qmd` 46 to 61, block mean and its smaller error | Rewrite | Framework |
| 8 | Stems per hectare summed across polygons, and a stems per hectare raster scaled by 10 instead of 100 | See defects | Defect |
| 9 Calibrate and validate | `CAST` `aoa()`, `nndm()` and `knndm()`, with `cast04-AOA-tutorial.Rmd` defining the dissimilarity index and area of applicability | Run beside `blockCV` on the chapter's own plots | Framework, package |
| 9 | `sdsr/10-Models.qmd` 94 to 121 on random cross-validation; `sswr/day4.qmd` 33 and 212 | Citation | Citation |
| 9 | Test scores that were training scores, leakage through a bootstrap, species codes that differ between plots and raster, plot height against a 100 m cell mean | See defects | Defect |
| 9 | FAIB permanent sample plots, BC open data with coordinates | Candidate for the real plots over real lidar the brief asks for; lidar coverage and licence still to check | Data lead |
| 11 Change and cause | `darkwoods_wildfire.Rmd`, NBR against composite burn index | The fire results already reach chapter 2 from the published paper; the code carries defect 1 and is not reused as it stands | Defect |
| 12 Cube | `sdsr/06-Cubes.qmd` 470 to 498, temporal block support against point support | Cite for aliasing | Citation |
| 12 | `spacetime/vignettes/jss816.Rnw` 343 to 416 and 832 to 884, the four space-time layouts and instants against intervals | Cite and rewrite | Framework |
| 12 | `mstp/ts1.qmd` and `ts2.qmd`, moving average, autoregression, forecast error growing with horizon | Rewrite on the Chilwa stack | Framework |
| 12 | `seasonalbook.content`, X-13 seasonal adjustment | Seasonal breaks and revision of estimates as ideas only; X-13 needs a regular monthly series a satellite record does not give | Concept |
| 13 Pattern and dependence | `darkwoods_seedlings.Rmd`, already the chapter's source | Rebuild off retired packages, fix the defects below | Worked example and defect |
| 13 | `ethz/part3.qmd` and `part4.qmd`, complete spatial randomness, Thomas process, envelopes, permutation test on a variogram, Moran's I | Adapt | Worked example |
| 13 | `sdsr/15-Measures.qmd` 69 to 90, an omitted trend showing as autocorrelation; `sdsr_exercises` 10.2, pseudo-replication | Citation and exercise | Citation |
| 14 Risk mapping | `ethz/part4.qmd` 43 to 61, MaxEnt as a point process | Adapt | Framework |
| 14 | `R-Tutorials/05-murrelet-distribution-model.qmd`, habitat GLM with AUC computed on the fitting data (line 367) | Cite at most | Defect |
| 15 Area estimation | `sdsr/03-Geometries.qmd` 511 to 516 and 801 to 816, covers against contains and half-open cells, so an edge pixel is counted once | Citation | Citation |
| 16 Emission factors | `sdsr/05-Attributes.qmd` 122, a climate zone as a constant attribute with point support | Ties to the three IPCC strata layers | Citation |
| 17 Baselines | `mstp/ts2.qmd` 126 to 133 | Rewrite | Framework |
| 18 Uncertainty | `mstp/op2.qmd`, Metropolis-Hastings; `ethz/part4.qmd` conditional simulation; `mstp/si6.qmd` 191 to 212, exceedance probability | Fills the brief's missing Markov chain Monte Carlo | Framework |
| 19 Disaggregation | `mstp/de1.qmd` 207 to 209, disaggregating country totals; `spacetime` `fires` data | Citation | Citation |
| Final part | `sdsr/10-Models.qmd` 213 to 300 and `12-Interpolation.qmd` 302 to 367, block kriging against the design-based standard error | The closing argument. Lines 294 to 296 are the strongest citation for the registry case | Citation |

Nothing in the folder helps chapter 3 on radar, chapter 7 on allometry or the
registry deductions in chapter 18, so the three blockers named in the briefs stand.
`sp`, `geog-312` and `R-Tutorials` chapters 1 to 4 add nothing the primers do not
already cover.

## Teaching defects

Each defect below was read in the source, and those marked checked were confirmed by
running R 4.4.1 on 17 September 2026. The book teaches the error on a rebuilt public
example and never names the engagement it came from.

1. **Test scores that were training scores.** `caret`'s `predict()` takes `newdata`,
   so `data =` is ignored and every "test" prediction is the training fit. Checked
   against `caret` 7.0.1. Found at `darkwoods_wildfire.Rmd` 157 to 159,
   `darkwoods_beetles.Rmd` 133 and 148, and `0_EFI-TCC-modelling-pipeline.Rmd` 547,
   554, 572, 580, 630 and 640. Chapter 9.
2. **Leakage through a bootstrap.** 4,000 rows are drawn with replacement from the
   plots and then split 80 to 20, so copies of one plot sit on both sides, and R²
   is then reported on the data the model was fitted to.
   `0_LiDAR-FAIB-WSVHA-raster-to-raster-production-v10.Rmd` 660, 665 and 709.
   Chapter 9.
3. **Species codes that do not match.** The prediction raster codes lodgepole pine
   0, spruce 1 and Douglas-fir 2, while the training plots code them 1, 2 and 3.
   A spruce pixel is therefore predicted as pine, a Douglas-fir pixel as spruce,
   and a pine pixel carries a code no plot has. Same file, 482 against 634.
   Chapter 9.
4. **Plot height against a cell mean.** Field top height of the leading species is
   matched to the mean of 1 m lidar vegetation height over 100 m cells, gaps
   included. Same file, 221. Chapters 4 and 9, and the spine.
5. **An intensive quantity summed.** Stems per hectare from inventory polygons is
   rasterised with `fun = sum`. `0_EFI-TCC-modelling-pipeline.Rmd` 116. Chapter 8.
6. **Stems per hectare out by ten.** A 10 m cell is 100 m², so a hectare holds 100
   cells, but the count is multiplied by 10. `hills_forest_stocking.Rmd` 162 and
   183. Chapter 8.
7. **Settings that never ran.** `seq(0.02, 0.1, 0.2)` returns only 0.02, and
   `e1071::tune()` accepts `preProcess = "BoxCox"` without error and never applies
   it. Both checked. `0_EFI-TCC-modelling-pipeline.Rmd` 485 and 495. Chapter 9.
8. **A statistic that is not the statistic.** The "U bias" is
   `(MAE × 20) / MAE²`, which is 20 divided by the mean absolute error, not Theil's
   U bias. `darkwoods_beetles.Rmd` 145. The table labelled Table 13 at lines 120 to
   130 is the fire table. Chapter 9.
9. **A percentile that is not a percentile.** `height_95` is each tree's height
   times 0.95, and the map legend reads "variability" over classes of mean height.
   The same window function is credited to Popescu and Wynne (2004) here and to
   Plowright (2018) in `hills_forest_stocking.Rmd` 134.
   `la-ronge-variable-tree-heights.Rmd` 90 and 189. Chapter 4.
10. **Copy and paste in a point process.** Every species' nearest neighbour distance
    is computed on the whole plot, one species is pooled from plot 1 twice, and the
    interaction terms repeat the red-attack beetle class and never include the grey
    one. `darkwoods_seedlings.Rmd` 609 to 629, 407 and 1098. Chapter 13.
11. **Two thresholds for one change.** Forest is NDVI above 0.7 in 2014 and above
    0.86 in 2024, so the loss map mixes a threshold change with land change.
    `land-eligibility-hazard-degradation-check-VM0047.Rmd` 400 to 412. Chapter 11,
    only if the author clears this file.

Defects 2, 3, 5, 6, 7 and 11 sit in files awaiting a ruling under the first gate.

## Order of work

1. **Protect the repository.** `research/` is not in `.gitignore`. A bare
   `git add` would commit the three excluded client files that the 6 September
   history rewrite removed, and would try to add twelve nested repositories. Add
   it to `.gitignore` before any other step.
2. **Rule on the five engagement files.** One decision each, recorded in
   `.claude/memory/general.md`.
3. **Chapter 9 first.** It has no worked example of its own and gains the most:
   `CAST` beside `blockCV`, defects 1, 2, 3, 4, 7 and 8 rebuilt as deliberate
   mistakes on public plots, and the FAIB plots checked as the real data it lacks.
4. **Chapter 8.** The extensive and intensive argument from `sdsr/05` and
   `ethz/part2_ex`, with defects 5 and 6.
5. **Chapter 13.** Rebuild the seedlings analysis on current packages with defect
   10 fixed, then add the `ethz` point pattern examples to give it the Earth
   observation framing the brief asks for.
6. **Final part.** Quote and verify the design-based passages from `sdsr/10` and
   `sdsr/12`.
7. **Drafted chapters 1, 4 and 6.** Small additions from the map above, each
   followed by a render and the chapter eval.
8. **Chapters 12, 14, 17, 18 and 19.** Frameworks from `mstp`, `spacetime` and
   `ethz` as each chapter is drafted.

Every citation is taken from CrossRef before it enters `references.bib`. Five were
verified there on 20 September 2026 and none is yet in the bibliography. Meyer and
Pebesma (2021), Methods in Ecology and Evolution 12, 1620 to 1633,
doi:10.1111/2041-210X.13650, for the area of applicability. Milà, Mateu and
Pebesma (2022), Methods in Ecology and Evolution 13, 1304 to 1316,
doi:10.1111/2041-210X.13851, for nearest neighbour distance matching. Linnenbrink,
Milà, Ludwig and others (2024), Geoscientific Model Development 17, 5897 to 5912,
doi:10.5194/gmd-17-5897-2024, for its k-fold form, which is Linnenbrink's paper and
not Milà's. Roberts and others (2017), Ecography 40, 913 to 929,
doi:10.1111/ecog.02881, and Valavi and others (2018), Methods in Ecology and
Evolution 10, 225 to 232, doi:10.1111/2041-210X.13107, for blocked
cross-validation.
