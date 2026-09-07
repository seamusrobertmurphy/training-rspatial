# Foundational GIS cheat notes, and revisions to chapter one

For *Spatial Analysis in R for Forest Carbon Verification*.

A note on verification. EPSG codes, PROJ version numbers and ISO clause numbers below were
checked against current PROJ, GDAL and EPSG documentation. Anything marked **[verify]** I
could not confirm to publication standard and you should check before print.

---

# Part A. The seven definitions

## A1. What is an epoch, and how does it inform a reference system

An epoch is a date, written as a decimal year, that says *when* a coordinate was true.

The ground moves. In coastal British Columbia the crust drifts roughly one to two
centimetres a year relative to the whole-Earth frame. A latitude and longitude without a
date is therefore an incomplete statement, in the same way that a share price without a
date is incomplete.

Two different epochs get confused, and the distinction is worth a box in the chapter.

**Frame reference epoch.** The date at which the reference frame itself is defined. The
frame publishes station positions *and* velocities, valid at that date. ITRF2014 has a
reference epoch of 2010.0. WGS 84 (G1762) has a frame epoch of 2005.0.

**Coordinate epoch.** The date at which your particular measurement was valid. A post
surveyed in June 2016 has coordinate epoch 2016.47.

To compare two coordinates you need both frames and both epochs. Moving a coordinate from
one epoch to another within the same frame is a **point motion operation**, done with a
velocity model or a deformation grid.

**Static versus dynamic frames.** A dynamic frame is fixed to the whole Earth, so
coordinates of a fixed post change over time. A static, or plate-fixed, frame moves with
the tectonic plate, so coordinates of a fixed post stay roughly constant within that plate
but drift relative to the global frame. NAD83 in its CSRS realisation is plate-fixed to
North America. ITRF is dynamic. This is why NAD83(CSRS) and WGS 84 differ by more than a
metre in BC and the gap widens.

For the chapter: **an epoch is not optional metadata, it is part of the coordinate.**

## A2. How many reference systems are there, and which should you know

The EPSG dataset holds over ten thousand definitions. That number is not useful. What is
useful is that there are only **eight kinds**, and a working auditor needs six codes.

**The eight kinds.**

1. **Geocentric**, also called Earth-centred Earth-fixed. Three Cartesian numbers, X, Y
   and Z, measured from the Earth's centre of mass. This is what a satellite receiver
   actually solves for.
2. **Geographic 2D**. Latitude and longitude on an ellipsoid. EPSG:4326.
3. **Geographic 3D**. The above plus ellipsoidal height.
4. **Projected**. A flat grid produced by a map projection. UTM, BC Albers, Web Mercator.
   Coordinates in metres.
5. **Vertical**. Heights above a defined surface, usually a geoid model rather than an
   ellipsoid. CGVD2013 in Canada.
6. **Compound**. A horizontal system plus a vertical system bolted together.
7. **Engineering or local**. A bespoke flat grid for one site, where Earth curvature is
   ignorable.
8. **Temporal, and image or grid**. Time axes, and pixel row and column space.

**The six codes to memorise for BC forest carbon work.** Verify each at epsg.org before
citing; codes are stable but names and deprecations change.

- **4326** WGS 84, geographic 2D. What everything is labelled, whether or not it is true.
- **4617** NAD83(CSRS), geographic 2D. What most Canadian survey and provincial data
  actually is.
- **3005** NAD83 / BC Albers. The provincial equal-area standard. Use it for area work
  where a projected area is required.
- **3157** NAD83(CSRS) / UTM zone 10N. Most of Vancouver Island and the Strait.
- **3978** NAD83 / Canada Atlas Lambert. National-scale mapping.
- **6647** CGVD2013 height. The Canadian vertical datum. **[verify]**

Also worth knowing: **OGC:CRS84** is the same as EPSG:4326 but with longitude first.
EPSG:4326 formally puts latitude first. This alone has caused a great deal of silent
coordinate swapping, and PROJ has respected the authority order since version 6.

**Their roles in the chain.** Geocentric is where measurement happens. Geographic is the
storage and exchange convention. Projected is for display and for legacy area
computation. Vertical and compound are for anything involving height, which in forestry
means anything derived from LiDAR. Image and grid space is where raster analysis happens.
Errors enter at every junction between them, not inside any one of them.

## A3. What is the ITRF

The **International Terrestrial Reference Frame**. It is the master ruler against which
every other terrestrial frame is defined.

