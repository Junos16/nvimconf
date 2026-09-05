# ⌨️ Neovim Keymaps

This document tracks all custom and plugin-specific keymaps in this configuration.
The leader key is set to `Space`.

## 🛠️ General & Navigation
| Key | Mode | Description |
| :--- | :---: | :--- |
<!-- | `<leader>e` | `N` | Open Oil file explorer in current buffer | -->
<!-- | `<leader>ta` | `N` | Toggle Copilot AI completion | -->
| `<C-h/j/k/l>` | `I` | Move cursor in insert mode (Left/Down/Up/Right) |
| `<C-a>` | `I` | Move cursor to beginning of line |
| `<C-e>` | `I` | Move cursor to end of line |
| `<C-BS>` | `I` | Delete word behind cursor |
| `<C-Del>` | `I` | Delete word after cursor |

## 🔍 Fuzzy Finding (fzf-lua)
| Key | Mode | Description |
| :--- | :---: | :--- |
| `<leader>ff` | `N` | Find files in project |
| `<leader>fg` | `N` | Live grep (search text across files) |
| `<leader>fb` | `N` | List and switch between open buffers |
| `<leader>fh` | `N` | Search help tags |
| `<leader>fs` | `N` | Git status picker |
| `<leader>fc` | `N` | Git commit history picker |

## 💻 LSP (Language Server Protocol)
*These activate only when an LSP is attached to the buffer.*

| Key | Mode | Description |
| :--- | :---: | :--- |
| `K` | `N` | Show documentation/hover information |
| `gd` | `N` | Go to definition |
| `gr` | `N` | List references |
| `gi` | `N` | Go to implementation |
| `<leader>ca` | `N` | Open code actions |
| `<leader>rn` | `N` | Rename symbol (across files) |
| `<leader>d` | `N` | Show diagnostic/error in floating window |

## 📓 Jupyter & Notebooks (Molten + Jupytext)
| Key | Mode | Description |
| :--- | :---: | :--- |
| `<leader>mi` | `N` | Initialize Molten (Choose Kernel) |
| `<leader>mx` | `N` | **Execute current cell** (Smart cell detection) |
| `<leader>mr` | `N` | Run operator (e.g., `mr ip` for paragraph) |
| `<leader>rl` | `N` | Run current line |
| `<leader>rv` | `V` | Run visual selection |
| `]c` | `N` | Jump to next cell boundary (`# %%`) |
| `[c` | `N` | Jump to previous cell boundary (`# %%`) |
| `<leader>os` | `N` | Show output window |
| `<leader>oh` | `N` | Hide output window |
| `<leader>oe` | `N` | Enter output window (to scroll/copy) |
| `<leader>rd` | `N` | Delete cell output |
| `<leader>oa` | `N` | Activate Otter LSP (Completion in cells) |

## 📝 Markdown & Notetaking
| Key | Mode | Description |
| :--- | :---: | :--- |
| `<leader>ml` | `N/V` | Paste URL from clipboard as Markdown Link |
| `<leader>zn` | `N` | Create a new Zk note |
| `<leader>zn` | `V` | Create a new Zk note from selected text |
| `<leader>zf` | `N` | Find Zk notes |
| `<leader>zt` | `N` | Search Zk tags |
| `<leader>zi` | `N` | Insert internal link to a note |
| `<leader>zb` | `N` | Search backlinks for current note |

## 📄 LaTeX (VimTeX)
*Uses `<localleader>` which is also set to `Space`.*

| Key | Mode | Description |
| :--- | :---: | :--- |
| `<leader>ll` | `N` | Toggle continuous compilation (latexmk) |
| `<leader>lv` | `N` | View PDF in Zathura (Forward search) |
| `<leader>le` | `N` | Toggle error list (Quickfix) |
| `<leader>lt` | `N` | Toggle Table of Contents sidebar |
| `<leader>li` | `N` | Show VimTeX project information |

## 📁 File Explorer (Oil.nvim)
*Active while inside an Oil buffer.*

| Key | Mode | Description |
| :--- | :---: | :--- |
| `Enter` | `N` | Open file or directory |
| `-` | `N` | Go to parent directory |
| `<C-s>` | `N` | Open in horizontal split |
| `<C-v>` | `N` | Open in vertical split |
| `g.` | `N` | Toggle hidden files |
| `g?` | `N` | Show help |
