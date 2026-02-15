local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Core & Theme
	require("plugins.tokyonight"),
	require("plugins.transparent"),
	require("plugins.whichkey"),

	-- UI Refinements
	require("plugins.lualine"),
	require("plugins.bufferline"),
	require("plugins.indent-blankline"),
	require("plugins.illuminate"),
	require("plugins.colorizer"),

	-- Navigation & Utilities
	require("plugins.oil"),
	require("plugins.fzf"),
	require("plugins.telescope"),
	require("plugins.autopairs"),
	require("plugins.surround"),
	require("plugins.comment"),

	-- Git
	require("plugins.gitsigns"),
	require("plugins.lazygit"),
	require("plugins.gitlab"),

	-- Coding & LSP
	require("plugins.treesitter"),
	require("plugins.cmp"),
	require("plugins.luasnip"),
	require("plugins.mason"),
	require("plugins.mason-lspconfig"),
	require("plugins.lspconfig"),
	require("plugins.conform"),
	require("plugins.lint"),
	require("plugins.copilot"),

	-- Language Specific
	require("plugins.zk"),
	require("plugins.haskell_tools"),
	require("plugins.rustacean"),
	require("plugins.render-markdown"),
	require("plugins.vimtex"),
	require("plugins.typst-preview"),
	require("plugins.rest"),

	install = {
		colorscheme = { "tokyonight" },
	},
	checker = {
		enabled = true,
	},
})