Distinguish two words. The **ITRS**, International Terrestrial Reference System, is the
abstract definition: origin at the Earth's centre of mass, axes oriented in a stated way,
scale in SI metres. The **ITRF** is a *realisation* of that idea: an actual list of
coordinates and velocities for hundreds of ground stations, computed from satellite laser
ranging, very long baseline interferometry, GNSS and DORIS, and published by the IERS,
the International Earth Rotation and Reference Systems Service.

Each realisation is a new list. ITRF88, ITRF89, and so on through ITRF2008, ITRF2014,
ITRF2020. They differ from each other at the millimetre to centimetre level.

Why it matters to you: WGS 84 for GPS, GTRF for Galileo, PZ-90.11 for GLONASS and
CGCS2000 for BeiDou are each aligned to ITRF at centimetre level. NAD83(CSRS) is defined
by a published transformation from ITRF. So ITRF is the hub through which every
constellation and every national frame is compared. When you ask "are these two
coordinates the same place", the answer is computed in ITRF whether or not anyone says so.

## A4. What is a datum

A datum is the answer to "where do we put the model of the Earth".

It has two parts. First, a **shape**, almost always an ellipsoid, defined by a semi-major
axis and a flattening. Second, an **anchoring** of that shape to the physical planet,
historically by a marked monument, now by the coordinates and velocities of a global
station network.

The shape alone is not a datum. WGS 84 and NAD83 both use ellipsoids that are nearly
identical in size. They differ because they are anchored differently. That is why the
offset between them is over a metre while the ellipsoid difference is sub-millimetre.

Modern ISO wording says **geodetic reference frame** rather than geodetic datum, and adds
**dynamic geodetic reference frame** for the ones that carry velocities. Expect both terms
in the literature.

A **datum ensemble** is a group of realisations treated as interchangeable for approximate
work. See Part C.

## A5. Transformation versus conversion

This is the single most useful distinction in the chapter, and ISO 19111 draws it
precisely.

A **conversion** changes the coordinate system but not the datum. Latitude and longitude
on WGS 84 to UTM zone 10N on WGS 84 is a conversion. It is defined by an exact formula. It
is reversible to the limits of floating point. It has no uncertainty of its own. Nothing
moves on the ground.

A **transformation** changes the datum. NAD83(CSRS) to WGS 84 (G1762) is a
transformation. It is **estimated from observations**, so it has a published accuracy. It
is **not unique**, so several valid transformations exist between the same pair and they
give different answers. It often depends on a **grid shift file**, an external data
product with its own version. Things move on the ground, by metres.

Both are called **coordinate operations** collectively.

The practical test, and a good line for the chapter: if the operation has an accuracy
figure attached, it is a transformation, and you must record which one was used. If it
does not, it is a conversion, and it is not your problem.

The confusion is baked into the standards. ISO/TC 211 StandardsTracker issue 43, open
since 2009, records that ISO 19123 uses both words interchangeably while ISO 19111
distinguishes them.

## A6. How PROJ versions differ, and why it matters to reproducibility

PROJ is the transformation engine underneath GDAL, QGIS, PostGIS, `sf` and effectively
everything else. Its architecture changed fundamentally twice, and both changes altered
numerical results, not just interfaces.

**PROJ.4, roughly 1990 to 2018.** Originally a cartographic projection engine written by
Gerald Evenden at USGS. Datum handling was bolted on afterwards through `+towgs84` and
`+nadgrids`. Its design used **early binding**: a datum shift was baked into the
definition of each coordinate reference system, and every transformation pivoted through
WGS 84 as a hub. This is why a definition string could silently carry a seven-parameter
shift that nobody had chosen deliberately.

**PROJ 5, 2018.** Introduced the transformation **pipeline**, an explicit sequence of
steps, and four-dimensional coordinates with a time component. It stopped requiring the
WGS 84 pivot. This is the point at which a transformation became something you could write
down and re-execute exactly.

**PROJ 6, 2019. The break that matters most.** PROJ stopped being a projection engine
with datum shifts attached and became a full coordinate reference system and coordinate
operation library conforming to ISO 19111. Concretely:

- The **EPSG dataset was imported into PROJ itself** as an SQLite database, `proj.db`,
  along with the French IGNF registry and the ESRI database. Before this, definitions were
  scattered across ad hoc CSV files in PROJ, GDAL and libgeotiff, and they disagreed.
