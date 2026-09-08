#!/usr/bin/env python3
"""Deterministic checks on one chapter of the book.

Usage:  python3 publishing/eval/eval-chapter.py <file.qmd> [--json]

Reports every standing rule that can be checked without judgement. Anything
needing judgement is listed as a candidate and handed to the model grader in
publishing/eval/rubric.md rather than being scored here. Run from the repo root.
"""
import re, sys, json, os

# Numbers a chapter is allowed to type by hand, because they are inputs the
# author chose rather than results a chunk computed.
ALLOW_NUM = re.compile(r"""
    (?:19|20)\d{2}          # a year
  | \d+\.\d+\.\d+           # a version triple
  | (?:v|V)\d+\.\d+         # v2.1
""", re.X)

CITED_DOC = re.compile(
    r'(IPCC|Refinement|Guidelines|Protocol|Volume|VM\d+|VMD\d+|VT\d+|ACR|ART|CARB|'
    r'Annex|Appendix|Regulation|Guidance)[^.]{0,60}$', re.I)


def split_source(path):
    src = open(path, encoding="utf-8").read()
    src = re.sub(r'\A---\n.*?\n---\n', '', src, flags=re.S)          # yaml
    lines = src.split("\n")
    in_code = False
    prose, code = [], []
    for i, l in enumerate(lines, 1):
        if re.match(r'^\s*```', l):
            in_code = not in_code
            continue
        (code if in_code else prose).append((i, l))
    return prose, code, src


def prose_text(prose):
    return "\n".join(l for _, l in prose)


def check(path):
    prose, code, src = split_source(path)
    codetext = "\n".join(l for _, l in code)
    findings = []

    def add(rule, line, detail, severity="fail"):
        findings.append(dict(rule=rule, line=line, detail=detail.strip()[:160],
                             severity=severity))

    inline = len(re.findall(r'`r [^`]+`', prose_text(prose)))

    for ln, l in prose:
        if l.startswith((':::', '|')) or re.match(r'^\s*$', l):
            continue
        bare = l
        bare = re.sub(r'`r [^`]+`', ' NUM ', bare)      # computed, fine
        bare = re.sub(r'`[^`]+`', ' CODE ', bare)       # code span, fine
        bare = re.sub(r'\[@[^\]]+\]', ' CITE ', bare)   # citation, fine

        # 1. numbers typed straight into prose
        if not l.startswith('#'):
            for m in re.finditer(r'(?<![\w.$/:-])\d+\.\d+(?![\w%])', bare):
                if ALLOW_NUM.match(m.group()):
                    continue
                add("number-not-computed", ln,
                    f"{m.group()} in: {l.strip()}", "candidate")

        # 2. punctuation the house style bans outright
        for ch, name in (("—", "em-dash"), ("–", "en-dash"),
                         ("§", "section-symbol")):
            if ch in bare and not (name == "en-dash" and
                                   re.search(r'\d\s*–\s*\d', bare)):
                add(f"banned-{name}", ln, l)
        if re.search(r'(?<!-)--(?!-)', bare):
            add("banned-double-hyphen", ln, l)

        # 3. colons in prose, excluding technical notation and the track heading
        if not l.startswith('#'):
            c = re.sub(r'[A-Z]{3,}:\d+', ' ', bare)       # EPSG:32720
            c = re.sub(r'\d+:\d+', ' ', c)                # time or ratio
            c = re.sub(r'https?://\S+', ' ', c)
            for m in re.finditer(r':(?!\s*$)', c):
                add("colon-in-prose", ln, l)

        # 4. a chapter of THIS book referred to by number
        for m in re.finditer(r'[Cc]hapters?\s+\d+', bare):
            before = bare[:m.start()]
            if CITED_DOC.search(before):
                continue                                  # someone else's ch.
            add("chapter-number-in-prose", ln, l)

        # 5. first person
        if re.search(r'\b(I|we|our|us|my)\b', bare) and not l.startswith('#'):
            add("first-person", ln, l, "candidate")

    # 6. headings
    for ln, l in prose:
        m = re.match(r'^(#{2,6})\s+(.*)$', l)
        if not m:
            continue
        h = m.group(2).strip()
        if h.endswith('?'):
            add("heading-is-a-question", ln, h)
        if re.match(r'^(Read|Write|Inspect|Build|Make|Find|Use|Run|Get|Add)\b', h):
            add("heading-is-an-imperative", ln, h)
        words = [w for w in h.split() if w[:1].isalpha()]
        capped = sum(1 for w in words[1:] if w[:1].isupper())
        if len(words) > 2 and capped >= len(words[1:]) * 0.8:
            add("heading-is-title-case", ln, h)

    # 7. reproducibility of anything random
    if re.search(r'\b(runif|rnorm|sample|rbinom|rpois|simulate)\s*\(', codetext) \
       and 'set.seed' not in codetext:
        add("random-without-seed", 0, "chunks draw at random and no set.seed")

    # 8. verification tracks must be unlisted, so a reader may skip them
    tracks = len(re.findall(r'Verification track', prose_text(prose)))

    words = len(re.sub(r'`r [^`]+`', ' N ', prose_text(prose)).split())
    fails = [f for f in findings if f["severity"] == "fail"]
    cands = [f for f in findings if f["severity"] == "candidate"]
    return dict(file=path, words=words, inline_r=inline, tracks=tracks,
                fail=len(fails), candidate=len(cands), findings=findings)


def report(r):
    print(f"\n{r['file']}")
    print(f"  {r['words']} words of prose, {r['inline_r']} computed values, "
          f"{r['tracks']} verification track mentions")
    print(f"  {r['fail']} failures, {r['candidate']} candidates for review")
    by = {}
    for f in r["findings"]:
        by.setdefault((f["severity"], f["rule"]), []).append(f)
    for (sev, rule), fs in sorted(by.items()):
        print(f"  [{sev}] {rule}  x{len(fs)}")
        for f in fs[:6]:
            print(f"        line {f['line']}: {f['detail']}")
        if len(fs) > 6:
            print(f"        ... and {len(fs)-6} more")


if __name__ == "__main__":
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    out = [check(a) for a in args]
    if "--json" in sys.argv:
        print(json.dumps(out, indent=1))
    else:
        for r in out:
            report(r)
        print(f"\nTOTAL  {sum(r['fail'] for r in out)} failures, "
              f"{sum(r['candidate'] for r in out)} candidates across {len(out)} files")
