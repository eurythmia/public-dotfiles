---
name: typst
description: This skill should be used when writing, editing, compiling, rendering, or debugging Typst documents (`.typ` files), or when driving the `typst` CLI (compile, watch, query, eval, init, fonts, update). Applies whenever Typst markup, math, scripting, set/show rules, templates, or `@preview` packages are authored or built — including converting Markdown or LaTeX sources to Typst.
---

# Typst

Typst is a markup-based typesetting system compiled to PDF/PNG/SVG/HTML by a
single small binary. It fuses three syntactical modes, and almost every mistake
is a mode error or a Markdown/LaTeX habit.

## The mode model — learn this first

| Mode | Entered by | Example |
|------|-----------|---------|
| Markup (default) | — | `= Heading`, `- item`, `*strong*` |
| Code | `#` | `#rect(width: 1cm)`, `#let x = 1` |
| Math | `$…$` | `$x^2$` |

- In code mode, `[..]` is a **content block** (markup as a value) and `{..}` is a
  **code block** (statements; the last value is the result).
- A semicolon ends an expression early while still in markup: `#x;`.
- `#` starts an expression in text, so a literal hash must be escaped: `C\#`.

## Critical rules

1. **Typst is not Markdown.** Emphasis is `_like this_`; strong is `*like this*`
   — the *reverse* of Markdown. `**bold**` silently produces a warning and no
   bold. Verify, don't assume.
2. **A heading needs a space after `=`.** `=Heading` is plain text and emits
   **no error**.
3. **Compile after every edit.** Compilation is milliseconds; never present
   unchecked `.typ`. Use `typst compile --diagnostic-format short`.
4. **Set rules take only named, optional parameters.**
   `#set text(size: 11pt)` — never `#set text("x")` (`error: unexpected
   argument`).
5. **Introspection requires `context`.** Page counters, `query`, `here`, etc.
   only work inside `#context [..]`.
6. **In math, a run of letters is one variable.** `$speed$` is an unknown
   variable, not the word — write `$"speed"$`.
7. **Do not invent functions or parameters.** The reference is precise and
   errors are exact; check it rather than guessing an API.

## CLI workflow

```bash
typst compile [--diagnostic-format short] doc.typ     # -> doc.pdf
typst watch doc.typ                                   # recompile on change
typst compile --pages 2,4-6 doc.typ 'out-{0p}.png'    # PNG/SVG need a page template
typst init @preview/<template> dir                    # scaffold a project
typst fonts                                           # list discovered fonts
typst eval --in doc.typ 'query(heading).map(h => h.body)'  # inspect a document
typst update                                          # self-update
```

Output format is inferred from the extension (`.pdf`, `.png`, `.svg`, `.html`);
`-` reads stdin / writes stdout. Keep the prebuilt binary on `PATH` (commonly
`~/.local/bin/typst`). All flags, env vars and package paths: `references/cli.md`.

## Language

Markup, styling (set/show rules), scripting, modules and packages:
`references/language.md`. Mathematics: `references/math.md`.

Minimal document:

```typst
#set page(margin: 2cm)
#set heading(numbering: "1.")
#set text(font: "New Computer Modern", size: 11pt)

= Introduction <intro>
Typst is #emph[fast]. See @intro.

$ E = m c^2 $
```

## Music and scores

For engraved music use a package, not hand-drawn staves: `@preview/scoryst`
(renders ABC / MusicXML / MEI / … via Verovio/WASM) and `@preview/typed-scores`
(Western notation from compact note text, with lyrics). Both are Typst-native;
for playback you still need MIDI (abc2midi / LilyPond), since Typst has no audio.

## Pitfalls

Message -> cause -> fix index, plus the silent-failure traps (headings, bold,
fonts): `references/pitfalls.md`. Read it before debugging a failure that
produced no error.

## Official sources

- Documentation: https://typst.app/docs/
- Tutorial: https://typst.app/docs/tutorial/
- Reference: https://typst.app/docs/reference/
- Universe (templates & packages): https://typst.app/universe/
- Guide for LaTeX users: https://typst.app/docs/guides/for-latex-users/
- Source & releases: https://github.com/typst/typst
