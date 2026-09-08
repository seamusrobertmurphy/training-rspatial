# Sampling design for remote sensing and forest carbon monitoring

Read 8 September 2026 against five primary documents, in full. This note records
what each one actually requires, where the requirement sits, and which chapter of
the book it belongs to. Every claim below cites the document, the section and the
printed page, and was read from the document rather than recalled.

## What these documents actually are

Two of the five are misnamed in the library, and one of them is not the
organisation its filename claims. This matters because a manuscript citing either
by its filename would cite a document that does not exist.

`GOFC-GOLD_2006-LULC-Guidelines.pdf` is **GOFC-GOLD Report No. 25**, Strahler,
Boschetti, Foody, Friedl, Hansen, Herold, Mayaux, Morisette, Stehman and
Woodcock (2006), *Global Land Cover Validation: Recommendations for Evaluation
and Accuracy Assessment of Global Land Cover Maps*, EUR 22156 EN, Luxembourg,
Office for Official Publications of the European Communities, March 2006, 60
pages. It is the output of the Working Group on Global Land Cover Validation
within the Land Product Validation subgroup of the CEOS Working Group on
Calibration and Validation, drafted at workshops at the Joint Research Centre in
March 2003 and Boston University in February 2004. It is an accuracy assessment
and validation document, not a land use and land cover guideline, and its
sampling content is the strongest of the five.

`GOFC-GOLD_2020-SOC-Guidelines.pdf` is **not a GOFC-GOLD document at all**. It is
*Gold Standard for the Global Goals, Soil Organic Carbon Framework Methodology,
Version 1.0*, published January 2020, developed by TREES Consulting, 46 pages.
Gold Standard is a carbon crediting standard body. GOFC-GOLD is Global
Observation of Forest and Land Cover Dynamics, a panel of the Global Terrestrial
Observing System sponsored by FAO, UNESCO, WMO, ICSU and UNEP. The two are
unrelated and the filename appears to have collapsed "Gold Standard" into
"GOFC-GOLD".

The copies in `library-science/library/staging/` are byte-identical by SHA-256 to
the copies already held in `references/standards/GOFC/`, so either path cites the
same document. The well-known **GOFC-GOLD REDD Sourcebook** is a third,
different document and is not in the library.

The other three are `references/standards/IPCC-pdf/IPCC-2006-V4-Ch2-Generic-Methodologies.pdf`
(59 pages), `IPCC-2006-V4-Ch3-Consistent-Land-Representation.pdf` (42 pages) and
`IPCC-2006-V4-Ch4-Forest-Land.pdf` (83 pages), all from Volume 4 of the 2006
Guidelines for National Greenhouse Gas Inventories.

## The three parts a design has, and the one most projects skip

Strahler et al. (2006), section 3, page 17, after Stehman and Czaplewski (1998),
splits a statistically defensible assessment into three parts, and a project that
names only the second has not specified a design.

The **response design** is the protocol determining the reference label at each
location and the definition of agreement used to compare it with the map label.
The **sampling design** is the protocol selecting the locations. The **analysis**
is the set of formulas estimating the accuracy measures and their standard
errors. The report is explicit that the accuracy assessment sample is drawn
independently of any sample used to train the classifier, at section 3, page 17,
and again at section 2.2, page 7, citing Swain (1978) and Hammond and Verbyla
(1996).

The same document, section 1.3, page 6, sets the effort a validation deserves.
Producing a land cover map "should consist of three more-or-less equal parts,
data preparation, classification, and validation", and without validation "any
land cover map, whether at global, regional, or local scale, remains an untested
hypothesis".

## What makes a design a probability sample, and what quietly disqualifies it

Design-based inference requires that inclusion probabilities are known for every
unit selected and nonzero for every unit in the population. Strahler et al.,
section 3, pages 17 and 18, names three protocols that fail that test, and two of
them are common practice.

Sampling only within areas of homogeneous land cover fails the nonzero
requirement over a large part of the map. The report treats this directly at
section 3.1, page 19, calling it a remedy to the spatial registration problem
that "violates the requirements of probability sampling, and typically leads to
optimistic estimates of accuracy". The registration concern is legitimate and
belongs in the analysis instead, as below.

