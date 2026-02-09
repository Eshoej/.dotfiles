# CLAUDE.md

This is a personal dotfiles repository. Files are deployed to `$HOME` preserving their relative paths (no symlink manager).

## Structure

```
.zshrc                          # Shell config (oh-my-zsh, mise, tmux auto-attach)
.tmux.conf                      # Tmux config (prefix C-a, vi mode)
.config/nvim/                   # Neovim config (lazy.nvim, rose-pine)
.config/tmux-sessionizer/       # Config for tmux-sessionizer script
.local/bin/tmux-sessionizer     # Project session switcher (fzf + tmux)
```

## Neovim

- Entry: `init.lua` → `lua/eshoej/init.lua` → loads `remap`, `set`, `lazy`
- Plugin manager: lazy.nvim with silent daily auto-update on VimEnter
- Plugin specs are declared in `lua/eshoej/lazy.lua`; plugin **configs** live in `after/plugin/*.lua`
- Leader: Space. Module namespace: `eshoej`
- 4-space tabs (expandtab), relative line numbers, colorcolumn at 80
- Colorscheme: rose-pine with transparent background (`after/plugin/colors.lua`)
- LSP via lsp-zero v4 + mason + mason-lspconfig; formatting via conform.nvim
- Key plugins: telescope, harpoon2, treesitter, fugitive, snacks, copilot, lualine

## Tmux

- Prefix: `C-a` (not default `C-b`)
- Vi copy-mode with `v` to select, `y` to yank (xclip)
- Vim-style pane switching: `hjkl`
- `<prefix>f` / `<prefix>C-f`: launch tmux-sessionizer
- `<prefix>L`: switch to last session
- Base index 1

## tmux-sessionizer

Custom bash script (`.local/bin/tmux-sessionizer`) that uses fzf to pick a project directory and creates/switches to a named tmux session for it. Configured via `.config/tmux-sessionizer/tmux-sessionizer.conf` (sets `TS_EXTRA_SEARCH_PATHS`). Requires `fzf` and `tmux`.

## Shell

- oh-my-zsh with robbyrussell theme, git plugin
- `mise activate bash` for tool version management
- Auto-attaches to tmux session "main" when not already inside tmux
- `vim` aliased to `nvim`
- `~/.local/bin` on PATH
