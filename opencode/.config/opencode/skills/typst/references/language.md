# Typst language

Three modes: **markup** (default), **code** (`#`), **math** (`$…$`). Markup
syntax is almost always sugar for a function call; set/show rules restyle those
functions.

## Markup

| Element | Syntax |
|---------|--------|
| Paragraph | blank line |
| Heading | `= H1`, `== H2`, … (space required after `=`) |
| Strong | `*strong*` |
| Emphasis | `_emphasis_` |
| Bullet list | `- item` (indent to nest) |
| Numbered list | `+ item` (or `1. item`) |
| Term list | `/ Term: description` |
| Raw / code | `` `inline` ``, ` ```lang … ``` ` |
| Link | `https://…` or `#link("url")[text]` |
| Label | `<name>` |
| Reference / citation | `@name`, `@key` |
| Math | `$x^2$` inline, `$ x^2 $` block |
| Line break | `\` at end of line |
| Non-breaking space | `~` |
| Escapes | `\#`, `\$`, `\_`, `\u{1f600}` |
| Comment | `// line`, `/* block */` |

Smart punctuation is automatic: `'x'`/`"x"` -> curly quotes, `--` -> en dash,
`---` -> em dash, `...` -> ellipsis. Escape with `\` to keep ASCII.

## Data types (code mode)

`none`, `auto`, `true`/`false`, `int` (`10`, `0xff`), `float` (`3.14`, `1e5`),
`length` (`2pt`, `3mm`, `1em`), `angle` (`90deg`), `ratio` (`50%`), `string`
(`"hi"`), `content` (`[markup]`), `array` (`(1, 2, 3)`), `dictionary`
(`(a: 1, b: 2)`), `function`, `label`, `symbol`, `module`.

- **Absolute length** units: `pt`, `mm`, `cm`, `in`, `em` (font-relative),
  `fr` (layout fraction).
- **String vs content**: strings are plain characters (`"a" + "b"`), content
  holds markup and concatenates with `+` (`[a] + [b]`).
- An **element** is content whose fields match the parameters it was built with
  (`heading` has `.body`, `.level`, `.depth`).

## Styling

### Set rules

Configure an element's optional parameters. `#set` at top level lasts to EOF;
inside a `{}`/`[]` block it is scoped to that block.

```typst
#set page(margin: 2cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "en")
#set par(justify: true)
#set heading(numbering: "1.")

#set text(red) if draft     // set-if
```

Only **named optional** parameters are allowed — `#set text("x")` fails with
`unexpected argument`.

### Show rules

Restyle selected elements.

```typst
#show heading: set text(navy)                 // show-set
#show heading.where(level: 1): set align(center)
#show "TODO": strong                          // literal text
#show regex("\d+"): it => text(fill: olive, it)   // regex
#show <intro>: emph                           // by label
#show heading: it => block[                    // transformational
  #emph(it.body) #counter(heading).display()
]
#show: doc => template.with(title: "X", doc)   // template (everything) rule
```

Selectors: element functions, `.where(field: value)`, text, `regex(...)`,
labels, and `show:` for everything after the rule. Prefer separate show-set
rules over embedding `set` inside a transformational rule — the former stay
overridable.

## Scripting

- **Expressions**: `#(1 + 2)`, `#calc.max(3, 7)`, `#my-fn(arg)[content]`.
  Trailing content blocks are extra arguments: `list([A], [B])` == `list[A][B]`.
- **Code block** `{ let x = 1; x + 2 }`; **content block** `[markup #x]`.
- **Bindings**: `#let x = 1`, `#let f(a, b) = a + b`, optionally typed.
  Destructure arrays `(a, b)` / dicts `(k1: v1)`; `..` collects the rest; `_`
  discards.
- **Closures**: `(x, y) => x + y`; pre-bind args with `.with(..)`.
- **Conditionals**: `if c [..] else if c2 {..} else [..]`.
- **Loops**: `for x in coll [..]`, `while c {..}`; `break`, `continue`. Loops
  join the results of each iteration.
- **Fields** `x.y`; **methods** `"abc".len()` == `str.len("abc")`; mutating
  methods (`array.push`) must be called in method form.
- **Operators**: `+ - * /`, `== != < <= > >=`, `in`, `not in`, `not`, `and`,
  `or`, `=`, `+=`, `-=`, `*=`, `/=`.
- **Modules**:
  ```typst
  #include "chapter.typ"                 // splice content
  #import "conf.typ": conf                // import items
  #import "util.typ" as util              // import module
  #import "util.typ": a, b as bee
  ```
- **Packages**: `#import "@preview/name:1.2.3": thing` (downloads + caches on
  first use). Find them at https://typst.app/universe.

## Context

Introspection (counters, `query`, `here`, `locate`, page/heading state) cannot
run at parse time. Wrap it in `context`:

```typst
#context [Page #counter(page).display() of #counter(page).final().first()]
#context query(heading).map(h => h.body)
```

Without `context` this fails with `can only be used when context is known`.

## Common elements

| Need | Function |
|------|----------|
| Page geometry | `#set page(paper: "a4", margin: 2cm, numbering: "1")` |
| Paragraph | `#set par(justify: true, leading: 0.65em, first-line-indent: 1em)` |
| Table / grid | `table(columns: 2, [a], [b])`, `grid(...)` |
| Figure | `figure(image("p.png", width: 80%), caption: [..]) <fig>` |
| Image | `image("path.png", width: 6cm)`, `image(bytes, format: "png")` |
| Footnote | `#footnote[text]` |
| Quote | `#quote(attribution: [..])[text]` |
| Outline | `#outline(title: [Contents], indent: 1em)` |
| Columns | `#columns(2)[..]` |
| Layout | `align`, `block`, `box`, `place`, `pad`, `stack`, `v`, `h` |
| Lists | `#set list(marker: [•])`, `#set enum(numbering: "1.")` |
| Bibliography | `#bibliography("refs.bib", style: "ieee")`, cite with `@key` |
| Counter | `#counter("name")`, `#counter(heading).step()` |

Change language with `#set text(lang: "de")` — no separate babel package.
Change page margins with `page(...)`, which forces a page break; use `pad` with
negative values for partial overhang.

## LaTeX / Markdown mapping

| LaTeX | Typst |
|-------|-------|
| `\section{}` | `= ` (one `=` per level) |
| `\textbf{}` / `\textit{}` | `*…*` / `_…_` |
| `\label` / `\ref` / `\cite` | `<key>` / `@key` (same syntax) |
| `itemize` / `enumerate` | `- ` / `+ ` |
| `description` | `/ Term: —` |
| `\includegraphics` | `#image(..)` |
| `tabular` | `#table(..)` / `#grid(..)` |
| `\usepackage{geometry}` | `#set page(..)` |
| `\newcommand` | `#let f(..) = ..` |
| `\renewcommand` | show rule |

Markdown traps: `**bold**` does **not** work (strong is single `*`); `#` heading
is `= `; `> quote` is `#quote[..]`; tables are the `table` function.
