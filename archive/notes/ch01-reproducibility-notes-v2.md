# Chapter 1: why two people measure the same boundary and get different numbers

Consolidated working notes for *Spatial Analysis in R for Forest Carbon Verification*.
Supersedes the earlier S2 notes. Written plainly, with worked examples, because the
subject is usually made harder than it is.

**Source warning.** Of the five PDFs supplied, only ISO 19011:2018 and ISO 19157:2013
are the actual standards. The 19111, 19115 and 19125 files are Wikipedia extracts. Their
content is broadly sound and one line in the 19125 extract is quoted below because it is
verifiable against the standard itself, but none of the three should appear in an
Elsevier bibliography. Buy or borrow the real texts before final draft. Note also that
ISO 19157:2013 has since been reissued in parts; confirm the current edition before citing.

---

## Part 1. The problem, in plain words

Two completely different operations are both called "converting coordinates", and
collapsing them is what stops anyone getting to the bottom of this.

**Projection** is which flat map you draw on. UTM zone 10N, BC Albers, Web Mercator.
Going out and back is reversible and loses nothing of consequence. It is like redrawing
the same house plan at a different scale.

**Datum transformation** is changing which model of the Earth your numbers are counted
from. WGS 84, NAD83 in its CSRS realisation, a particular ITRF epoch. It is estimated
from observations, it carries an uncertainty, it is not unique, and it is not reversible
unless you know the exact recipe that was used. It moves points by metres. It is like
discovering the surveyor measured from a different corner post.

Projection is cheap and harmless. Datum transformation is where the money goes missing.

### The four handoffs

One corner post on a 500 hectare cutblock near Campbell River.

**One, in the field.** The RTK base station is on NAD83 CSRS, epoch 2010. The data
collector writes 50.0246 N, 125.2733 W and stamps it WGS 84, because that is what field
software always stamps. Nothing was converted. The numbers are fine. The label is wrong,
and the post sits about 1.5 metres from where the label claims.

**Two, export to file.** Saved as a shapefile. The `.prj` says `GCS_WGS_1984` and
nothing more. Look at the WKT for EPSG:4326 and you will find a spheroid, a prime
meridian and a unit, and no field anywhere for the realisation or the coordinate epoch.
The information is not lost in transit; there is nowhere in the format to put it.
Coordinates may also be rounded to six decimals, roughly 10 centimetres.

**Three, desktop analysis.** The analyst projects to UTM zone 10N and gets 500.31
hectares. A colleague uses BC Albers and gets 500.06. Neither records which. This is the
one failure of the four that spherical geometry removes.

**Four, sent to the verifier.** Your machine has a newer PROJ and a different NTv2 grid
shift file. You run the exact transformation the client documented and the boundary
lands tens of centimetres from theirs. Same command, different answer, because the recipe
depends on a data file nobody pinned to a version.

Three of the four are metadata failures. One is a geometry failure.

---

## Part 2. This is built into the standards, not into carelessness

Four structural gaps, each with a citation. This section is the spine of the chapter.

### 2.1 Simple Features mandates straight lines in degree space

ISO 19125-1 defines a model for two-dimensional simple features with linear interpolation
between vertices. Geometries are then associated with a spatial reference system, but the
interpolation rule does not change when that system happens to be geographic. So a
polygon stored in EPSG:4326 has edges that are straight lines in degrees of longitude and
latitude, which is an equirectangular projection nobody chose and nobody declared.

Two conforming systems can read identical coordinates and disagree about what the polygon
is. This is the failure that S2 fixes, and the only one it fixes.

### 2.2 "WGS 84" is not a datum, it is a group of six

ISO 19111 defines a **datum ensemble** as a group of multiple realizations of the same
reference system that, for approximate spatial referencing purposes, are not significantly
different. Its worked example is WGS 84 as an undifferentiated group covering TRANSIT,
G730, G873, G1150, G1674 and G1762, with average ground movement between successive pairs
of 0.7 m, 0.2 m, 0.06 m, 0.2 m and 0.02 m. That is 1.18 m end to end.

Note 1 says datasets on different realizations within an ensemble may be merged **without
coordinate transformation**. Note 2 says the tolerance for "approximate" is for users to
define, typically under a decimetre but up to two metres.

The consequence for an auditor: a client can declare the CRS fully and correctly as
EPSG:4326, be entirely conformant, and still hand you a boundary you cannot reproduce to
better than a metre. Telling clients to "declare the datum" is not enough, because the
declaration is permitted to be vague. Nothing in a pipeline string fixes this, because
nothing about it is undocumented. It is documented as ambiguous.

