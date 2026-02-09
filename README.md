# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/)
- [Neovim](https://neovim.io/)
- [tmux](https://github.com/tmux/tmux)
- [fzf](https://github.com/junegunn/fzf)
- [oh-my-zsh](https://ohmyz.sh/)
- [mise](https://mise.jdx.dev/)
- [xclip](https://github.com/astrand/xclip) (for tmux yank)

## Install

```bash
git clone <repo-url> ~/.dotfiles
cd ~/.dotfiles
stow .
```

This symlinks everything into `$HOME`, preserving the directory structure.

## Uninstall

```bash
cd ~/.dotfiles
stow -D .
```
