# Wetland organic soils, and where they enter the book

Compiled 6 September 2026 after the author asked for the IPCC Tier 1 wetland
organic soil datasets to be introduced early, and for the material to be
anonymised by changing the country of interest because it came from previous
clients.

## The recommendation, which is not to anonymise

Nothing needs anonymising, because nothing client-derived needs to be used.

The two repositories named, `TREES-ecuador-repository` and
`IPCC-wildfire-emissions`, contain three separable things. The **method** is
IPCC Tier 1, published. The **datasets** are public global layers, being the
Harmonized World Soil Database for Histosols, ESA WorldCover, WorldClim, SRTM
and FAOSTAT. Only the **area of interest** carries any client association, being
Ecuador in one and Honduras in the other.

So the client-associated element is a place name, and the fix is not to disguise
it but to replace it. **Lake Chilwa is already this book's wetland area of
interest**, it comes from HydroSHEDS and HydroLAKES, it is public, and it has no
client association whatever. Chapter 5 already works on it.

That route is better than renaming a country for three reasons. It removes the
derivation rather than obscuring it, which is what the 6 September decision
requires and what a renamed analysis would not achieve. It needs no new data,
because the primary source is already in `references/standards/IPCC-md`. And it
puts organic soils on ground the reader already knows from earlier in the same
chapter, which is worth more pedagogically than a fresh map.

**`TREES-ecuador-repository` should not be used at all.** Its contents are a
reversal report, a wildfire delineation, an emissions update report and registry
feedback, which are verification deliverables for a named jurisdiction. That is
squarely inside the standing exclusion set on 6 September, and no amount of
renaming changes what they are.

## The source, already held

`references/standards/IPCC-md/IPCC-2013-Wetlands-Supplement.md`, 37,471 words,
is the 2013 Supplement to the 2006 Guidelines for National Greenhouse Gas
Inventories: Wetlands. It is the primary document, it is in the library, and it
carries every default the book needs. Its Chapter 5 is separately held at
`IPCC-2013-Wetlands-Supplement-Ch.5.md`.

Four tables matter.

**Table 2.1** gives Tier 1 carbon dioxide emission factors for drained organic
soils across all land-use categories, in tonnes of carbon dioxide carbon per
hectare per year, and it supersedes Tables 4.6, 5.6 and 6.3 of the 2006
Guidelines.

**Table 2.3** gives the methane factors for the same soils, and **Table 2.4**
those for drainage ditches, which the 2006 Guidelines had assumed negligible.

**Table 5.1** gives reference soil organic carbon stocks for wetlands on mineral
soils, and offers two competing sets, the 2006 values and Batjes 2011.

## The number that carries the argument

Read the tropical row of Table 2.1 against the boreal rows.

| Land use, drained | Zone | EF, t CO2-C / ha / yr | 95% interval | Sites |
|---|---|---|---|---|
| Forest, nutrient-poor | Boreal | 0.37 | −0.11 to 0.84 | 63 |
| Forest, nutrient-rich | Boreal | 0.93 | 0.54 to 1.30 | 62 |
| Forest | Temperate | 2.6 | 2.0 to 3.3 | 8 |
| Forest and cleared forest | Tropical | 5.3 | −0.7 to 9.5 | 21 |

**The tropical factor is 5.3 and its 95 per cent interval runs from −0.7 to
9.5.** The interval spans zero. At Tier 1 the published default cannot
distinguish a tropical drained organic forest soil that is emitting from one
that is removing, and it rests on 21 sites.

That single row is the strongest available statement of this book's recurring
argument, that analysts spend their effort on the term they measured and none on
the term they assumed. A tropical peatland project's entire soil claim is
multiplied by a number whose sign is not established.

Two more contrasts are available in the same table without leaving it. The
temperate factor of 2.6 rests on **8 sites** and has a tight interval, while the
boreal factors rest on **59 to 63 sites** each. The confidence interval is
narrow where the evidence is thin and wide where it is thick, which is not a
paradox but it is a thing a reader has to be shown once before they will believe
it.

## Where it goes

**Chapter 5 introduces it, in a new short section after the stage-area work.**
The chapter already establishes that Chilwa is a wetland, that its inundated
extent is uncertain by a factor of sixteen inside the elevation model's own
precision, and that reporting an area requires stating a stage. Organic soils
are the natural next sentence, because the reason anyone wants the inundated
area is that a drained organic soil emits and a wet one does not. One page. The
Tier 1 table, the tropical row, and the observation that the area uncertainty
established earlier in the chapter now multiplies an emission factor whose sign
is unresolved.

**Chapter 15 develops it**, since that chapter already owns emission factors,
tiers and the error budget. The Table 2.1 confidence intervals belong in its
variance-share calculation, and they will dominate it.

**Chapter 14 needs one sentence**, because organic soil area is activity data
and the IPCC treats Histosols as a stratum independent of land cover.

## What is still needed

A public organic soil layer over the Chilwa basin. The Harmonized World Soil
Database carries a Histosol class and is the layer the wildfire ebook used, and
SoilGrids is the current alternative. Neither is committed. A clipped Histosol
mask over the basin would be small and would let chapter 5 report an area rather
than describe a method.

One caution to carry into the text. The Supplement records that organic soil
fire emissions are validated for Southeast Asia only, and that FAOSTAT sets them
to zero beyond Indonesia, Malaysia and Brunei. Any organic soil fire figure for
an African or American basin is therefore an extrapolation beyond the evidence
the default rests on, and the book should say so where it says anything.