Source: ISO/TC 211 StandardsTracker issue #131, which corrects a typographic error in this
definition and reproduces it in full.

### 2.3 The standards themselves confuse conversion with transformation

ISO/TC 211 StandardsTracker issue #43, open since a 2009 OGC meeting, records that ISO
19111 distinguishes coordinate conversion, which involves no datum change, from coordinate
transformation, which does, while ISO 19123 uses both words interchangeably. Fifteen years
open.

Your analysts inherit that confusion from the standards. When someone says "I reprojected
it", the sentence does not tell you whether anything moved.

### 2.4 Two more gaps worth a footnote

Issue #103 records that a proposal to extend ISO 19111 to cover grid referencing systems
was put to the project team and declined, with a possible ISO 19111-3 or a separate
standard suggested instead. Neither has appeared. UTM as a projected CRS is inside 19111;
alphanumeric grid references built on it are not.

Issue #553, still open, is a member discovering there is no ISO/TC 211 definition of
"reference system" at all.

---

## Part 3. What S2 does and does not do

### 3.1 The R-global proposal in one paragraph

Edzer Pebesma, *R-global: analysing spatial data globally*, R Consortium ISC proposal,
29 March 2019, with Bivand, Sumner, Rubak and Ooms. USD 10,000, July 2019 to April 2020,
Apache 2.0. It produced the CRAN package `s2` and, from `sf` 1.0 in 2021, made spherical
geometry the default for geographic coordinates. Not speculative: it is the design
rationale for behaviour your readers already depend on without knowing it.

Its diagnosis matches 2.1 above. Analyse the data as they are, points on a curved body,
and project only when plotting.

### 3.2 The two tests, reproduce verbatim

Three lines each, both emit a warning, both return a wrong answer.

```r
library(sf)
line     <- st_as_sfc("LINESTRING(-179 50, 179 50)", crs = 4326)
dateline <- st_as_sfc("LINESTRING(180 0, 180 90)",   crs = 4326)
st_intersects(line, dateline)   # planar: empty
st_bbox(line)                   # spans the planet
```

```r
pol <- st_as_sfc("POLYGON((0 80, 120 80, 240 80, 0 80))", crs = 4326)
pt  <- st_as_sfc("POINT(0 90)", crs = 4326)
st_bbox(pol)              # collapses to a line
st_intersects(pol, pt)    # planar: pole not contained
```

Southern variant from the companion blog post: `POLYGON((-150 -65, 0 -62, 120 -78, -150 -65))`
against `POINT(0 -90)`. Draw the same vertex list in equirectangular and in polar
stereographic and the reader sees two different polygons from one WKT string. That is the
figure for section 2.1.

The proposal also names four structural consequences worth listing: a minimum and maximum
coordinate bounding box does not enclose a geometry on a curved body, the natural analogue
being a cap; a correct extent is what lets PROJ choose a sensible transformation; spatial
indexes assume a plane and miss connectedness at the antimeridian and the poles; and
graticule generation was heuristic and fragile.

### 3.3 The rules to state, then enforce through the book

Use S2 for predicates, overlays and indexing on geographic coordinates. Its predicates are
exact rather than naively floating point, so two verifiers computing containment on the
same coordinates get the same answer on any machine. That determinism, not accuracy, is
the reproducibility win.

Never take a reported quantity from S2. Area, length and distance in any figure that
reaches a verification statement must come from ellipsoidal geodesics, which in R means
`lwgeom::st_geod_area()` and its siblings, wrapping the Karney algorithms. The spherical
against ellipsoidal gap runs to roughly half a percent; on the `sf` North Carolina example
it is about 0.006 percent. Half a percent on ten thousand hectares is fifty hectares.

Record the sphere radius whenever a spherical measure is used. `sf` defaults to 6371010 m.

State plainly that S2 is not a CRS. No EPSG code, no ellipsoid, no epoch. Feed it the
mislabelled Campbell River post and it returns a fast, exact, perfectly repeatable answer
1.5 metres in the wrong place. It makes the residual error silent and reproducible rather
than removing it.

---

## Part 4. What geometry satellites actually use

Neither a plane nor a sphere. Euclidean three-space.

Orbits are determined in an inertial frame aligned to the ICRF and rotated into an
Earth-centred Earth-fixed frame for navigation. The receiver solves for its own position
as three Cartesian numbers, X, Y and Z in ECEF, plus a clock offset, by multilateration.
The frame realisation depends on the constellation: WGS 84 for GPS, GTRF for Galileo,
PZ-90.11 for GLONASS, CGCS2000 for BeiDou, all aligned to ITRF at centimetre level.