Balanced sampling, after Royall and Eberhardt (1975), selects units without
randomisation so that sample characteristics match known population
characteristics. The rationale is described as "more logical and laudable" than
other non-probabilistic approaches, and it still fails, because it is the lack of
randomisation that disqualifies it.

Ad hoc multi-step selection protocols fail because the inclusion probabilities
cannot be derived afterwards.

The IPCC states the same principle more permissively at Volume 4, Chapter 3,
Annex 3A.3.2, page 3.30. Random selection is the basis, a systematic grid whose
positioning is random qualifies, and subjective or purposive sampling is
acknowledged as something inventories in practice use. Where it is used, good
practice is to identify, in consultation with the agencies responsible for the
sites, the land areas for which the subjective sample can be regarded as
representative. That is a weaker requirement than the CEOS report's and it is the
one a national inventory actually operates under.

## The estimator has to carry the design, and usually does not

This is the single most transferable finding in the five documents, at Strahler
et al., section 3, page 18. Consistent estimation requires the inclusion
probabilities to appear in the formula. The named failure is worth quoting in
full because it is ordinary practice.

> a stratified random sample with equal allocation (same sample size in each
> stratum) is commonly incorrectly analyzed as if the data had arisen from a
> simple random sample

An unweighted analysis of a stratified sample does not estimate the population
parameter it appears to estimate, and the bias is silent. The general consistent
estimator is given at Equation 3.1, page 21, as a ratio of two inclusion-weighted
totals, and it adapts to overall accuracy, user's accuracy, producer's accuracy,
subregional accuracy and collapsed class schemes without changing form. The
variance formula at Equation 3.2, page 22, needs pairwise inclusion
probabilities, which is why the report recommends a survey sampling package
rather than hand-rolled code.

A consequence at page 22 that projects rarely act on. Because users will want
accuracy measures the producer did not anticipate, the reference data should be
published with the inclusion probability attached to every sample unit, and with
a recommendation that users apply them.

## Stratification, and the two things it buys

The IPCC, Annex 3A.3.3, page 3.31, separates the two reasons cleanly. Stratifying
improves the accuracy of the estimate for the whole population when it reduces
within-stratum variability relative to the population, and it separately ensures
adequate results for subpopulations that matter on their own, such as an
administrative region. Those are different objectives and they justify different
allocations.

Strahler et al., section 3.1, page 19, warns against the opposite failure. Strata
are motivated by estimation objectives, so stratifying by map class targets
class-specific accuracy and stratifying by region targets regional accuracy, but
"the practical recommendation is to stratify to meet the highest priority
objectives, but to not over stratify at the expense of poorer precision for other
important estimates". The worked figure is sobering. Continents crossed with six
to ten land cover classes already produces 40 to 50 strata.

Equal allocation across map classes gives approximately equal precision on the
user's accuracy of each class and treats every class as equally important, which
is a decision rather than a default.

Two further points are useful and not obvious.

Strata drawn from a map or from remote sensing can misallocate area, so that the
frame sampled is not the target population. The IPCC, page 3.31, says this "can
lead to substantial bias in the final estimates" and that where the risk is
obvious, the impact should be assessed against ground truth. The remedy on the
same page is **post-stratification**, defining strata from auxiliary data after
the field survey has been conducted, which gains the efficiency without changing
the field design and reduces that bias risk, citing Dees et al. (1998).

Revising the map after the sample is drawn does not invalidate the design.
Strahler et al., section 3.1, pages 19 and 20, is explicit. Inclusion
probabilities are fixed at the moment of selection, so an updated classification
means the sample data are regrouped into the revised classes while every unit
keeps the inclusion probability the original stratification gave it.

## Systematic sampling, and the one case where it loses

Both documents recommend it. The IPCC, page 3.32, gives the reason plainly, that
sample plots are distributed evenly over the target area while simple random
sampling leaves some parts with many plots and other parts with none, and adds
that systematic sampling simplifies the fieldwork.

Footnote 3 on the same page gives the exception, that where a regular pattern in
the terrain coincides with the grid, systematic sampling can be less precise than
simple random, and that reorienting the grid generally handles it.

