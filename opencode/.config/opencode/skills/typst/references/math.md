# Typst math

enter math with `$…$`. Whitespace inside the dollars decides inline vs block:
`$x^2$` is inline; `$ x^2 $` (or newlines) is a display block.

## Mental model

- Numbers and symbols render as-is: `$1 2 3$`, `$+ - =$`.
- A run of letters is a single variable: `$abc$` is one identifier, not `a·b·c`.
  Undefined identifiers error (`unknown variable`). Use `$"some text"$` for
  words, or quote each: `$a b c$` for three variables.
- Call math functions without `#`: `$floor(x)$`, `$sqrt(2)$`, `$cases(..)$`.
- Greek letters are names: `$alpha beta Gamma$`; Hebrew `$aleph$`.
- Shorthands: `->`, `>=`, `<=`, `!=`, `=>`, `<-`, `...`, `dot`, `times`, `in`,
  `subset`, `union`, `oo`, `NN` (blackboard letters), etc.
- Modifiers via dots: `$arrow.r.long$`, `$phi.alt$`, `$gt.slant$`.
- Escape a delimiter/operator with `\`: `$\{ \} \/ \#$`.

## Constructs

| Feature | Syntax |
|---------|--------|
| Superscript / subscript | `$x^2$`, `$x_1$`; group with parens `$x_(a+b)$` |
| Fraction | `$1/(a+b)$` — `/` makes a fraction, honouring precedence |
| Fraction style | `$frac(1, 2, style: "horizontal")$` (`vertical`/`skewed`/`horizontal`) |
| Root | `$sqrt(x)$`, `$root(3, x)$` |
| Sum / integral | `$sum_(k=1)^n k$`, `$integral_0^1$` |
| Limits / under-over | `$lim_(x -> oo)$`, `$underbrace(x+y, "sum")$` |
| Vector / matrix | `$vec(1, 2, 3)$`, `$mat(1, 2; 3, 4)$` (`;` separates rows) |
| Cases | `$cases(1 "if" x > 0, 0 "else")$` |
| Binomial | `$binom(n, k)$` |
| Alignment | `$a &= b \ &= c$` — `&` is the alignment point, `\` a line break |
| Operators | `$a + b$`, `$a dot b$`, `$a times b$`, `$x in RR$` |
| Text inside math | `$f(x) "where" x > 0$` |
| Code inside math | `$#(1 + 2)$`, `$#text(fill: red, 3)$` |

## Delimiters and sizes

Parentheses, brackets and `|` scale automatically. Use `lr` for manual pairs and
`mid` for inner delimiters:

```typst
$ lr((a + b) / c) $
$ abs(x), norm(v), floor(x), ceil(x) $
$ a = b \ &=> c $        // alignment with =>
```

Big operators like `sum`, `product`, `integral` place limits above/below in
display mode and to the side inline, matching TeX conventions.

## Fonts, weights, spacing

```typst
#set math.equation(numbering: "(1)")     // number displayed equations
$ E = m c^2 $ <einstein>                 // label, reference with @einstein
#show math.equation: set text(weight: "regular")   // the "LaTeX look"
$ a b \, c \; d \ e $                    // thin / thick / forced space
$ a b quad c $                           // 1em space
```

- `#set page(...)` etc. still apply; math inherits text font and size.
- Unicode input is allowed directly: `$α + β$` renders like `$alpha + beta$`.
- `mono(..)` and `upright(..)` force font variants inside math.
- Unnumbered equations keep no counter; numbered ones participate in
  `#counter(math.equation)`.
