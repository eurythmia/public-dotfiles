---
name: mdbook
description: This skill should be used when building, serving, or maintaining mdBook documentation books, especially via the `~/bin/mm` wrapper — adding pages to SUMMARY.md, fixing a stale sidebar/table of contents, or building and serving a book.
---

# mdBook workflow

Local wrapper: `~/bin/mm` (Perl; if editing it, follow the `perl` skill).
Books live in each repo's `docs/` (`book.toml`, `src = "./"`). Run `mm` and
`mdbook` from the directory containing `book.toml`.

## Commands

- `mm --init` (`-i`) — bootstrap a **new** book: writes `book.toml` if absent
  and generates `SUMMARY.md` from the existing `*.md`, renaming any existing
  `SUMMARY.md` to `.SUMMARY.md`. Intended for a new book; because it
  regenerates the TOC, do not use it to update an existing/curated book.
- `mm --serve` (`-s`) — `mdbook serve ./ --dest-dir ~/www/<dir> --open`, then
  rebuilds the sitemap.
- `mm --build` (`-b`) — build the site.
- `mm --clean` (`-c`) — delete the built site.
- `mm --sitemap` — rebuild the sitemap only.

## Where output goes

`mm` derives the destination as `~/www/<name>`: a book under `~/docs/<x>` →
`~/www/x`, otherwise the cwd basename (`~/dev/proj/docs` →
`~/www/docs`). It passes `--dest-dir`, overriding `book.toml`'s `build-dir`,
so the served site is **not** `target/book`. Check which path is actually
served before assuming a build "didn't work".

## Adding a page

1. Create `docs/<page>.md`.
2. Add `- [Title](page.md)` to `docs/SUMMARY.md` — SUMMARY **is** the TOC; the
   page will not appear without it.
3. Run `mdbook build` from the book directory to catch broken links.
4. The sidebar is an iframe (`toc.html`): if a new entry doesn't show, hard
   refresh (Ctrl+Shift+R) or restart `mm --serve`.

## Gotchas

- Preprocessors are per-book: e.g. `mdbook-mermaid` (`mermaid.min.js`
  + `mermaid-init.js` in `additional-js`); `mm`-generated `book.toml` uses
  `mdbook-toc`, which needs that binary installed.
- **ABC is not native.** To show/play ```` ```abc ```` blocks, add abcjs via
  `[output.html] additional-js` (client-side render + playback), or use a
  build-time preprocessor that emits SVG (same pattern as `mdbook-mermaid`).
- The usual cause of "missing from the TOC" is a page whose `.md` exists but
  has no SUMMARY entry; a new file with no SUMMARY change is the tell.
- `mm --init` regenerates the TOC; if a book is curated, edit SUMMARY.md by
  hand instead.