The IPCC is silent on the variance problem this creates, which the book's own
chapter 6 measured, that no unbiased variance estimator exists for a systematic
sample from a single random start, so the precision gained cannot be reported.
Annex 3A.3.5 acknowledges it only in footnote 4, page 3.33, where the standard
error formula for area proportions is described as "only approximate when
systematic sampling is applied".

## Clusters buy travel time and cost information

Strahler et al., section 3.1, page 20, sets out the trade. Clustering lowers the
cost per unit sampled because once the investment has been made to reach or
interpret one unit, the marginal cost of the next unit in the same cluster is
much lower. The information per unit falls at the same time, because units within
a cluster are more likely to be alike in whether they are correctly classified.
The design question is whether the extra sample size the saving buys compensates
for the within-cluster correlation.

For large primary sampling units, two-stage cluster sampling beats one-stage at
the same fixed total cost, because more primary units can be visited even at the
price of subsampling within each. One-stage is described as practical only for
small clusters, 3 by 3 or 5 by 5 units.

The IPCC, page 3.31, adds the field constraint. Plots are clustered to minimise
travel cost, and "the distance between plots should be large enough to avoid
major between-plot correlation, taking (for forest sampling) stand size into
account". Stand size sets the minimum spacing.

## The design that carries both strata and clusters

Combining the two is named as one of the harder parts of the problem at Strahler
et al., section 3.1, page 20, and section 3.5, page 25. One design is
recommended, after Nusser and Klaas (2003) and Stehman et al. (2003).

Select a first-stage sample of primary units, which may be a 6 km block, a
watershed, a county or a Landsat scene. Then stratify **the units inside those
sampled primary units** by map class, and draw a stratified random sample from
that list. The sample is spatially constrained to a limited number of primary
units, which is the cost control, and the allocation to land cover strata is
preserved, which is the precision control.

The alternative, stratifying the primary units themselves, is described and
rejected for a specific reason at page 21. Cost-effective cluster sizes contain a
mixture of classes, so a rule is needed to assign a mixed cluster to one stratum,
and if the rare class is spatially dispersed only a few clusters land in its
stratum, which puts all the rare-class sample into very few clusters and
diminishes precision.

Section 3.4, page 24, adds a design requirement that is easy to omit. Build in a
mechanism for supplementing the sample if more money arrives. A stratified random
sample is readily augmented and its estimation stays straightforward; the
two-stage clustered and stratified designs need to be evaluated for this
explicitly.

## Permanent, temporary, and partial replacement

The IPCC, Annex 3A.3.3, pages 3.32 and 3.33, names three designs for estimating
change and states the trade for each.

Permanent units, measured on both occasions, are generally more efficient for
estimating change, because it is easier to separate a real trend from a
difference caused only by which units were selected. The risk is stated as
plainly. If the locations become known to land managers, for example by being
visibly marked, management of those plots may differ from management elsewhere,
the plots stop being representative, and the results are biased. Good practice
where that risk is perceived is to measure some temporary plots as a control.

Temporary units, independent sets on each occasion, can still estimate overall
change but cannot recover land use conversions unless a time dimension is
introduced from auxiliary data such as maps, remote sensing or administrative
records, which adds uncertainty that "may be difficult to quantify other than by
expert judgement".

Partial replacement, replacing some units between occasions and keeping others,
addresses the permanent-plot risk because units believed to have been treated
differently can be replaced. The estimation procedures are described as
complicated, citing Scott and Köhl (1994) and Köhl et al. (1995).

The remeasurement interval is 5 to 10 years for land use and carbon stocks
generally, page 3.32. For soil carbon specifically, IPCC Chapter 2, page 2.39,
narrows it to every 3 to 5 years or each decade, and gives the reason, that
shorter intervals "are not likely to produce significant differences due to small
annual changes in C stocks relative to the large total amount of C in a soil".

## Six steps for a measurement-based inventory

IPCC Chapter 2, section 2.5.1, pages 2.50 and 2.51, is the closest thing in the
five documents to an operating procedure, and four of its six steps carry
requirements a project can fail.

Step 1 develops the sampling scheme, with randomisation of sites within strata,
noting parenthetically that even a regular grid selects its starting point at
random. It requires a **methodology handbook** explaining the scheme, for the
field and laboratory teams and as documentation. Designs that do not re-sample
the same sites are declared acceptable, and the cost is named, that they "may
limit the statistical power of the analysis, and therefore lead to greater
uncertainty".

