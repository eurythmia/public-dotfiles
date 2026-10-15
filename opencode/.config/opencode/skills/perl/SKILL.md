---
name: perl
description: Perl conventions — Class::Tiny + Role::Tiny (or Moo) OO, early-return, 4-space indent, POD at end, say over print, and preferred CPAN modules. Applies to domain/standalone code; defer to the framework (e.g. Mojolicious) at the app layer. Use whenever writing or reviewing Perl.
---

# Perl Development Instructions

## Context
- You are an experienced Perl Developer creating modern, easy-to-maintain OO code using the Preferred CPAN Modules listed below.
- This skill governs **domain / standalone Perl** (scripts, libraries, CLIs, parsers, value objects). In a framework project the framework's own conventions win at the framework layer — see **Framework precedence** below.

## Preferred CPAN Modules
- [Class::Tiny](https://metacpan.org/pod/Class::Tiny) - default lightweight OO
- [Moo](https://metacpan.org/pod/Moo) - when Class::Tiny isn't enough (lazy builders, method modifiers, coercion via `MooX::TypeTiny`); prefer over Moose for startup cost
- [Role::Tiny](https://metacpan.org/pod/Role::Tiny) - roles for Class::Tiny (`Moo::Role` when using Moo)
- [Path::Tiny](https://metacpan.org/pod/Path::Tiny) - file path manipulation and file I/O
- [Type::Tiny](https://metacpan.org/pod/Type::Tiny) - validation and type constraints (`Types::Standard`)
- [Capture::Tiny](https://metacpan.org/pod/Capture::Tiny) - capture STDOUT/STDERR from external processes
- [IPC::Run](https://metacpan.org/pod/IPC::Run) - run and inspect external processes (prefer over `Proc::Background`, which is stale)
- [Getopt::Long::Descriptive](https://metacpan.org/pod/Getopt::Long::Descriptive) - CLI parsing (prefer; `Getopt::Lucid` only if already vested)
- [JSON::MaybeXS](https://metacpan.org/pod/JSON::MaybeXS) - JSON (`Mojo::JSON` inside Mojolicious)
- [Try::Tiny](https://metacpan.org/pod/Try::Tiny) - try/catch (or [Syntax::Keyword::Try](https://metacpan.org/pod/Syntax::Keyword::Try))
- [YAML::PP](https://metacpan.org/pod/YAML::PP) - configuration. Pick **one** config format; do not add both YAML and INI
- [Modern::Perl '2022'](https://metacpan.org/pod/Modern::Perl) - modern Perl features
- [Test2::V0](https://metacpan.org/pod/Test2::V0) - modern testing

**Templating** — `Template::Tiny` is only for trivial one-file string
substitution (no layouts, no `INCLUDE`/`PROCESS`, no partials). Use
[Template::Toolkit](https://metacpan.org/pod/Template) (`Template`) or
`Template::Mustache` for standalone work, and **Mojolicious `.ep` templates**
inside a Mojo app.

## Framework precedence

The modules above are for domain/standalone code. When a project uses a
framework, its idioms win *at the framework layer*; this skill governs the
domain layer and general style.

**Mojolicious**:
- Plugins/controllers: `Mojo::Base 'Mojolicious::Plugin'` — never `Class::Tiny` for Mojo components
- Templates: `.html.ep` with layouts + partials — never `Template::Tiny`
- Config: `plugin 'Config'` + `app.conf` — not YAML/INI
- Models/data: `Mojo::SQLite` (migrations in `schema.sql`) and other framework modules
- Domain objects the framework doesn't own (adapters, parsers, value objects): `Class::Tiny` + `Role::Tiny` per this skill
- Tests: `Test::Mojo` for HTTP; `Test2::V0` for pure-domain units (they compose)

## Error Handling & Output

**Unix Philosophy:** Silent on success, noisy on failure.

**Error Handling Guidelines:**
- Use `die "Error message\n"` for fatal errors that should stop execution
- Use `warn "Warning message\n"` for recoverable issues
- Use `say` for normal output (when verbose mode is enabled)
- Avoid logging frameworks for quick utilities - they add unnecessary complexity
- For long-running services/daemons use the framework's logger (`$app->log` in Mojolicious) or `Log::Log4perl` — not ad-hoc `warn`

**Verbose Mode Pattern:**
```perl
# Add verbose attribute to Class::Tiny
use Class::Tiny qw(verbose);

# Gate output with verbose flag
say "Starting operation..." if $self->verbose;
```

## Coding Style

**Directives:**
- Follow the early-return pattern (see Example 1)
- Avoid deep nesting of conditionals
- Prefer `for` over `foreach`
- Indent with 4 spaces
- Answer concisely unless I say "verbose"
- Prefer early return over nested if/else
- Prefer single-line statements for conditional blocks containing a single command (see Example 2)
- Prefer `say` over `print`
- Put POD at the end of the code, not interspersed throughout.

### Example 1: Early Return Pattern

```perl
# Do this
sub execute {
    my ($self, $action) = @_;

    return $self->greet() if $action eq 'greet';
    return $self->farewell() if $action eq 'farewell';

    die "Unknown action: $action";
}

# Not this
sub execute {
    my ($self, $action) = @_;
    if ($action eq 'greet') {
        return $self->greet();
    } elsif ($action eq 'farewell') {
        return $self->farewell();
    } else {
        die "Unknown action: $action";
    }
}
```

### Example 2: Single-Line Conditionals

```perl
my $number = 10;

# Do this:
say "The number is greater than 5." if $number > 5;

# Not this:
if ($number > 5) {
    say "The number is greater than 5.";
}
```
