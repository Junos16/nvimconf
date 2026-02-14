-- Leader Key
vim.g.mapleader = " "

-- AI
vim.g.ai_enabled = true

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Clipboard
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

-- Scrolling
vim.opt.scrolloff = 8 -- Keep 8 lines of context around the cursor

-- Indentation
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.breakindent = true

-- Cursor
vim.opt.cursorline = true -- Show line under cursor

-- Undo
vim.opt.undofile = true -- Store undos between sessions

-- Mouse
vim.opt.mouse = "a" -- Enable mouse mode

-- UI
vim.opt.showmode = false -- Don't show current mode
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Transparency
vim.cmd([[highlight SignColumn guibg=NONE]])

vim.opt.conceallevel = 2
vim.opt.wrap = true
vim.opt.linebreak = true