Step 2 selects the sites and requires **alternative sites** to be identified in
advance, in case an original location cannot be sampled.

Step 3 collects the initial measurements, takes coordinates with a global
positioning system, and permanently marks the location where repeated measures
are planned. It also requires notes on environmental conditions and management at
the site, and states the consequence if those notes contradict the design. If
many sites turn out inconsistent with the expected conditions, Step 1 is repeated
and the scheme modified.

Step 4 re-samples, and carries the sharpest instruction in the section. Where
sampling is destructive, such as removing a soil core, re-sample **at the same
site but not at the exact location** used before, because destructive sampling of
the same spot "is likely to create bias in the measurements".

Step 5 requires uncertainty to include measurement error in collection,
laboratory processing error and the sampling variance from the design. Step 6
requires quality assurance in which peer reviewers not involved in the analysis
evaluate the methodology.

## Sampling for a rare class, and where no design solves it

Change is rare, and Strahler et al., section 5.5, pages 35 and 36, is the most
honest passage in the five documents about the limit that imposes.

The recommended approach is stratified disproportionate sampling, over-sampling
the stratum where the rare cases are concentrated, after Biging et al. (1998).
The conditions under which it improves the estimate of **overall** accuracy are
stated exactly, and they are narrow. The map's overall thematic accuracy exceeds
80 per cent, the change stratum is 15 to 25 per cent of the study area, and
user's accuracies in the change stratum are low. Where the change stratum is very
rare, the gains for overall accuracy are minimal, though precision on the change
class itself still improves.

Stratifying on **mapped** change cannot find omitted change, because the correct
no-change cases dominate the no-change stratum so completely that a sample within
it will not reveal the false negatives. The remedies given are to buffer the
mapped change areas outward, or to add areas known from domain knowledge to be
changing fast, after Khorram (1999).

And then the sentence a carbon project needs to read, on page 36.

> Ensuring an adequately large sample of true change pixels is difficult if the
> change class is exceedingly rare, or if the identification of such change with
> reference data is prohibitively expensive, and no solution to the sampling
> problem may exist (Kalton and Anderson, 1986).

The change error matrix also grows faster than the sample can fill it. Section
5.3, page 32, gives the dimension of a change matrix over N classes as N² by N²,
citing Khorram (1999), and recommends collapsing to a binary change and no-change
case for exactly this reason.

## Accuracy measures, and one the report declines to recommend

Three positions in Strahler et al. bear directly on what the book reports.

Kappa is not recommended. Section 2.4.1, page 10, states that "there are
sufficient concerns with its use" that "it cannot be recommended as general
measure of map accuracy", citing Foody (1992), Ma and Redmond (1995), Stehman and
Czaplewski (1998) and Turk (2002).

The confusion matrix is published raw, not normalised, alongside the summary
metrics and with the sampling design specified, at section 2.2 item 11, page 8,
and again at section 2.4.1, page 10, citing Stehman (2004a).

The 85 per cent overall accuracy target that circulates as a rule is described at
section 2.2 item 1, page 7, as "a relatively subjectively defined target", with
the qualification that it "need not be appropriate for all maps or applications".

The report also sets a validation hierarchy at section 4.5, page 29, worth
carrying because it names what a cheap assessment can and cannot claim. Stage 1
uses a small number of independent field measurements at selected locations.
Stage 2 uses a larger number over a widely distributed set of locations and time
periods. Stage 3 assesses uncertainty "in a systematic and statistically robust
way properly representing global conditions". Only Stage 3 supports a design-based
claim.

## Misregistration is diagnosed in the analysis, never in the sampling

The two documents agree and the point is easy to get backwards. Restricting the
sample to homogeneous areas to avoid registration error is prohibited, as above.
The diagnostic offered instead, at Strahler et al., section 3.2, page 23, is to
report accuracy separately for the homogeneous subset and for the full map.
Location error has little effect on the homogeneous subset because neighbouring
units carry the same label, so the difference between the two results quantifies
what location error is costing.

