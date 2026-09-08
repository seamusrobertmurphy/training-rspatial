# Chapter eval scoreboard

One block per chapter per pass, appended and never overwritten. The rubric is in
`rubric.md` and the deterministic half is `eval-chapter.py`. Scores run 0 to 3
on seven dimensions and a chapter is not finished below 2 on any of them.

Dimensions, in the order they are scored below: numbers computed, external
claims opened, spine debt paid, boundaries held, entry and edge, voice, renders
twice.

## Baseline, 8 September 2026

Measured before the loop started, over every chapter in the repository.

The thirteen chapters in the book proper carry zero inline expressions between
them, so every number in their prose was typed by hand. The five drafts carry
219. The rule that every number in the prose comes from executed code is met by
the drafts and by nothing else, and that gap is what the loop closes as each
legacy chapter is replaced by its draft.

Two failures were found and fixed on the first run. A `Chapter 1` reference in
the prose of `drafts/04-airborne-laser.qmd`, and three more in
`drafts/02-reflectance.qmd`, all of which would have broken silently the moment a
chapter was inserted before them.

| Corpus | Prose words | Computed values | Colons in prose |
|---|---|---|---|
| thirteen chapters in the book proper | 27,688 | 0 | 141 |
| six drafts | 20,404 | 219 | 4 |

## 06-plot-design, pass 1, 8 September 2026

Deterministic: 0 failures, 2 candidates, both classified as inputs. The 0.90 is
the nominal quadrat-scale correlation the stratifier was built to, which is a
design parameter set in the chunk above it, and the 1.6 hectares is the fixed
effort the plot-size comparison holds constant.

| Dimension | Score | Evidence |
|---|---|---|
| Numbers computed | 3 | 78 inline expressions over 3,674 words, every reported result among them |
| External claims opened | 3 | The chapter cites no external standard or paper, so nothing rests on memory |
| Spine debt paid | 3 | The frame section measures it: restricting centres moved the estimand from 32.90 to 33.12 m2/ha, a gap no sample size removes |
| Boundaries held | 3 | Basal area rather than biomass throughout, so the allometric equation stays in chapter 7; the stratifier's support mismatch is handed to chapter 9 by name |
| Entry and edge | 3 | Enters on a complete census, closes on 46 per cent of forty-plot inventories passing a test they were designed to pass |
| Voice | 3 | No dashes, no colons outside the track heading, no first person, past tense throughout |
| Renders twice | 3 | Both formats, `set.seed(2026)` on every random draw |

The one simulated quantity, the 3 per cent growth increment, is there because a
known truth was required to isolate relocation error, and the draft says so in
the sentence that uses it. It is recorded in the chapter's open decisions with
the fix, which is the 2013 and 2018 SCBI censuses.

The chapter corrected its own brief. The 4 September brief held that a five
metre fix compounds sampling error because it moves which trees are in the plot.
Measured, a 20 metre error costs 3.4 per cent on a one-off stand mean, while a
three metre relocation error drops the signal-to-noise on a growth estimate from
16.5 to 0.66.

## Harness calibration, 8 September 2026

The first full run cried wolf three ways and each exemption is principled rather
than convenient.

A contents page and a preamble must name chapters by number, so front matter is
exempt from that check. The drafting callouts titled Draft, Revision, Condensed
and Open decisions are scaffolding stripped when a draft is promoted, so their
working notes are not held to the prose rules. And a chapter of somebody else's
document may be named by number, as in Chapter 5 of the 2019 Refinement
Supplement, which the check now recognises by looking for the document marker on
either side of the reference across a ninety character window, because the
marker frequently sits on the next line.

The exemptions were regression tested rather than assumed. A `chapter 9`
reference appended to the clean chapter 6 draft is still caught.

Four real failures were fixed on the way. A `chapter 2` reference in the prose of
the laser chapter, a `Chapter 1` in the same file, three in the reflectance
chapter, and two colons in the terrain chapter.

| Corpus | Failures | Candidates |
|---|---|---|
| six drafts and the contents page | 0 | 192 |
| sixteen files in the book proper | 185 | 75 |

The 143 candidates on the contents page are the chapter and section numbers a
contents page consists of. The 185 failures in the book proper are the backlog,
almost all colons in prose, and each clears as its chapter is replaced by a
draft.