- **WKT2 support** arrived, so a coordinate reference system could be written and read
  without loss.
- **Late binding** replaced early binding. PROJ now looks up candidate transformations in
  EPSG, each with its own stated accuracy and area of validity, and picks one. This means
  the same request can resolve to a different operation depending on which grid files are
  installed.
- **Axis order now follows the authority.** EPSG:4326 is latitude first. Most GIS software
  had always assumed longitude first. Enormous quantities of code broke or silently
  swapped coordinates. `proj_normalize_for_visualization()` exists to paper over this.

**PROJ 7, 2020.** Grid handling was reworked. Grids moved to a GeoTIFF-based format and
can be fetched on demand from a content delivery network rather than installed locally.
Good for convenience. Bad for reproducibility unless you pin, because the set of grids
available to your machine now depends on your network.

**PROJ 8 and 9, 2021 onward.** Coordinate epoch and dynamic reference frame handling
matured, deformation models were added, and the database schema gained fields such as the
datum anchor. **[verify]** exact feature-to-version mapping if you cite it.

**The reproducibility consequence, and this is the paragraph for the chapter.** Two
analysts running the identical command on the identical file can obtain different numbers
because the transformation is chosen at run time from a database whose version, and from
a grid collection whose contents, differ between their machines. This is not a bug. It is
the design. It is also why "I reprojected to WGS 84" is not a reproducible statement, and
why the submission specification must capture the PROJ version, the EPSG database version
and the grid versions alongside the operation code.

## A7. What is EPSG, when did it arise, and why is it authoritative

**EPSG** stands for European Petroleum Survey Group. The dataset was created in 1985 by
Jean-Patrick Girbig of Elf, to standardise and share spatial definitions among member
companies. It was made public in 1993.

In 2005 the EPSG organisation was disbanded and its work taken over by the newly formed
**IOGP**, the International Association of Oil and Gas Producers, through its Geomatics
Committee. The name EPSG was kept to avoid confusion. The dataset is maintained day to day
by the IOGP Geodesy Subcommittee, whose members are geodesists from operating companies,
survey firms, software vendors and national mapping agencies, meeting monthly. It now
holds over ten thousand definitions and conforms to ISO 19111:2019.

**Why it is authoritative.** Not because it is correct in some absolute sense. Because of
its governance properties, which are exactly the properties an audit trail needs:

- **Stable unique identifiers.** Every entity gets an integer code. Codes are never reused.
- **Deprecation rather than deletion.** Superseded definitions stay in the register,
  marked, so an old dataset can still be interpreted.
- **Transformations carry accuracy and area of validity.** The register does not just say
  how to convert, it says how well and where.
- **A published change control process.** Change requests are submitted, reviewed and
  versioned.
- **It is embedded everywhere.** Since PROJ 6, the EPSG dataset ships inside PROJ, and
  therefore inside GDAL, QGIS, PostGIS, `sf` and the rest.

The irony worth a footnote in a forest carbon book: the global authority for geospatial
truth is maintained by the oil and gas industry, and has been since 1985.

---

# Part B. Simple Features, explained properly

I explained this badly before. Here it is from the beginning.

**Simple Features is not a file format.** It is a **data model**: an agreed answer to two
questions. What counts as a shape? And what questions may you ask about shapes?

**What counts as a shape.** Seven types. Point, LineString, Polygon, and their plural
forms MultiPoint, MultiLineString, MultiPolygon, plus GeometryCollection. That is the
whole vocabulary. A Polygon is one outer ring and any number of inner rings, each ring
being a closed sequence of vertices.

**What "simple" means.** It is a technical term, not a claim about ease. A geometry is
*simple* if it does not cross itself. A figure-eight line is not simple. This is why the
model is called Simple Feature Access.

**What you may ask.** A fixed set of yes-or-no questions, formally derived from something
called the DE-9IM: does A intersect B, contain B, touch B, cross B, overlap B, is A within
B, is A disjoint from B, does A equal B. These are the **predicates**. Separately there are
**operations** that make new shapes: buffer, intersection, union, difference, convex hull.

**How it is written down.** Two encodings. **WKT**, well-known text, is the human-readable
one, `POINT(-125.27 50.02)`. **WKB**, well-known binary, is the machine one. In SQL every
function gets the prefix `ST_`, so `ST_Area`, `ST_Intersects`. When you see `ST_` you are
looking at Simple Features.

