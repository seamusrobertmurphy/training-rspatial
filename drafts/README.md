# Chapter drafts

One chapter at a time. This directory is its own Quarto project, so a draft
renders in about twenty seconds instead of the twenty minutes a full book render
takes, and it cannot overwrite `_book`.

```
quarto render drafts/01-positional-accuracy.qmd
```

Output lands in `drafts/_out/` as HTML and docx. Read the docx, mark it up, and
the marked copy is the input to the next revision.

Paths inside a draft are relative to the repository root because Quarto sets the
working directory to the project root, which here is `drafts/`. So data reads
need `../data/`, not `data/`. That is the one gotcha.

When a chapter is approved it moves to the repository root under its permanent
filename, is added to `book.chapters` in the root `_quarto.yml`, and the file it
replaces is deleted in the same commit. Book filenames never change once
published, per the rule in `CLAUDE.md`.

Briefs for each chapter are in `../publishing/chapter-briefs/`. The arc every
chapter owes is in `../publishing/book-spine.md`.
