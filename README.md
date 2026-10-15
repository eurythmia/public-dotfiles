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

## Install

```
git clone --recurse-submodules https://github.com/eurythmia/public-dotfiles.git ~/dotfiles
cd ~/dotfiles
make                                 # stow everything into $HOME
```

If git or github.com is unavailable, download the repo's ZIP from the web UI,
unzip it, and run `make` (the four vim plugin submodules will be empty; vim
still runs without them).

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