**Where it lives.** Underneath shapefiles, GeoJSON, GeoPackage, PostGIS, GEOS, GDAL and
OGR, QGIS, and the R package `sf`, whose name is literally Simple Features. It is not one
implementation you can avoid. It is the shared assumption of the entire stack.

**Now the part that causes your problem.** A LineString is defined by its vertices *plus
an implicit rule about what lies between them*. ISO 19125-1 fixes that rule as **linear
interpolation**. Straight lines. And "straight" is defined in whatever number space the
coordinates happen to live in.

The model was designed for a plane, for metres on a survey grid. Nothing stops you putting
degrees of longitude and latitude into it, and everyone does. When you do, "straight"
quietly means straight in a grid of degrees, which is an equirectangular projection you
never chose, never declared, and cannot see.

**The analogy to use in the chapter.** Simple Features is a grammar for shapes. It tells
you what a well-formed sentence looks like. It does not tell you which language you are
speaking. Feed it degrees and it parses perfectly and means something other than you
intended.

**What that costs, concretely.** Two vertices a hundred kilometres apart at 50 degrees
north, joined by a Simple Features edge, describe a different line on the ground from the
one a surveyor would walk. Near the poles, and along any long east-west boundary, the two
diverge enough to change an area. The vertices agree. The polygon does not.

---

# Part C. Fixing "WGS 84 is not a datum", and what WKT2 actually does

**First, a correction to your draft.** The heading should not say six. ISO 19111:2019 gave
six members in its example. The current EPSG dataset lists **seven**, having added
**WGS 84 (G2139)**. Run `projinfo EPSG:4326` on your own machine and print whatever it
returns, with the PROJ and EPSG versions beside it. That is a better figure than a fixed
number, because it demonstrates the point that the answer changes.

## C1. Does WKT2 fix it?

Partly, and the partial answer is the interesting one.

**What WKT2:2019 adds.** It can say, in machine-readable form, that WGS 84 is an ensemble.
Ask PROJ for EPSG:4326 in WKT2:2019 and you get a `GEOGCRS` containing an `ENSEMBLE` block
that lists each `MEMBER` by name, and closes with `ENSEMBLEACCURACY[2.0]`. Two metres,
stated in the definition itself.

It also handles time. A dynamic reference frame carries `DYNAMIC[FRAMEEPOCH[...]]`, and a
`COORDINATEMETADATA[...]` wrapper can attach an `EPOCH[...]` to the coordinates
themselves, for example a frame epoch of 2005.0 with a coordinate epoch of 2016.47.

**What that means.** WKT2 does not remove the ambiguity. It cannot; the ambiguity is real.
What it does is **convert a silent error into a declared uncertainty**.

That is worth more than it sounds. A silent error cannot be audited. A declared
uncertainty of two metres can be tested against a materiality threshold, reported as an
ISO 19157 positional accuracy with a confidence statement, and either accepted or made the
subject of a corrective action request. WKT2 does not fix the problem. It makes the
problem into evidence.

## C2. The actual fix, in five steps

1. **Require the member, not the ensemble.** The submission states WGS 84 (G1762), or
   NAD83(CSRS), not "WGS 84". GDAL's own documentation says plainly that EPSG:4326 is not
   recommended for precise work because of the two-metre ensemble accuracy, and that a
   realisation should be used instead.
2. **Require the coordinate epoch**, as a decimal year, alongside the frame.
3. **Require the transformation by EPSG code**, not by prose, together with its published
   accuracy.
4. **Store as WKT2:2019, not as a `.prj`.** A shapefile `.prj` holds ESRI WKT1, which has
   no ensemble block, no epoch and no accuracy. It physically cannot carry the fix.
   GeoPackage can. This is the strongest practical argument in your book for leaving the
   shapefile behind, and it is much better than the usual complaints about field-name
   length.
5. **Pin the software.** PROJ version, EPSG database version, grid file versions. Without
   these the transformation is not reproducible even when the code is recorded.

**One line for the chapter.** WGS 84 is not a datum, it is a two-metre agreement to stop
arguing. That agreement is fine for navigation and fatal for a hectare-accurate carbon
inventory.

---

# Part D. The three rules, improved, and where to put them

## D1. The rules, rewritten

Your section 3.3 was four bullets doing three jobs. Here it is as three rules with the
reasoning attached.