Reference data error is handled in the same section. Where multiple interpreters
supply reference labels, their agreement is quantified by having them all
evaluate a common test set. Where reference data are not contemporaneous with the
imagery, the affected proportion is reported and tested for association with
classification error, citing Wickham et al. (2004b). No standard method exists,
and the report says so rather than inventing one.

## What the Gold Standard SOC methodology adds

Read as what it is, a crediting methodology rather than a validation guideline,
it contributes four things.

**A fourth uncertainty deduction curve**, for the book's registry comparison.
Section 9, page 26, sets the criterion at a precision of 20 per cent of the mean
at the 90 per cent confidence level for total soil organic carbon change. Below
that threshold there is no deduction. Above it, Equation 11 on page 28 sets the
deduction as the model output uncertainty minus 20 percentage points, which is a
one-for-one excess deduction with a 20 per cent free band. That sits beside the
ACR 10 per cent band, the VMD0055 scaled excess and the ART no-threshold rule
already in the book's verified constants.

**Stratification into modelling units** by soil type, climate zone, land
management or cropping system and input level, with tillage, soil properties,
hydrology and carbon loss risk added where applicable, at section 6, page 13.

**A physical validation of the stratification**, at section 16.2, pages 36 and
37, which is unusual and worth borrowing. For each stratum, temporary soil pits
of 50 by 50 cm are dug to 50 cm depth and the profile is assessed against four
criteria, soil type and depth, inorganic content, organic matter such as large
root residues indicating previous woody crops, and evidence of management history
in the soil structure. In heterogeneous areas the number of pits "will have to be
large enough to represent the variation and confirm the stratification". The pits
stay open until after the initial certification audit and the verification body
revisits a series of them.

**A constraint on borrowed parameters**, at page 15, that literature values
"shall only be applied within the spatial and temporal dimensions analysed in the
original source", naming soil depth and the timespan over which change was
documented, and that where a source gives a range or aggregates across factor
levels, the most conservative value applies.

### One error in that document, recorded because it is load-bearing

Section 9, page 27, instructs that where the number of samples is unknown, "a
conservative value of 1.675 (n=3) shall be used". Its own Table 6 on the same
page gives the t-value at n = 3 as 2.9200, and 1.675 corresponds to roughly n =
65. Using 1.675 in the absence of information on sample size therefore narrows
the confidence interval rather than widening it, which is the opposite of
conservative and the opposite of what the sentence claims to do. A project
following the instruction literally would understate its uncertainty and
under-apply its own deduction. This is stated here as what the document says
against what its own table says, and it has not been checked against a later
version of the methodology.

## Forest-specific requirements from IPCC Chapter 4

Four items bear on plot design.

Forest Land is stratified into subcategories to reduce variation in growth rate
and other parameters, at Box 4.1, page 4.7, with FAO ecological zone and forest
cover classifications as the default and finer national classifications preferred
where available.

The strata must be shared across pools. At page 4.20, "it is good practice that
the stratification of Forest Land adopted for DOM be identical to that used for
the estimation of changes in biomass carbon stocks". A project that stratifies
biomass one way and dead organic matter another has broken the inventory.

The stock-difference method requires the area at the two measurement times to be
identical, at page 4.20, "to ensure that reported carbon stocks are not the
result of changes in area". It is also noted as feasible only for countries whose
forest inventories are based on sample plots.

Chapter 4 supplies indicative uncertainties, at page 4.19, from FAO (2006). Basic
wood density 10 to 40 per cent. Annual increment in managed forests of
industrialised countries 6 per cent. Growing stock 8 per cent in industrialised
countries and 30 per cent in non-industrialised. Combined natural losses 15 per
cent. Wood and fuelwood removals 20 per cent. Forest area about 3 per cent, from
FAO (2000).

One figure on the same page speaks directly to the book's own measurement of
relocation error. Phillips et al. (2002) found that in eight Amazon tropical
forest inventory plots, combined measurement errors produced errors of 10 to 30
per cent in estimates of **basal area change** over periods of less than ten
years. Chapter 6 of this book measured the same class of problem from the
relocation side and found a three metre error dropping the signal-to-noise ratio
on a growth estimate from 16.5 to 0.66.

## Area estimation from a sample of points

