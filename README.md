# public-dotfiles

A minimal, host-neutral subset of my dotfiles, safe to use on machines I do not
own. No personal paths, projects, identities, or secrets.

Managed with GNU Stow (one directory per package; paths mirror `$HOME`).

## Packages

| Package | Installs |
|---------|----------|
| `vim/`  | `~/.vimrc`, `~/.vim/` |
| `tcsh/` | `~/.tcshrc` |
| `tmux/` | `~/.tmux.conf` |
| `git/`  | `~/.gitconfig` (no `user.*`; includes `~/.gitconfig.local`) |
| `latex/`| `~/.latexmkrc` |
| `bin/`  | a few generic helper scripts in `~/bin` |

## Install from the bundle

```
git clone public-dotfiles.bundle ~/dotfiles
cd ~/dotfiles
git submodule update --init          # vim plugins (public repos, no credentials)
make                                 # stow everything into $HOME
```

`make` also creates `~/.vim_viewdir`, `~/.vim_swapfiles`, `~/.vim_backups`.
`make delete` removes the symlinks and those directories.

## Host / identity overrides

Nothing machine-specific lives here. Put it in:

- `~/.tcshrc_local` — personal env vars, aliases, `$path` additions. Sourced by
  `~/.tcshrc` if present.
- `~/.gitconfig.local` — your `[user]` identity. Included by `~/.gitconfig`.

```
git config --file ~/.gitconfig.local user.name  "Your Name"
git config --file ~/.gitconfig.local user.email you@work.example
```
