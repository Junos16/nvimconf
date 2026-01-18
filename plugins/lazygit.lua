return {
	"kdheepak/lazygit.nvim",
	cmd = "LazyGit",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })
	end,
}