IPCC Annex 3A.3.5, page 3.33, gives the estimator the book's activity data
chapter needs, in its simplest form. Where the total area is known, land use
proportions are estimated by the fraction of sample points in each category and
multiplied by the total area. The standard error of the area estimate for
category *i* is

    s(A_i) = A * sqrt( p_i * (1 - p_i) / (n - 1) )

with the 95 per cent interval approximately twice that, and footnote 4 flags that
the formula is only approximate under systematic sampling. Land use conversions
are handled by defining categories of the form A_ij, from category *i* to
category *j*, between successive surveys.

Where the total area is not known, Annex 3A.3.6, page 3.34, gives direct area
estimation, which works **only** under systematic sampling, each point standing
for the area of its grid cell. A 1000 metre square grid gives each point 100
hectares.

Annex 3A.3.5 also notes that estimating via proportions gives the higher accuracy
whenever the total area is known, so the direct method is a fallback rather than
a choice.

## Where each of these lands in the book

**Chapter 6, field plot design**, already drafted, is confirmed rather than
contradicted on the points it makes, and gains four things it should carry. The
permanent against temporary against partial replacement comparison from IPCC
Annex 3A.3.3, which the draft does not name. The permanent-plot bias risk, that
visibly marked plots may be managed differently, which is a second and quite
separate argument for the monumentation the draft recommends on precision
grounds. The destructive sampling rule from IPCC Chapter 2 Step 4. And the
Phillips et al. (2002) figure of 10 to 30 per cent error on basal area change in
Amazon plots, which is an independent published measurement of the effect the
draft simulates.

**Chapter 9, calibration and validation**, takes the requirement that the
validation sample be drawn independently of the training sample, and the two-stage
clustered and stratified design as the practical answer to spatially constrained
validation plots.

**Chapter 10, classification**, takes the consistent-estimation failure, which is
the strongest single finding here, along with the raw confusion matrix
requirement, the position that kappa cannot be recommended, and the note that the
85 per cent target is subjective. The chapter currently reports kappa and should
say what the CEOS working group says about it.

**Chapter 11, change detection**, takes the rare-class sampling material from
section 5.5 whole, including the Biging et al. (1998) conditions, the N² by N²
matrix growth, the omission problem in a map-based no-change stratum, and the
admission that no solution to the sampling problem may exist.

**Chapter 14, activity data**, takes the area-from-proportions estimator and its
standard error, the restriction that direct area estimation needs systematic
sampling, and the IPCC Table 3.7 indicative uncertainties for Approaches 1 to 3.

**Chapter 17, uncertainty**, takes the Gold Standard 20 per cent band and its
excess deduction as a fourth registry curve, and the t-value error as a worked
case of a rule that reads conservative and is not.

## What was not found

None of the five documents gives a sample size formula for a target precision, a
power calculation, or a rule for how many plots a stated confidence interval
needs. The IPCC gives the standard error of an area proportion and stops. The
CEOS report discusses precision as a design criterion at section 3, page 17, and
never quantifies it. That gap is what chapter 6 fills by measurement, and the
absence is worth stating in the chapter, because a reader will assume the
guidance contains a number and it does not.

No document in the set addresses model-based inference for sampling. Strahler et
al., section 3, page 18, notes that model-based and Bayesian frameworks "have
received little attention in accuracy assessment", cites Green and Strawderman
(1994) as the exception, and says explicitly that adopting one "would likely lead
to different guidelines". That is the design-based against model-based split the
book's final part argues, stated in 2006 by the working group that set the
design-based standard.

---

# Global Tier 1 stratification layers

Added 8 September 2026. The pointers below were assembled from a national
inventory engagement report held outside this repository, and only the public
IPCC references and public datasets are carried across. No engagement material
enters the book, per the standing exclusion. Every citation in this section was
re-verified on 8 September 2026 against CrossRef, DataCite or the DOI resolver,
and three of them needed correcting.

## The chapters that carry the layers

Stratification for Tier 1 is not spread evenly through Volume 4. One table holds
the master list and four annex figures hold the classification schemes.

**Chapter 3, Table 3.1**, page 3.11 of the 2019 Refinement, "Example
stratifications with supporting data for Tier 1 emissions estimation methods", is
the table to start from. It names four stratification factors and their strata,
and every Tier 1 default table in the rest of the volume is keyed to them.