**Rule one. Do the geometry on the globe.** Predicates, overlays and indexing on
longitude and latitude should be computed with spherical geometry, which in R means the
`s2` engine that `sf` uses by default. The reason is not that a sphere is more accurate
than a plane. It is that the spherical library uses **exact arithmetic for its
predicates**, so the answer to "is this plot inside this jurisdiction" is identical on
every machine, every operating system and every version. Planar predicates on floating
point coordinates are not. **Determinism is the win, not accuracy.**

**Rule two. Do the measurement on the ellipsoid.** No number that reaches a verification
statement may come from spherical or projected geometry. Areas, lengths and distances come
from **geodesic** calculations on a declared ellipsoid, which implement Karney's
algorithms. In R that is `lwgeom::st_geod_area()` and its siblings. The gap between
spherical and ellipsoidal area is small in relative terms and large in absolute terms:
roughly half a percent at the top end. Half a percent of ten thousand hectares is fifty
hectares. At 150 tonnes of carbon per hectare that is about twenty-seven thousand tonnes
of carbon dioxide equivalent.

**Rule three. Declare the surface you used.** Any spherical measurement must state its
sphere radius, because there is no single right one. The `sf` default is 6,371,010 metres.
Any ellipsoidal measurement must state its ellipsoid. Any projected measurement must state
its projection. A number without its surface is not a measurement, it is a rumour.

**And the standing caveat, which belongs beside the rules, not inside them.** Spherical
geometry is not a coordinate reference system. It has no EPSG code, no ellipsoid and no
epoch. Give it a mislabelled coordinate and it returns a fast, exact, perfectly repeatable
answer in the wrong place. It makes the residual error silent and reproducible rather than
removing it. Rules one to three fix *how* you compute. They do not fix *what* you were
given. Only Part C does that.

## D2. Where to introduce them

Do not open with them. They are conclusions and they will read as arbitrary.

**Introduce them at the end of chapter one, as the chapter's contract with the reader**,
immediately after the first worked example has produced two different areas for the same
polygon. The sequence is: show the failure, name the cause, state the rule, then say that
every subsequent chapter obeys it.

Then place a short recurring callout, three or four lines, at the first point in each later
chapter where a measurement is taken, saying which rule applies and why. Readers of
technical books do not remember chapter one. They remember the callout that appears again
in chapter seven.

Give the rules a name so they can be referred to. "The three surfaces" works: globe for
geometry, ellipsoid for measurement, plane for pictures.

---

# Part E. Three original worked examples

These replace the published ones entirely. None reproduces the antimeridian or polar
tests. Each is anchored in Canadian forest carbon work, each has a specified figure, and
each ends in a number a verifier would have to defend.

## Example 1. From satellite to tonnes: the chain figure

**The point.** A coordinate passes through five different geometric spaces before it
becomes a tonne of carbon dioxide, and each handover is a place where a choice is made.

**The figure.** Five panels in a row, one per space, showing the same plot boundary each
time. Panel one, the receiver's own solution as three Cartesian numbers, drawn as a point
in a box with the Earth's centre at the origin. Panel two, the same point on an ellipsoid,
with the ellipsoid drawn exaggerated so the flattening is visible. Panel three, the
boundary drawn on a globe with great-circle edges. Panel four, the same boundary in a UTM
grid, with the grid lines shown so the distortion is visible. Panel five, a bar of tonnes.
Under each panel, a single line: what the numbers are, and what unit.

**The computation.** One script. Take a real five hundred hectare boundary. Compute its
area five ways: geodesic on the declared ellipsoid, spherical at the `sf` default radius,
UTM zone 10N, UTM zone 9N, and BC Albers. Multiply each area difference by a stated carbon
density and the carbon to carbon dioxide ratio of 44 over 12. Report the spread in tonnes,
and at a stated carbon price, in dollars.

**Why it works as an opener.** It converts an abstraction into a number with a currency
symbol on it, in the reader's own domain, before any theory has been introduced.

## Example 2. The cutblock that straddles two UTM zones

**The point.** You do not need the dateline or the pole to break planar geometry. You need
a boundary near 126 degrees west, which on Vancouver Island is ordinary working ground.

UTM zones are six degrees wide. Zone 9 runs from 132 to 126 degrees west with its central
meridian at 129. Zone 10 runs from 126 to 120 with its central meridian at 123. A
management unit spanning 126 degrees west sits in both, and neither is wrong.

