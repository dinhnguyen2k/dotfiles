# 🌸 My Personal Dotfiles

Personal configurations, terminal setup, and scripts.

---

## ⚡ WezTerm Setup (Rose-Pine Moon Theme)

Modern, aesthetic, and ultra-responsive WezTerm setup featuring:
- **🎨 Theme**: Rose-Pine Moon (`rose-pine-moon`) with **Acrylic Backdrop** & Gaussian blur background.
- **✨ High Contrast Focus Spotlight**: Inactive panes fade into grayscale and dim down to 22% brightness.
- **🚀 Bottom Statusline**: Segmented pill/capsule design (Peach `#fab387`, Lavender `#b4befe`, Mint Green `#a6da95`, Pastel Yellow `#eed49f`).
- **📊 Real-time Stats**: CPU & RAM % displayed via zero-latency background watcher daemon.
- **⌨️ Leader Key**: `Ctrl + Space` (Press twice to passthrough `Ctrl + Space` to Neovim / Terminal for AutoComplete).
- **📋 Copy Mode**: Enter with `Ctrl + Shift + X` (or `Ctrl + Space` then `[`). Hold `Shift + Arrow keys` to highlight & select text naturally (like VS Code / Word). Press `Enter` to copy to clipboard & exit.
- **⚡ QuickSelect**: `Ctrl + Shift + Space` to copy any URL, IP, hash, or file path in 1 keystroke.

---

## 🚀 Quick Installation

### Windows (WezTerm GUI)
1. Copy `wezterm.lua` to your Windows user profile folder:
   ```powershell
   Copy-Item .\wezterm.lua "$HOME\.wezterm.lua"
   ```
2. Copy the background image to your Windows user profile folder:
   ```powershell
   Copy-Item .\assets\bg_nguyentd_blur.png "$HOME\bg_nguyentd_blur.png"
   ```
3. Restart WezTerm or press `Ctrl + Shift + R` to reload.

### Linux / WSL (Ubuntu)
1. Copy configuration to `~/.config/wezterm/`:
   ```bash
   mkdir -p ~/.config/wezterm
   cp wezterm.lua ~/.config/wezterm/wezterm.lua
   ```
2. (Optional) Run the CPU/RAM watcher daemon in the background:
   ```bash
   python3 scripts/sys_watcher.py --daemon
   ```
   Add to `~/.zshrc` or `~/.bashrc` to autostart:
   ```bash
   pgrep -f "sys_watcher.py --daemon" >/dev/null || (python3 ~/dotfiles/scripts/sys_watcher.py --daemon)
   ```

---

## ⌨️ Shortcuts Reference

| Shortcut | Description |
|---|---|
| `Ctrl + Shift + R` | Reload WezTerm configuration |
| `Ctrl + Space` then `c` | Create new tab |
| `Ctrl + Space` then `x` | Close current pane |
| `Ctrl + Space` then `v` | Split horizontal |
| `Ctrl + Space` then `s` | Split vertical |
| `Ctrl + Space` then `z` | Zoom / Unzoom pane |
| `Ctrl + Space` then `h, j, k, l` | Navigate smoothly between panes |
| `Ctrl + Space` then `t` | Open `top` in vertical split |
| `Ctrl + Space` (twice) | Send `Ctrl + Space` to Neovim / Shell |
| `Ctrl + Shift + X` | Enter Copy Mode |
| `Shift + Arrow Keys` (in Copy Mode) | Highlight & select text |
| `Enter` (in Copy Mode) | Copy selection to Clipboard & Exit |
| `Ctrl + Shift + Space` | QuickSelect URLs, paths, commit hashes |

---

## 🌙 Neovim Setup (Rose-Pine Moon + Lazy.nvim)

Modern, lightning-fast Neovim configuration seamlessly paired with Rose-Pine Moon theme:

- **🎨 Theme**: Rose-Pine Moon (`rose-pine/neovim`) with 24-bit TrueColor.
- **🚀 Plugin Manager**: `lazy.nvim` with locked reproducible states (`lazy-lock.json`).
- **🔍 FZF-Lua**: High-performance fuzzy finder for files & code grep (synced with terminal `fn`).
- **🌲 Neo-tree**: Sleek sidebar file explorer (`Space + e` to toggle).
- **📝 Render Markdown**: Inline rich markdown preview with custom headings, code blocks, tables, and checkboxes.
- **🌠 Smear Cursor**: Smooth animated morphing cursor trail (`sphamba/smear-cursor.nvim`).
- **🐧 Penguin Pet**: Floating companion widget stepping across the status bar (`:Pet` or `Space + pp`).
- **⌨️ Leader Key**: `Space` (Space + `f` for find, `e` for tree, `w` for save, `m` for markdown).

### Neovim Installation
Symlink or copy `nvim/` to `~/.config/nvim`:
```bash
ln -s ~/dotfiles/nvim ~/.config/nvim
```

### Key Neovim Shortcuts

| Shortcut | Description |
|---|---|
| `<leader>ff` | Find files (FZF-Lua) |
| `<leader>fg` / `<leader>fG` | Live Grep text in codebase |
| `<leader>fb` | Open buffers list |
| `<leader>e` | Toggle Neo-tree sidebar |
| `<leader>m` | Toggle Markdown render |
| `<leader>sc` | Toggle Smear cursor animation |
| `<leader>pp` | Toggle Penguin Pet widget |
| `<leader>w` / `<leader>q` | Quick save / Quick quit |
| `<leader>n` or `F2` | Toggle line numbers |