Climate carries eight strata, boreal, cold temperate dry, cold temperate wet,
warm temperate dry, warm temperate moist, tropical dry, tropical moist and
tropical wet. Soil carries seven, high activity clay, low activity clay, sandy,
spodic, volcanic, wetland and organic. Biomass, given as ecological zone, carries
twenty, from tropical rainforest through to polar, and is defined in Chapter 4
Figure 4.1 rather than in Chapter 3. Management practices carry the tillage
classes, long term cultivated, perennial tree crop, liming, the high, medium and
low input cropping systems, and improved against unimproved grassland, and more
than one may apply to the same land.

**Chapter 3, Annex 3A.5**, pages 3.45 to 3.50, holds the classification schemes
themselves in four figures. Figure 3A.5.1, marked updated from the 2006
Guidelines, delineates the major climate zones, on page 3.47. Figure 3A.5.2 gives
the classification scheme for default climate regions, page 3.48. Figures 3A.5.3
and 3A.5.4 give the mineral soil scheme twice, once against USDA taxonomy on page
3.49 and once against the World Reference Base for Soil Resources on page 3.50,
which matters because a national soil map is usually in one system or the other
and not in both.

**Chapter 3, Annex 3A.1**, Table 3A.1.1, page 3.35, marked updated, lists global
land cover datasets as at 2017. It is the IPCC's own list of what a country may
use for land representation.

**Chapter 3, Annex 3A.6**, page 3.51, is new in the 2019 Refinement and is the
part a remote sensing reader wants. It gives an example process for allocating
lands to IPCC land-use classes using Approach 3 wall-to-wall methods, with a
decision tree at Figure 3A.6.1, page 3.52.

**Chapter 3, Table 3.6a**, page 3.20, also new, maps data inputs and methods onto
the resulting Approach, so a project can read off whether its imagery and
processing chain produce Approach 1, 2 or 3 data. **Table 3.6b**, page 3.28,
lists auxiliary data and the assumptions each supports for determining and
stratifying land use.

**Chapter 2** holds the values keyed to those strata. Table 2.3 gives default
reference soil organic carbon stocks by soil type and climate zone, page 2.35 of
the 2019 Refinement, and Equation 2.25 gives the annual stock change in mineral
soils, page 2.33.

**Chapter 4** holds the forest layers. Figure 4.1 defines the twenty ecological
zones. Table 4.4, page 4.18, gives the root to shoot ratio by climate and region,
which is the parameter most often applied without checking which stratum it came
from.

One rule ties them together, at Chapter 3 section 3.4 point 4, page 3.30 of the
2019 Refinement. Many Tier 1 defaults "were statistically derived for
specifically defined strata", so a country using Tier 1 must stratify using the
definitions the factors were derived for, not its own. A national stratification
that is better in every other respect is the wrong stratification for a Tier 1
factor.

## Where the spatial layers actually come from

The IPCC publishes the classification schemes as figures. It does not publish
them as data. That gap is the reason each layer below has a third-party source,
and it is worth stating in the book because a reader will assume otherwise.

### Climate zones

The spatial layer in circulation is **Lewis, M. (2022). IPCC Climate Zones (from
the 2019 Refinement to the 2006 IPCC Guidelines for National Greenhouse Gas
Inventories). Zenodo. https://doi.org/10.5281/zenodo.7303808**, published 8
November 2022, at 0.5 arc degree resolution in WGS 84 longitude and latitude.

Its own description is the important part and it should be quoted rather than
paraphrased.

> These data (re)create spatial data for the 2019 IPCC Climate Zones, shown in
> Figure 3A.5.1 ... I recreated these data because I could not readily identify
> the data in a spatial format online

So it is a third-party recreation of a published figure, not an IPCC product and
not the data the IPCC used. The same description names the European Soil Data
Centre as having produced a spatial version of Figure 3A.5.1 from the **2006**
Guidelines, which is a second and independent source for the earlier delineation.

The resolution is the constraint that matters for this book. Half an arc degree
is roughly 55 kilometres at the equator, so a single cell can span an entire
mountain gradient and assign it one climate stratum. In steep terrain the climate
stratum a Tier 1 factor is selected from therefore has a support far coarser than
anything else in the calculation, and the factor is selected as though it did
not.

### Soil types