Longitude, latitude and ellipsoidal height come last, by inverting the geodetic relation
on the WGS 84 ellipsoid, semi-major axis 6378137 m, inverse flattening 298.257223563.
Orthometric height needs a geoid model on top, CGG2013a in Canada.

So the ellipsoid enters once, at the end, as a convention on an otherwise Cartesian
solution. S2's sphere is a further approximation applied after that. Worth a small figure,
because it explains why the ellipsoid is negotiable in software and the Cartesian solution
is not.

**Teaching aside worth using.** The Wikipedia table on spatial reference systems lists
EPSG:4326 with ellipsoid GRS 80, while the WKT reproduced immediately below it correctly
shows `SPHEROID["WGS 84",6378137,298.257223563]`. Two entries on one page contradicting
each other on the shape of the Earth is a better argument for careful sourcing than
anything I could write.

**No S2-native receivers exist**, and one would be worse, not better. S2 carries no
ellipsoid, realisation or epoch, which are precisely the fields whose absence causes the
disagreements. It quantises at under a centimetre, coarser than RTK resolves. It has no
vertical dimension. Its cells vary in area about two to one, good for indexing and useless
for measurement. The closest thing in the wild is GNSS-SDR, which can attach a geohash tag
to a fix already computed. S2 tokens belong downstream, in BigQuery GIS and Earth Engine,
never at the antenna.

---

## Part 5. The auditor's toolkit, which is ISO 19157 and ISO 19011

This is the part I had been missing, and it is the part that turns the chapter from a
complaint into a method.

### 5.1 ISO 19157 already gives you the vocabulary

Positional accuracy is not one thing. ISO 19157 splits it into
`DQ_AbsoluteExternalPositionalAccuracy`, `DQ_RelativeInternalPositionalAccuracy` and
`DQ_GriddedDataPositionalAccuracy`. The datum ensemble problem is an **absolute external**
failure and leaves relative internal accuracy untouched. A client boundary can be
internally excellent and externally a metre out, and 19157 lets you say exactly that
instead of arguing about whether the data are "good".

Logical consistency splits four ways: conceptual, domain, format and topological. The
Simple Features edge problem in 2.1 is a conceptual consistency question, adherence to the
rules of the conceptual schema.

### 5.2 Metaquality is the answer to the ensemble problem

ISO 19157 defines **metaquality** as information describing the quality of data quality,
with three elements: `DQ_Confidence`, `DQ_Representativity` and `DQ_Homogeneity`.

This is the escape hatch. When a client declares EPSG:4326 with no realisation, you can
still report a positional accuracy figure and attach a confidence statement that says the
figure rests on an unresolved datum ensemble spanning up to 1.18 m. You are not forced to
choose between accepting the number and rejecting the submission. Homogeneity matters too
where a boundary was captured across several field seasons on different base stations.

### 5.3 The standard deliberately sets no thresholds

ISO 19157 states in its scope that it does not attempt to define minimum acceptable levels
of quality. Thresholds live in the **conformance quality level**, defined as a threshold
value or set of threshold values used to determine how well a dataset meets the criteria in
its **data product specification** or in user requirements.

That is the mechanism the chapter should point at. The reproducibility contract is not a
CRS declaration. It is a data product specification with stated conformance quality levels,
issued by the registry or the verifier, because ISO has explicitly declined to issue one.

### 5.4 Lineage is metadata, and ISO calls it non-quantitative

The reprojection history you want is **lineage**, which ISO 19157 routes to ISO 19115-1 as
metadata rather than treating as a data quality element, and describes as general,
non-quantitative information that is illustrative for users. Lineage recounts the life
cycle of a dataset from collection through compilation and derivation to its current form.

Two consequences. First, this is why pipeline metadata feels weak: the standards classify
it as illustrative, not as a measured quality result. Second, ISO 19157 defines an
**indirect evaluation method** as evaluating quality from external knowledge, and gives
lineage as its example. So when you cannot measure positional accuracy directly, the
standard says fall back on lineage, and lineage is exactly what the shapefile destroyed at
handoff two. That closes the loop on the whole chapter.

### 5.5 ISO 19011 supplies the audit machinery

Principle (f), the evidence-based approach, is described as the rational method for
reaching reliable and **reproducible** audit conclusions. Reproducibility is an ISO
auditing principle, not a preference of yours.

