# Two new areas, 6 September 2026

Dictated by the author. Two subjects to place in the seventeen-chapter outline,
with the possibility that either or both becomes a chapter of its own. Every
figure below was read from a primary document or from a repository in the
library, and the provenance is stated in each case.

## Summary

Risk mapping is two different operations that share a word, and no textbook puts
them side by side. Natural disturbance disaggregation is one operation whose
binding constraint is the length of the record, which is the book's own spine
asked along the time axis. Both are placeable. One of them also settles an open
decision.

## One. Risk mapping

### What the library holds

`training/VM0048/deforisk.qmd`, 464 lines, holds a worked deforestation risk
index over an area of interest. The method is exactly as the author described.
Six covariates are each rescaled to zero and one, combined by a weighted sum,
and the result rescaled to zero and one again.

The weights as committed are distance to forest edge 0.2, distance to roads 0.2,
distance to places 0.2, distance to urban 0.1, distance to water 0.1 and slope
0.1. They sum to 0.9 rather than 1.0. The final rescaling hides this, because a
constant factor cannot change the ranking, but the weights as written do not
mean what they appear to mean and that should be fixed before the file is taught
from.

The index is then used to allocate a jurisdictional deforestation rate down to
pixels, by two formulations that the file itself notes are the same operation in
a different order,

$$\mathrm{AllocatedLoss}_{\mathrm{pixel}} = \frac{\mathrm{risk}_{\mathrm{pixel}}}{\sum \mathrm{risk}_{\mathrm{zone}}} \times \mathrm{annual\_loss\_10yr}_{\mathrm{zone}}$$

The file records that two approaches were considered, a spatial model fitted
with `spatstat` or logistic regression as cited in the Verra guidance, and the
weighted sum actually implemented. It gives the reason for choosing the second,
that country-wide covariates made the spatial fit slow and unstable. That
tradeoff, between a model that can be defended statistically and an index that
can be defended to a reviewer line by line, is the chapter this material wants
to be.

`training/VT0007-deforestation-map` carries the same subject at jurisdictional
scale under VT0007, Unplanned Deforestation Allocation v1.0, including Verra's
own recommended risk map development sequence as a figure.

### What CARB actually does, and where the author's premise needs correcting

The Compliance Offset Protocol U.S. Forest Projects, adopted 25 June 2015, was
not in `references/standards/` and has been added at
`references/standards/CARB/forestprotocol2015.pdf`, 146 pages. Appendix D is the
relevant part and it says something narrower than the dictation assumed.

Appendix D sets a project's **reversal risk rating**, which fixes the percentage
of every credit issuance that must be contributed to the Forest Buffer Account.
Table D.1 classifies risk into Financial, Management, Social and Natural
Disturbance. Under Natural Disturbance there are three tables.

1. **Table D.7, Wildfire.** A project that has conducted fire risk reduction work
   over the project area contributes **2 per cent**, and this must be confirmed
   in writing by the local or state fire protection agency with direct
   responsibility for the area, with the methodology submitted in the offset
   project data report. A project that has not conducted such work contributes
   **4 per cent**.
2. **Table D.8, Disease or Insect Outbreak.** **3 per cent** for any forest
   project within the United States. Flat. There is no lower band, no
   project-specific circumstance and no assessment to perform.
3. **Table D.9, Other episodic catastrophic events**, meaning wind, snow, ice and
   flooding. **3 per cent**, also flat.

Equation D.1 combines the eight risk types multiplicatively rather than by
addition, as one minus the product of one minus each risk.

Two corrections follow, and they matter because the argument is going into a
book.

**CARB does penalise a project that has not managed its fire risk, but the
penalty is a doubled buffer contribution, not a reclassification of a reversal
as intentional.** Four per cent against two.

**For mountain pine beetle and other insects there is no lever at all.** Every
United States forest project contributes the same 3 per cent whatever mapping it
did or did not do. A project that has modelled its beetle risk in detail and one
that has never heard of *Dendroctonus* pay the identical premium. That is the
more interesting finding, because it is a gap in the instrument rather than a
requirement to meet, and it is exactly the sort of thing this book is for.

