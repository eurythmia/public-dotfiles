# Pitfalls

Message -> cause -> fix. All messages below were verified against Typst 0.15.1
with `typst compile --diagnostic-format short`.

## Silently wrong (no error)

| Symptom | Cause | Fix |
|---------|-------|-----|
| Text not bold, warning `no text within stars` | Markdown habit `**bold**` | Typst strong is `*bold*`; emphasis is `_italic_` |
| `=Heading` renders as literal text | Heading needs a space after `=` | `= Heading` |
| Wrong/garbled font in output | Unknown font family -> fallback, only a warning | `typst fonts`, then `#set text(font: "Exact Name")` |
| List not rendered as a list | Marker needs a space: `-item`, `+item` | `- item`, `+ item` |
| Quotes/dashes changed unexpectedly | Smart punctuation (`'`, `"`, `--`, `---`, `...`) | Escape with `\` to keep ASCII, or `#set smartquote(enabled: false)` |
| Empty/odd math | `$a=b$` inline vs `$ a = b $` block | Add the spaces for display mode |

## Errors

| Message | Cause | Fix |
|---------|-------|-----|
| `unknown variable: speed` | In math, a letter run is one identifier | `$"speed"$` for text, or define `#let speed = ..` |
| `expected expression` (e.g. at `C#`) | `#` starts code in markup | Escape the hash: `C\#` |
| `label \`<x>\` does not exist in the document` | `@x` with no matching `<x>` | Add `<x>` to the target, or fix the name |
| `cannot reference heading without numbering` | `@label` on a heading, but headings are unnumbered | `#set heading(numbering: "1.")` |
| `can only be used when context is known` | Counter/query/here outside `context` | `#context counter(page).display()` |
| `unexpected argument` on a `set` rule | Set rules accept only named optional params | `#set text(size: 11pt)`, not `#set text("x")` |
| `unknown font family` (warning) | Font not installed / not on `--font-path` | `typst fonts`, install the font, or add `--font-path` |
| `unknown variable` for a function | Misspelled or missing import | `#import` it, or check the reference — do not guess names |
| `expected content, found string` | Passed `"text"` where markup is required | Use a content block `[text]` |
| `unclosed delimiter` on an emphasis line | `_#it.body_`: the closing `_` is parsed as part of the identifier `body_` | Space it out or use `#emph(it.body)` |
| `cannot mutate a constant: array` | Mutating method (`push`, `remove`) called as a function | Call as method: `arr.push(x)` |

## Habits that cause bugs

- **Markdown muscle memory.** `**`, `#` headings, `> quotes`, `|---|` tables,
  `[link](url)` are all different. See `language.md` for the mapping.
- **Debugging a silent failure from the output only.** Compile with
  `--diagnostic-format short`; warnings (fonts, stars) are the usual culprit.
- **Forgetting `context`.** Anything position/page/heading-dependent needs it.
- **Assuming `set` overrides a `show`.** Set rules provide element defaults, but
  show(-set) rules take precedence for the same property regardless of order.
  Scope still matters: a set rule inside `{..}`/`[..]` ends at that block.
- **Editing the compiled PDF by hand.** Only `.typ` is source; recompile.

## Fast checks

```bash
typst compile --diagnostic-format short doc.typ   # terse errors/warnings
typst fonts | grep -i <name>                       # is the font real?
typst eval --in doc.typ 'query(heading).map(h => h.body)'   # structure
typst eval --in doc.typ 'query(<label>).len()'     # does a label exist?
```