Clause 6.4.7 is the operative one: only information that can be subject to some degree of
verification should be accepted as audit evidence, and where the degree of verification is
low the auditor should use professional judgement to determine the degree of reliance that
can be placed on it. A boundary whose datum realisation is unknown is low-verifiability
evidence. 19011 tells you to say so and to reason about reliance, rather than silently
recomputing and hoping.

Annex A.5 gives the four verification tests to apply to any submitted dataset: complete,
correct, consistent, current. A `.prj` with no epoch fails "complete" against the
requirement, not because the client withheld anything but because the format has no slot.

Clause 6.4.8 allows nonconformities to be graded quantitatively or qualitatively, and
6.5.1(k) requires the report to state that an audit is by nature a sampling exercise with a
risk that evidence examined is not representative. Both are useful when a corrective action
request concerns geospatial reproducibility rather than a missing document.

---

## Part 6. What to demand, and what to build

### 6.1 The submission specification

Stop asking for the CRS. Ask for, and make these conformance criteria in the data product
specification:

1. the specific realisation, not the ensemble name, so WGS 84 (G1762) rather than WGS 84;
2. the coordinate epoch, because in Comox the ground moves roughly a centimetre a year;
3. the EPSG code of the transformation applied, not the phrase "reprojected to WGS 84";
4. the PROJ version and the grid shift file version used;
5. the edge interpretation, planar or geodesic;
6. the area method and the ellipsoid it was computed on;
7. a checksum over the geometry.

Anything short of that is conformant and still irreproducible. Deliver it as a machine
readable sidecar, not a paragraph in a report.

### 6.2 The one rule underneath all of it

The coordinates and their true label travel unchanged from receiver to verifier. Geometry
is done on the sphere. Measurement is done by geodesic on a declared ellipsoid. Projection
happens only when a picture is drawn, and is then discarded.

### 6.3 Software work plan, if anyone builds it

Firmware is not part of it. Six workstreams:

1. Leave the position solution alone. ECEF on the declared ellipsoid. Anything else is a
   regression dressed as an improvement.
2. Capture metadata in the field app. Every vertex carries constellation, fix type,
   correction source, PDOP, antenna height, frame realisation and observation epoch. Most
   of the effort belongs here, and so does most of the current failure.
3. Build the boundary as an S2 loop at capture rather than a planar ring. Antimeridian
   crossings and self-intersections then fail in the field, not in your office eighteen
   months later.
4. Keep measurement in a separate module, GeographicLib geodesics, emitting the ellipsoid
   and method alongside the number.
5. Emit an S2 covering as a join key next to full-precision coordinates. The token is the
   index. The coordinate remains the record.
6. Hash the raw observations, embed the PROJ pipeline string, pin PROJ and grid versions,
   sign the bundle.

Risk sits in epoch and datum discipline, grid version pinning, and persuading field staff
to record metadata they do not believe matters. Not in S2, which has mature bindings in
C++, Python, Java, Go and R.

Prototype in R and Python: `sf` with `s2` for geometry, GeographicLib for measurement, a
JSON schema for provenance. Prove it against a real submission you already know you could
not reproduce. Then push the schema to registries and standards bodies, not to hardware
vendors. The lever is the submission specification, not the receiver.

---

## Sources

- ISO 19011:2018, *Guidelines for auditing management systems*. Clauses 4, 6.4.7, 6.4.8,
  6.5.1, Annexes A.5 and A.6.
- ISO 19157:2013, *Geographic information — Data quality*. Scope, 4.4, 4.10, 4.17, 4.20,
  7.3, Figure 2, and NOTE 2 on lineage. Confirm the current edition.
- ISO 19125-1, *Simple feature access — Part 1: Common architecture*. Linear interpolation
  between vertices.
- ISO 19111:2019, *Spatial referencing by coordinates*, 3.1.16, datum ensemble.
- ISO 19115-1, *Metadata*, lineage.
- ISO/TC 211 StandardsTracker, issues #43, #103, #131, #553.
  github.com/ISO-TC211/StandardsTracker
- Pebesma, E. 2019. *R-global: analysing spatial data globally.* R Consortium ISC proposal.
  github.com/r-spatial/global
- Pebesma, E. and D. Dunnington. 2020. *In r-spatial, the Earth is no longer flat.*
  r-spatial.org
- Dunnington, D., E. Pebesma and E. Rubak. `s2`, CRAN. S2 Geometry docs, s2geometry.io.
- Pebesma, E. and R. Bivand. 2023. *Spatial Data Science: With Applications in R.*