**The intentional against unintentional distinction is about who caused the
reversal, not about baseline due diligence.** The protocol's section 3.5.3 makes
the mechanism plain. Unintentional reversals are insured by the buffer account
and ARB retires buffer credits equal to the reversed tonnage. Intentional
reversals are compensated by the forest owner, who must replace the issued
credits with compliance instruments. Section 3.5.1(b)(1) adds that a project
terminates automatically if an unintentional reversal takes standing live tree
carbon below the baseline.

**The definitions themselves are not in the protocol.** The protocol defers to
section 95802 of the Cap-and-Trade Regulation for the definitions and section
95983 for the disposition of a project after a reversal. Neither section is in
the library. Four attempts to retrieve the Regulation from the Air Resources
Board site on 6 September 2026 returned nothing, so the wording of both
definitions is **unconfirmed** and must not be quoted until the Regulation is
obtained. The nearest confirmed wording in the protocol is its definition of an
Intentional Back Burn, at paragraph (29), which turns on a fire beginning on
another property "through no negligence, gross negligence, or willful misconduct
of the forest owner". That triple, negligence, gross negligence and willful
misconduct, is very likely the test the reversal definitions also use, but that
is an inference and is flagged as one.

### Where it goes

The two things called risk are computed the same way and used for opposite
purposes. A deforestation risk index allocates a baseline downward onto pixels,
so a higher risk means more credits. A reversal risk rating prices an insurance
premium, so a higher risk means fewer credits. Both are a normalised index over
covariates. Nobody teaches them together and the contrast is the argument.

**Recommendation. One new chapter, at the end of part three.** It would run the
VM0048 index end to end on the committed data, put the weighted sum against the
fitted model, then turn to CARB Appendix D and compute a buffer contribution for
the same landscape, and close on the fact that the same map answers two
questions with opposite signs.

The alternative is to split it, sending the allocation mechanics to the baseline
chapter where risk-weighted allocation is already listed and the buffer
arithmetic to the final chapter beside the registry deductions. That is cheaper
and it loses the comparison, which is the only part of this that is new.

## Two. Natural disturbance disaggregation

### What the guidance says

Verified against `references/standards/IPCC-md/IPCC-2019-V4-Ch2-Generic-Methodologies.md`,
which is the 2019 Refinement to the 2006 IPCC Guidelines, Volume 4, Chapter 2,
section 2.6, on interannual variability.

Section 2.6.1.2 gives the definition. Natural disturbances are "non-anthropogenic
events or non-anthropogenic circumstances that cause significant emissions and
are beyond the control of, and not materially influenced by a country", including
wildfires, insect and disease infestations, extreme weather and geological
events, and excluding "harvesting, prescribed burning and fires associated with
activities such as slash and burn".

Section 2.6.3 is the optional disaggregation approach, in four steps. Quantify
the total under the managed land proxy. Describe the country-specific application
of the definition. Identify the emissions and subsequent removals attributable to
natural disturbance. Subtract that component from the total, leaving an estimate
of the human component with lower interannual variability.

Two worked rules from that section belong in the book because they are the kind
of arithmetic nobody writes down. If wildfire causes instant emissions of 20
tonnes of carbon dioxide per hectare and salvage logging then causes another 40,
exactly 20 tonnes of the subsequent removals are disaggregated as natural and
the rest as anthropogenic. And at landscape level, if wildfire touches 0.1 per
cent of the forest area and removes 25 per cent of the carbon stock in the burned
area, then 0.025 per cent of total removals is apportioned to natural
disturbance.

### The record length, which is the point

Box 2.2k sets out the approach in European Union Regulation 2018/841 and it is
the mechanism the author described.

A historical time series of annual wildfire emissions is built starting in 1971,
which is the country's 1990 base year minus twenty years. Outliers larger than
the mean plus twice the standard deviation are removed iteratively until an
outlier-free normal distribution remains. The mean of what survives is the
**background level** of anthropogenic wildfire emissions and twice its standard
deviation is the **margin**. A year is a natural disturbance year when total
immediate wildfire emissions exceed background plus margin, and the disaggregated
natural quantity is the amount exceeding the background level.

