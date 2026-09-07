# Chapter 1 brief

Dictated 4 September 2026. Working title **Coordinate Systems and the Hectare
That Moves**. Subject is horizontal positional accuracy and the margins of error
inherent in projection operations on the surface of a geoid.

## The question

When a claimed area and a mapped area disagree, which one is wrong, and how would
you tell?

## Why it opens the book

Area non-compliance is the most common finding a forest carbon auditor raises,
and it is raised before any carbon is calculated. A boundary that has been
shifted, clipped or reprojected by successive analysts propagates directly into
over-issuance or under-estimation, and neither direction is acceptable. Nothing
later in the book matters if the polygon is in the wrong place.

## Structure

**1.1 Finding and changing a coordinate reference system.** The practical entry.
What an EPSG code is, how to look one up on epsg.io, how to read a `.prj`, how to
reproject, and why you must. Kept short and concrete.

**1.2 The shape of the Earth.** The geoid as the visual aid that carries the rest
of the chapter. Ellipsoid against geoid against terrain, why height is the harder
coordinate, and why every planar measurement is a projection of a curved surface
onto a flat one with a distortion you chose. Eratosthenes, the longitude problem
and the marine chronometer belong here as the fastest route into what a datum is,
kept to a page.

**1.3 The area check.** The applied core. The sequence a verifier runs, taught on
a public dataset: set the geometric plane, read the submitted layers, validate
geometry, extract the invalid artefacts, calculate hectares, break the total down
by boundary and stratum, and test the difference against materiality. No client
material is used and none may be.

**1.4 Overlap and ownership.** Testing a project boundary against adjacent
ownership, where any positive intersection is land claimed twice. The section
teaches `st_intersection`, `st_difference` and `st_area`, and why a union across
several exclusion residuals readmits every excluded parcel. To be built on public
cadastral and protected-area layers.

**1.5 The inheritance path.** Why the chain of reprojections is lost, and what to
do about it. See the corrections below before drafting this section.

**1.6 The library underneath.** Why two analysts measure the same polygon and get
different areas. ArcGIS runs its own engine over GDAL, GDAL ships in many
versions, and PROJ changed its model at version 6. Spherical against planar
geometry, and `sf_use_s2()` as the switch that changes an answer without
comment. The point is not that one library is right but that a reported area
without a stated software environment is not reproducible, which is why a
serious area check ends on a runtime log.

**1.7 Plot centres and why they are indestructible.** Permanent sample plots in
North America are marked with rebar, and public forest inventory programmes use
markers designed to survive decades. If a crew cannot relocate a centre and sets
up three metres away, the biomass on that plot changes, and because plot means
are extrapolated across the whole project the error does not stay local, it
scales. This is the section that connects positional accuracy to the carbon
number.

**1.8 Assessing a GNSS fix.** A worked positional accuracy assessment. The
difference between GPS as one constellation and GNSS as the family, what
real-time kinematic correction does and what it costs, how to run a check against
a known control point, and how to report the result as a distribution rather than
as a single accuracy figure. Source material in `GPS-training-material`,
`survey-tools` and the KoBoToolbox deployment.

**1.9 What ground truth costs.** Closing caveat on the Global Land Cover
Estimation training database. Why a globally representative set of interpreted
points took years and a large team to build, what it contains, and why ground
truth is the most valuable and least glamorous data product in remote sensing.
Rounds the chapter out by making the case that positional accuracy is not
housekeeping, it is the foundation of every later claim.

**1.10 The plane you are computing on.** The closing caveat, and the hinge into
the rest of the book.

A traditional geographic information system represents the world as a flat
two-dimensional projection, the way a paper map does. The S2 library represents
it on a three-dimensional sphere, the way a globe does. The name comes from the
mathematical notation for the unit sphere, S squared. That single choice removes
two whole classes of defect. There are no seams, so a polygon crossing the
antimeridian is an ordinary polygon rather than a special case, and there are no
singularities, so the poles behave like everywhere else. It makes a worldwide
database possible in one coordinate system with low distortion everywhere, and
the Earth being closer to a sphere than to a plane is what licenses it.

What S2 buys is fast in-memory spatial indexing of large collections, robust
constructive operations, and efficient nearest-neighbour and distance queries.
Robust is the word that matters for this chapter. S2 implements snap rounding,
a geometric technique that lets operations be exact while still using small and
fast coordinate representations, and Google built and tested it against their own
global data before releasing it.