The current layer is **Sinitambirivoutin, M., Milne, E., Schiettecatte, L.-S.,
Tzamtzis, I., Dionisio, D., Henry, M., Brierley, I., & Salvatore, M. (2024). An
updated IPCC major soil types map derived from the harmonized world soil database
v2.0. *CATENA*, 244, 108258. https://doi.org/10.1016/j.catena.2024.108258**,
verified against CrossRef. A preprint of the same work sits at
https://doi.org/10.2139/ssrn.4812268.

It is derived from **FAO and IIASA (2023). Harmonized World Soil Database version
2.0. https://doi.org/10.4060/cc3823en**, which is the underlying soil database
and should be cited alongside it.

Two older ISRIC products remain in use. **Caspari, T. et al. (2022). World Soil
Map according to WRB 2014, derived from the Harmonized World Soil Database.
ISRIC, Wageningen. https://doi.org/10.17027/isric-wdcsoils-h7aa-qm24** resolves
to the ISRIC World Reference Base page and returns 200, although the DOI is
registered outside CrossRef and DataCite and appears in neither API. The SOTER
database sits at https://www.isric.org/explore/soter.

The soil classification itself did not change between the 2006 Guidelines and the
2019 Refinement, both following FAO (1998) and FAO (1995). What changed is the
derived spatial delineation, so a project comparing a 2006-era soil stratum
against a 2019-era one is comparing two maps of the same scheme rather than two
schemes.

## Three citation corrections

These are recorded because each would survive into a manuscript unnoticed.

**The Zenodo DOI does not belong to the IPCC.** It is registered to Matthew Lewis
for the recreated climate zone dataset. Attributing 10.5281/zenodo.7303808 to
Calvo Buendia et al. and the 2019 Refinement is wrong, and the likely route to
the error is the dataset's own request that users "also cite the IPCC", which
reads as a joint citation and is not one.

**Describing that record as the climate zone dataset used in the 2019 Refinement
overstates it.** It is a recreation of the published figure, made because the
underlying data could not be found in spatial form, at a resolution the
Refinement never states.

**The Catena citation as commonly given is incomplete.** It is missing two
authors, Brierley and Salvatore, and carries no DOI. The verified entry is above.

## Known limitations of the Tier 1 strata

Four limitations are worth carrying into the book, and the first is attributed
rather than verified.

Batjes (2010) is cited as finding that IPCC default soil organic carbon values
use means rather than medians and therefore overestimate by 10 to 30 per cent
against robust median statistics, with a geographic bias toward Brazilian sources
raising the warm temperate moist values in particular. **That claim has not been
checked against Batjes (2010) itself and must be before it is used.** It is
recorded here as a claim to verify, not as a finding.

The depth limit is structural. Tier 1 soil organic carbon is defined to 0 to 30
centimetres, so disturbance reaching deeper is outside the method rather than
being underestimated by it, and the relationship between a 30 centimetre stock
and a 100 centimetre stock varies by climate zone and soil class.

Mineral and organic soils use different methods, stock difference against
reference for the first and annual flux factors for the second, so the two cannot
be summed through a single equation and organic stocks fall out of the stock
difference calculation entirely.

The strata are forced to align with one another. Climate zones must be
cross-stratified against soil classes and land-use categories, so precision in
one classification is traded for consistency across all of them, and a country
that builds a better national climate classification must then derive its own
emission factors for it, which is the resource barrier that keeps most
inventories on the defaults.

## Where this lands in the book

The chapter on activity data takes Table 3.1, Table 3.6a and Annex 3A.6, since
they are the mapping from a remote sensing product to a reportable Approach.

The chapter on emission factors takes Chapter 2 Table 2.3, the rule that Tier 1
factors must be used with the strata they were derived for, and the four
limitations above once Batjes is checked.

The chapter on terrain takes the 0.5 arc degree climate layer as a worked
support argument, because it is the coarsest input in a Tier 1 chain and the one
least often stated. It pairs directly with that chapter's existing finding that
Web Mercator inflates cell area by about 7 per cent at 15 degrees south, which is
a small distortion sitting underneath a very large one.

The chapter on uncertainty takes the mean against median bias, once verified, as
a case of a default whose stated uncertainty does not include the bias in its own
central estimate.