The footnote on the two standard deviations is the whole reason the record has to
be long. Two standard deviations is stated as "an approximation of Student's t
value for data series with number of data >= 30". **The thirty is a sample size
at which a normal approximation becomes acceptable, not a round number chosen for
convenience**, and a shorter record makes the test either wrong or unavailable.
Nothing in this book states that more usefully than the beetle work already does
from the other direction, where 65 annual observations were not enough to
resolve a period-doubling cascade.

The other two national approaches differ and the difference is instructive.
Australia calls a year a natural disturbance year when it exceeds the 95 per cent
probability level in the national series of annual carbon stock losses to
wildfire, and spatially confines it to the states with abnormal fire activity
that year; its wildfires are mostly not stand-replacing and stocks recover in
about eleven years. Canada instead uses a physical threshold, all stand-replacing
wildfires plus any other natural disturbance causing more than 20 per cent tree
mortality by biomass, the 20 chosen to exclude the low-mortality insect damage
that affects very large areas. Canada's stands return to the forest management
category at the age they become eligible for harvest, typically 60 to 90 years,
and the 56 million hectares burned before 1990 contribute 64 megatonnes of carbon
dioxide equivalent of removals in 1990 alone.

So three jurisdictions use a statistical outlier rule, a percentile rule and a
physical mortality threshold, and they will not agree on which years were
natural. That disagreement is the chapter.

### What the library already holds

`training/IPCC-wildfire-emissions` is a four-part ebook, 192 files, that already
implements both the standard Tier 1 calculation under Equation 2.27 and the
section 2.6 disaggregation framework, on Honduras. Its own index page states the
three live debates in the field, in the author's own words.

1. The threshold is not mandated. The 95th percentile is recommended, and 90th
   percentile or a rolling mean plus two standard deviations are alternatives.
2. The temporal window. The guidance implies thirty years or more, MODIS
   MCD64A1 begins only in 2001, and extending backwards with Landsat introduces
   cross-sensor uncertainty.
3. The carbon dioxide reporting pathway. Forest remaining forest reports carbon
   dioxide through stock change rather than Equation 2.27, while deforestation
   fires report every gas through Equation 2.27 under the new land use category.

The second of those is precisely the book's spine on the time axis, and it is
unresolved in the field rather than settled.

### Where it goes

**Recommendation. One new chapter, in part four, and it should take the
dynamical-systems close.**

This is the stronger of the two recommendations because it settles something
already open. The first of the four open decisions on the chapter board is
whether any chapter owns the disturbance ecology close, since the outline as
briefed spreads it across chapters 12, 13 and the closing part. A chapter on
separating natural from anthropogenic disturbance over a long record is asking
whether the system has a stationary background regime, which is the same question
as whether it has states and whether it has moved between them. The statistical
machinery is the same. The record-length constraint is the same. And the
material exists.

The alternative is to split it, sending the outlier statistics to the time series
chapter and the reporting arithmetic to the emission factors chapter. That is
cheaper and it loses the argument.

## What this costs

Both recommendations together take the book from seventeen chapters to nineteen,
and at the comparable series volume's pace of 33 pages a chapter that is about
630 pages before front matter, against the 560 that seventeen already implies.
The outline going to Elsevier has not been sent, so the cost of adding them now
is nil and the cost of adding them after peer review is high.

## Open decisions this raises

1. Does risk mapping become a chapter, or split between the baseline chapter and
   the final chapter?
2. Does disaggregation become a chapter, and if so does it take the
   dynamical-systems close, which would settle the first decision already on the
   board?
3. The Cap-and-Trade Regulation sections 95802 and 95983 are not in the library
   and could not be retrieved. Someone has to obtain them before the reversal
   definitions can be quoted.
4. The VM0048 index weights sum to 0.9. Confirm the intended weights before the
   file is taught from.
