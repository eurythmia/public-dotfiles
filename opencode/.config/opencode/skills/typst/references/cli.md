# Typst CLI

Single binary, no root needed. Install the official prebuilt into a directory on
`PATH` (e.g. `~/.local/bin/typst`), or run `cargo install --locked typst-cli`.

## Install / update

```bash
mkdir -p ~/.local/bin
curl -sL https://github.com/typst/typst/releases/latest/download/typst-x86_64-unknown-linux-musl.tar.xz \
  | tar -xJ -C /tmp
install /tmp/typst-x86_64-unknown-linux-musl/typst ~/.local/bin/typst
rm -rf /tmp/typst-x86_64-unknown-linux-musl
typst update            # self-update in place; --revert undoes the last update
```

`typst update --force` allows a downgrade. `typst update <version>` pins a
version.

## Commands

| Command | Purpose |
|---------|---------|
| `typst compile <in> [out]` | Compile to PDF/PNG/SVG/HTML/bundle (alias `c`) |
| `typst watch <in> [out]` | Compile, then recompile on changes (alias `w`) |
| `typst init <template> [dir]` | Scaffold a project from a template |
| `typst eval '<expr>'` | Evaluate Typst code, optionally in a document |
| `typst query <in> <selector>` | Deprecated — prefer `eval` |
| `typst fonts` | List discovered system and custom fonts |
| `typst info` | Debug info (version, paths, package dirs) |
| `typst completions <shell>` | Generate shell completions |
| `typst update` | Self-update |

## compile / watch

```bash
typst compile doc.typ                       # -> doc.pdf
typst compile doc.typ out.pdf               # explicit output
typst compile - out.pdf < doc.typ           # stdin -> file
typst compile doc.typ - > doc.pdf           # file -> stdout
typst compile -f png doc.typ 'p-{0p}.png'   # force format
typst watch doc.typ                         # increments on save
```

Output format is inferred from the extension; override with `-f/--format`
(`pdf`, `png`, `svg`, `html`, `bundle`). For multi-page PNG/SVG output a page
template is required: `{p}` page number, `{0p}` zero-padded, `{t}` page count,
e.g. `'page-{0p}-of-{t}.png'`.

Key options (most apply to `compile` and `watch`):

| Option | Effect |
|--------|--------|
| `--diagnostic-format short` | One-line diagnostics (use when scripting/agent) |
| `--pages 2,5,7-9,11-` | Export a page subset (one-indexed physical pages) |
| `--font-path DIR` | Add font directories (recursive; `:`-separated) |
| `--ignore-system-fonts` | Only use `--font-path` and embedded fonts |
| `--root DIR` | Project root for absolute paths |
| `--input k=v` | Expose values via `sys.inputs` |
| `--ppi N` | PNG resolution (default 144) |
| `--pdf-standard a-2b,ua-1` | Enforce PDF/A, PDF/UA, PDF 1.4–2.0 |
| `--no-pdf-tags` | Disable tagged PDF (smaller output) |
| `--pretty` | Pretty-print HTML/SVG/PDF (larger) |
| `--deps out.json` | Write the dependency list (`json`, `zero`, `make`) |
| `-j N` | Parallel jobs; `1` disables parallelism |
| `--features name` | Enable in-development features (`html`, `bundle`, `a11y-extras`) |
| `--open [viewer]` | Open the result; ignored when writing to stdout |
| `--creation-timestamp N` | Reproducible builds (`SOURCE_DATE_EPOCH`) |
| `--timings out.json` | Perfetto-loadable timing profile (experimental) |

`watch` adds `--no-serve` (no HTML dev server), `--no-reload` (no live-reload
script), and `--port` (defaults to first free port in 3000–3005).

## eval (introspection)

Evaluate code, optionally against a document, then serialize as JSON/YAML.

```bash
typst eval '1 + 2'                                  # -> 3
typst eval --in doc.typ 'query(heading).map(h => h.body)' --pretty
typst eval --in doc.typ 'query(<intro>).first()'
typst eval --in doc.typ 'query(heading).len()'
```

`eval` yields `{"func":"context"}` for `context` expressions and errors with
`can only be used when context is known` for bare introspection; prefer
`query(..)`, which resolves without `context`.

Useful to inspect structure (headings, labels, counters, metadata) without
opening the PDF. `--one`, `--field`, `--format`, `--pretty` shape the output;
`query` is deprecated in favour of `eval`.

## fonts

```bash
typst fonts                     # all discovered families
typst fonts --variants          # include style variants
typst fonts --font-path ./fonts           # add a directory
typst fonts --ignore-system-fonts --font-path ./fonts
```

Unknown fonts are a **warning**, not an error — Typst silently falls back. If
text looks wrong, check `typst fonts` first. Set `TYPST_FONT_PATHS` to add paths
globally.

## Environment variables

| Variable | Meaning |
|----------|---------|
| `TYPST_ROOT` | Project root for absolute paths |
| `TYPST_FONT_PATHS` | Extra font directories (`:`-separated) |
| `TYPST_IGNORE_SYSTEM_FONTS` | Skip system fonts |
| `TYPST_IGNORE_EMBEDDED_FONTS` | Skip built-in fonts |
| `TYPST_PACKAGE_PATH` | Local package directory |
| `TYPST_PACKAGE_CACHE_PATH` | Package cache directory |
| `TYPST_FEATURES` | In-development features |
| `SOURCE_DATE_EPOCH` | Creation timestamp for reproducible builds |
| `TYPST_UPDATE_BACKUP_PATH` | Backup file for `typst update --revert` |

## Templates

```bash
typst init @preview/charged-ieee mypaper      # latest version
typst init @preview/charged-ieee:0.1.0 mypaper
typst init @preview/modern-cv mycv
```

Browse templates at https://typst.app/universe. `@preview` packages download on
first use and are cached; then `import` them from the generated file.