**The figure.** The same polygon drawn three times side by side: in zone 9, in zone 10, and
in BC Albers, each with its own grid overlaid so the reader can see the graticule bending
differently in each. Beneath, a four-row table: three projected areas and the geodesic
area, with the differences in hectares and in tonnes.

**The computation.** Scale factor along a UTM central meridian is 0.9996 and rises above 1
toward the zone edge. Area scales as the square of that. So the same polygon measured on
opposite sides of a zone boundary can differ by a few tenths of a percent. On five hundred
hectares that is one to two hectares, which at 150 tonnes of carbon per hectare is roughly
five hundred and fifty to eleven hundred tonnes of carbon dioxide equivalent.

**Why it works.** It is domestic, it is unpublished, and it removes the reader's defence
that this only matters at the poles.

## Example 3. The five-kilometre buffer at 68 degrees north

**The point.** Why a projection distorts, shown rather than asserted, using an operation
every analyst performs weekly.

Web Mercator stretches distances by one over the cosine of the latitude. At the equator
the factor is one. At 60 degrees north it is two. At 68 degrees north, ordinary boreal
forest, it is about 2.7. So a buffer drawn as a five-kilometre circle in Web Mercator
encloses ground that is nothing like five kilometres across.

**The figure.** This is the best visual aid in the chapter. Draw a latitude and longitude
graticule in Web Mercator, so the reader sees the parallels pulled apart as latitude
increases. Overlay two shapes at 68 degrees north: the circle a planar buffer produces, and
the true geodesic buffer, which is an egg. Repeat the same pair at 49 degrees north, where
the two nearly coincide. Two rows, four panels. The reader sees the plane failing
progressively, which is far more instructive than seeing it fail catastrophically at a
pole.

**The computation.** Compare the enclosed area of the planar buffer against the geodesic
buffer at 49, 60 and 68 degrees north. Report the ratio. Then note that boreal REDD+ and
Canadian improved forest management projects sit in the third row, and that leakage belts,
buffer zones and reference regions are routinely defined by buffering.

**Why it works.** It teaches distortion as a continuous function of latitude rather than as
an edge case, and it targets an operation that is almost never checked.

---

# Part F. Satellite geometry in plain terms

Rewritten with every abbreviation expanded and every term defined on first use. This
replaces Part 4 of the previous draft.

## F1. What a satellite receiver actually does

A navigation satellite broadcasts a signal that says, in effect, "I am here, and I sent
this at this instant". The receiver picks up signals from several satellites, works out how
long each took to arrive, multiplies by the speed of light to get a distance, and then
finds the one point in space consistent with all of those distances at once. Four
satellites are the minimum, because there are four unknowns: three for position and one for
the receiver's own clock error. The technique is called **multilateration**, meaning
position from multiple distances.

The answer comes out as three plain numbers measured in metres from the centre of the
Earth: X, Y and Z. This is called **Earth-centred, Earth-fixed**, abbreviated **ECEF**,
because the origin is the Earth's centre of mass and the axes turn with the planet.

There is no sphere here and no flat map. There is only ordinary three-dimensional space,
the kind you learned in school geometry. This is the important sentence: **the measurement
itself is not made on any map, on any ellipsoid or on any sphere.** All of those come
later, and all of them are conventions.

## F2. The frames, briefly

Satellite orbits are first computed in a frame that does not spin with the Earth, an
**inertial** frame, tied to distant radio sources through the **ICRF**, the International
Celestial Reference Frame. That is convenient for orbital mechanics and useless for
navigation, so the positions are rotated into the ECEF frame before use.

Each satellite system publishes its positions in its own realisation of that Earth-fixed
frame:

- **GPS**, United States, uses WGS 84.
- **Galileo**, European Union, uses the **GTRF**, Galileo Terrestrial Reference Frame.
- **GLONASS**, Russia, uses **PZ-90.11**.
- **BeiDou**, China, uses **CGCS2000**.

All four are aligned to the ITRF at centimetre level, which is why a multi-constellation
receiver can mix them without anyone noticing.

## F3. Where the ellipsoid comes in, and why it is last

Latitude, longitude and height are not measured. They are **computed from** the ECEF
numbers by choosing an ellipsoid and asking where the point falls on it. The WGS 84
ellipsoid has a semi-major axis of 6,378,137 metres and an inverse flattening of
298.257223563, meaning it is squashed at the poles by about one part in three hundred.

