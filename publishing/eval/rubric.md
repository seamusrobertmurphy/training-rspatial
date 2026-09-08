# Chapter eval rubric

Set 8 September 2026. Two halves. `eval-chapter.py` runs the half a regex can
decide and this file governs the half it cannot. Run both on every chapter as it
lands, before it is committed.

The deterministic half returns failures and candidates. A failure is a rule
broken and is fixed before commit. A candidate is a number typed into prose that
may legitimately be an input the author chose rather than a result a chunk
computed, and the grader below decides which.

## How to score

Each of the seven dimensions scores 0 to 3. A chapter is not finished below 2 on
any dimension. Record the score, the evidence and the fix in
`publishing/eval/scoreboard.md`, one block per chapter per pass, and never
overwrite an earlier pass.

- **3** met, with evidence on the page
- **2** met, but the evidence is thin or sits somewhere the reader will not find
- **1** attempted and not carried
- **0** absent, or the chapter argues against it

## The seven dimensions

### 1. Numbers are computed, not remembered

Every candidate the script returned is classified. A number that is a result,
anything the analysis produced, must come from an inline expression evaluated on
the page. A number that is an input, a diameter threshold, a plot size, a
confidence level, a published constant, may be typed, and where it is a
published constant it carries its source.

Score 0 if any result in the prose is a literal. This is the rule that has
caught real errors in this book more than once, so it is graded hardest.

### 2. External claims were opened, not recalled

Every claim about a standard, a protocol or a published paper is checked against
the primary document in `references/` or `references/standards/` at the moment
of grading, not against a note. The check names the file, the table or section,
and the page. A claim that cannot be re-run from its own citation is not
issuable and the chapter loses the claim rather than softening it.

Score 0 if any external claim rests on memory. The Murphy Table 8 inversion,
which reached a committed draft on 5 September 2026 through a memory entry,
is the standing example.

### 3. The chapter pays its spine debt

The spine is the geometry the arithmetic ran on and the support the answer has.
The chapter's brief in `publishing/chapter-briefs/` states what this chapter
owes it. The grader finds the passage that pays it and quotes the line. A
chapter that mentions support in passing without measuring anything about it
scores 1.

### 4. Boundaries hold

The brief assigns each chapter a scope and names what belongs to its neighbours.
The grader checks that nothing here belongs next door and that the chapter hands
forward explicitly. A chapter that quietly annexes the next one's argument
scores 0 even when the annexed passage is good.

### 5. The entry is physical and the edge is measured

The house rule is to enter through something concrete a reader can picture,
reach the methodological question by the middle, and close on a number a
verifier would accept. The grader checks that the edge is a measurement made on
this page rather than a claim, and that the chapter states plainly where its own
result does not hold.

A chapter whose strongest result is simulated scores at most 2 unless the
simulation is there because a known truth was required, and says so.

### 6. The voice is the book's

Plain English, ordinary words, past tense throughout, no first person, sentences
that run and flow rather than clipped fragments, no aphorism standing alone for
effect, no colons or dashes in prose, headings that name what the section shows.
Acronyms expanded on first use. Nothing that reads as composed rather than
reported.

### 7. It renders, and it renders the same twice

The chapter builds in both formats from a cleared freeze cache with no error,
and a second render returns identical numbers. Anything drawing at random
carries a seed. A chapter that cannot be rebuilt is not a chapter.

## What the grader writes back

For each pass, one block naming the chapter, the date, the seven scores, the
evidence quoted for anything scored 2 or below, and the fixes applied. Where a
fix needs a decision that is not the grader's to make, it goes to the chapter
draft's own open decisions callout rather than into the scoreboard, so it
travels with the chapter.