Frame the caveat around robustness rather than magnitude, because that is where
the honest argument is. In `sf`, `sf_use_s2(TRUE)` sends area to `s2_area` on a
sphere of radius 6,371,010 metres, and `sf_use_s2(FALSE)` sends it to
`st_geod_area` on the ellipsoid. The relative difference in area between the two
is around 6.4e-05, so on a ten thousand hectare project it is about two thirds of
a hectare. That is small against the 6.6 per cent the bounding box and convex
hull disagreed by earlier in the chapter, and saying so is the point. The
chapter's ethic is that a reader should be able to rank error sources by size,
not fear all of them equally.

The real gain is elsewhere. A planar intersection of two nearly coincident
boundaries produces slivers, which is why exact spherical predicates matter, because they do not manufacture
them. So the caveat closes the chapter by tying the geometry engine back to the
finding the chapter opened on, and it ends on the rule that a reported area
without its engine, its library versions and its geometry setting stated is not
reproducible, whatever its magnitude.

That is also the hinge. The question of which plane you compute on, and what
support the answer has, is picked up again in every later chapter and closed out
in the cube. See `publishing/book-spine.md`.

## Sources in the library

| Section | Repository |
|---|---|
| 1.7 plot centres | `training/sop-library/sop-plot-grid` |
| 1.8 GNSS | `training/GPS-training-material`, `training/survey-tools` |
| 1.8 field capture | KoBoToolbox deployment, 2019 |
## Corrections before drafting

Three points in the dictation would not survive review and one term was
misheard. Each is worth getting right because the chapter's whole argument is
about precision.

**GeoPackage is an OGC standard, not an ISO one, and it does not record a
reprojection history by itself.** GeoPackage is the OGC Encoding Standard for
geospatial data in a SQLite container. It fixes real shapefile defects, namely
the 2 GB size ceiling, the ten-character field name limit, the 255-column limit
and the inability to distinguish a polygon from a multipolygon. It also has a
`gpkg_metadata` table that can hold ISO 19115 metadata records, and ISO
19115-1:2014 is the standard that defines a lineage element. But the lineage is
only there if somebody writes it. No common format automatically records the
chain of reprojections a file passed through. That is the more interesting and
more defensible version of the argument: the chain is lost because nobody
documents it, not because the container cannot hold it. Write the section that
way and it survives a reviewer who knows the specification.

**A `.prj` file was never meant to hold a history.** Esri's `.prj` sidecar holds
one coordinate reference system in well-known text, the current one. It is not
that it gives you only the previous projection; it gives you only the present
one, and always did. The defect is the absence of any lineage mechanism in the
shapefile family at all.

**PROJ 6 is where the behaviour changed.** Released in 2019, it moved the
canonical representation from proj4 strings to WKT2, introduced the datum
ensemble, and made late-binding transformations the default. That is why the same
`+datum=WGS84` request can resolve differently across versions, and why the WGS 84
ensemble carries a stated accuracy of about two metres that most users never
see. Naming PROJ 6 specifically is stronger than naming a range.

**Two wording fixes from the dictation.** The comparison is a flat map, not "an
s". And S2 removes *seams*, not scenes, at the antimeridian.

**RTK, not TKK.** Real-time kinematic. GNSS is the family of constellations,
GPS is the American one, and a receiver that tracks GPS, GLONASS, Galileo and
BeiDou is a GNSS receiver.

## Facts to verify against source before drafting

The Global Land Cover Estimation training database holds close to two million
training units for the period 1984 to 2020, at 30 metres, across seven primary
and twelve secondary land cover classes, built at Boston University under Curtis
Woodcock and Mark Friedl and published in Scientific Data in 2023. The dictation
said 2026; the published range ends in 2020. Confirm the current release before
the number goes into the text.

## One risk

Nine sections is a lot for a first chapter and this brief would run 35 to 45
printed pages, which is at the top of the series range. Ten sections now. If it has to split, the
natural line is after 1.6, leaving projection and area as chapter 1 and field
positional accuracy, plot centres, GNSS and ground truth as chapter 2. Decide
before the outline goes to Elsevier, not after.