Height needs one more step. The ellipsoid is a smooth mathematical shape and sea level is
not. Converting ellipsoidal height into the **orthometric height** a forester recognises,
height above sea level, requires a **geoid model**. Canada's is CGG2013a, realising the
vertical datum CGVD2013.

**So the order is: measurement, then convention.** The Cartesian solution is not
negotiable, because it is what the physics produced. The ellipsoid is negotiable, because
it is a choice made in software afterwards. A sphere, as used by spherical geometry
libraries, is a further approximation applied after that.

This is exactly why swapping the ellipsoid for a sphere at the receiver cannot improve the
measurement. You would be replacing a convention applied to a good answer with a coarser
convention applied to the same good answer.

## F4. The sourcing aside, kept

The Wikipedia page on spatial reference systems gives a table listing EPSG:4326 with a
GRS 80 ellipsoid, and reproduces immediately below it the well-known text for the same
code, which correctly shows the WGS 84 spheroid with semi-major axis 6,378,137 and inverse
flattening 298.257223563. Two statements on one page disagreeing about the shape of the
Earth. Use it as the chapter's argument for going to the register rather than the
secondary source.

---

# Part G. Building a receiver that uses spherical cells well

You are not convinced, and you are half right. My previous framing was too flat. Let me
separate the claim that is wrong from the claim that is right.

**Wrong:** that a spherical cell system can improve the position solution. It cannot. It
carries no ellipsoid, no realisation and no epoch, it discards height, and its finest cell
is about a centimetre across, which is coarser than survey-grade positioning resolves.
Quantising before the solution destroys information.

**Right, and this is the part I underplayed:** the collection software is where your
reproducibility is lost, spherical cells solve a real problem in that layer, and nobody has
built it. Four designs, in increasing ambition.

## Design 1. Cell as the key, coordinate as the record

The receiver stores full-precision ECEF and geodetic coordinates with the frame,
realisation and epoch attached, and *additionally* emits a cell identifier at a declared
level. The identifier is a single sortable integer. Two submissions from different years,
different contractors and different software can then be joined, deduplicated and diffed
without running a spatial engine and without either party's geometry being trusted.

Cost: nothing. Accuracy impact: none, because the coordinate remains the record.

## Design 2. Validate the loop in the field

The collector builds the boundary as a spherical loop while the crew is walking it, not as
a planar ring afterwards. It refuses to close a ring that self-intersects, has duplicate
vertices, or has inconsistent winding, and it flags any edge long enough that planar and
geodesic interpretation would differ materially.

The value is timing. A boundary defect found in the field costs an hour of re-walking. The
same defect found by a verifier eighteen months later costs a corrective action request and
possibly a season.

## Design 3. Cells as an uncertainty-matched plot identifier

This one is the direct answer to your instinct, and it is genuinely good.

Choose a cell level **coarser than your positional uncertainty**. Cell edge length roughly
doubles with each step up: about a centimetre at the finest level, ten metres or so about
ten levels up, a hundred and fifty metres or so a few levels above that. Pick the level
whose cells comfortably exceed your ninety-five percent positional uncertainty, including
the two-metre ensemble ambiguity.

The covering of your plot at that level is then **invariant** to the sub-metre problems
that cause your disputes. Correcting the datum label from WGS 84 to NAD83(CSRS) shifts the
coordinates by a metre and a half and does not change the covering. Changing the PROJ
version does not change the covering. Reprojecting does not change the covering.

You have separated two things that were tangled: **identity**, where is this project, which
should be robust to sub-metre noise, and **magnitude**, how large is it, which must not be.
Identity becomes a stable integer that survives every reprojection in your four handoffs.
Magnitude stays a geodesic computation on declared coordinates.

That is a real answer to "how do we stop reprojections breaking things", and it is
achievable in software today. It just does not work by making the fix more accurate.

## Design 4. The dual-track submission

Combine designs one to three into the artefact a registry should require. Every plot
submission carries a covering at a declared level as its identity, full-precision
coordinates with frame, realisation and epoch as its measurement basis, a geodesic area
with its ellipsoid, and a signed hash of the raw observations.

Identity is reproducible by construction. Magnitude is reproducible by declaration. Neither
depends on the other. And a verifier can check identity in a second, with an integer
comparison, before spending a day on the geometry.

**The rule that keeps all four honest.** The cell is never the coordinate of record, and
quantisation never happens before the position solution. Everything else is available to
build.

---

# Part H. The auditor's toolkit

Parts 5 and 6 of the previous draft, combined and cut. Three sections: what to ask for,
how to test it, what to write when it fails.

