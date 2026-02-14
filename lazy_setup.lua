local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require("lazy").setup({
	require("plugins.tokyonight"),
	require("plugins.whichkey"),
	require("plugins.lualine"),
	require("plugins.bufferline"),
	require("plugins.oil"),
	require("plugins.treesitter"),
	require("plugins.telescope"),
	require("plugins.fzf"),
	require("plugins.comment"),
	require("plugins.cmp"),
	require("plugins.mason"),
	require("plugins.mason-lspconfig"),
	require("plugins.lspconfig"),
	require("plugins.conform"),
	require("plugins.lint"),
	require("plugins.transparent"),
	require("plugins.gitlab"),
	require("plugins.zk"),
	require("plugins.haskell_tools"),
	require("plugins.copilot"),
	require("plugins.rustacean"),

	-- require('plugins.lazygit')
	install = {
		colorscheme = { "tokyonight" },
	},
	checker = {
		enabled = true,
	},
})