## H1. What an audit-ready submission contains

Seven items. Make them conformance criteria in a data product specification, not requests
in an email. Delivered as a machine-readable sidecar file, one record per dataset.

1. **The realisation, not the family.** WGS 84 (G1762) or NAD83(CSRS), never plain WGS 84.
2. **The coordinate epoch**, as a decimal year.
3. **The transformation used**, by EPSG code, with its published accuracy.
4. **Software versions**: PROJ, EPSG database, and any grid shift files.
5. **The edge rule**: planar or geodesic.
6. **The measurement basis**: the method and the ellipsoid the area was computed on.
7. **A checksum** over the geometry.

Store it in a format that can hold it. A shapefile `.prj` cannot. GeoPackage can.

## H2. How to test what arrives

**Four questions, from ISO 19011 Annex A.5.** Is the information complete, correct,
consistent and current? Apply them to the submission's metadata, not just to its geometry.
A projection file with no epoch fails "complete", and it fails for a structural reason, not
because anyone withheld anything.

**One rule about evidence, from ISO 19011 clause 6.4.7.** Only information that can be
verified to some degree counts as audit evidence, and where verifiability is low the
auditor must use professional judgement about how much reliance to place on it. A boundary
whose realisation is unknown is low-verifiability evidence. Say so in the file. Do not
silently recompute and hope.

**A vocabulary for the finding, from ISO 19157.** Positional accuracy is not one thing.
Absolute external accuracy is how far the data are from truth. Relative internal accuracy
is how well the vertices agree among themselves. The ensemble problem damages the first and
leaves the second intact, so you can say "internally excellent, externally uncertain to two
metres" instead of arguing about whether the data are good.

**A way to qualify a number you cannot fully stand behind, also from ISO 19157.**
Metaquality is information about the quality of your quality statement, with three
elements: confidence, representativity and homogeneity. Report the accuracy figure and
attach a confidence statement naming the unresolved ensemble. Use homogeneity where a
boundary was captured across seasons on different base stations. This is the mechanism that
lets you be honest without either accepting or rejecting outright.

## H3. Where the threshold comes from, and what to write

**ISO 19157 sets no thresholds and says so in its scope.** Acceptable quality lives in the
**conformance quality level**, a threshold stated in a data product specification or in
user requirements. So the registry or the verification body must set it, because ISO has
declined to. Chapter one should say this plainly: the reproducibility contract is not a
coordinate reference system declaration, it is a specification with numbers in it.

**Lineage is the fallback, and it is the weak link.** ISO 19157 routes lineage to ISO 19115
as metadata and calls it general, non-quantitative and illustrative. It also defines
indirect evaluation as assessing quality from external knowledge, and gives lineage as the
example. So when you cannot measure positional accuracy directly, the standard tells you to
rely on lineage, and lineage is exactly what the shapefile export destroyed. That is the
closing argument of the chapter.

**Writing the finding.** ISO 19011 clause 6.4.8 permits grading nonconformities either
quantitatively or qualitatively, so a geospatial reproducibility finding can be graded like
any other. Clause 6.5.1 requires the report to state that an audit is by nature a sampling
exercise, with a risk that the evidence examined is not representative. Both help when the
corrective action concerns a metadata gap rather than a missing document.

## H4. The one rule underneath all of it

Coordinates and their true label travel unchanged from receiver to verifier. Geometry is
computed on the globe. Measurement is computed by geodesic on a declared ellipsoid.
Projection happens only when a picture is drawn, and is discarded afterwards.

---

# Sources checked for this document

- PROJ documentation, release notes and FAQ, proj.org. PROJ 6 scope change, EPSG database
  integration, late binding, axis order.
- GDAL documentation, gdal.org. WKT2 ensemble breakdown, coordinate epoch support, and the
  recommendation against EPSG:4326 for precise work.
- EPSG history, epsg.org, and IOGP Guidance Note 373-07-1.
- ISO 19011:2018, clauses 4, 6.4.7, 6.4.8, 6.5.1, Annex A.5.
- ISO 19157:2013, scope, clauses 4.4, 4.10, 4.17, 4.20, 7.3, and the lineage note. Confirm
  current edition.
- ISO 19125-1, linear interpolation between vertices.
- ISO 19111:2019, clause 3.1.16, datum ensemble.
- ISO/TC 211 StandardsTracker issues 43, 103, 131, 553.
