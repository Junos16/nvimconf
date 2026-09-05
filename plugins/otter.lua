return {
	"jmbuhr/otter.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {},
	config = function(_, opts)
		local otter = require("otter")
		otter.setup(opts)

		-- Function to activate otter in markdown and python notebooks
		local function activate_otter()
			otter.activate({ "python", "lua" }, true, true, nil)
		end

		-- Autocmd to activate when entering markdown files
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
			pattern = { "*.md", "*.ipynb", "*.qmd" },
			callback = activate_otter,
		})

		-- Manual keymap
		vim.keymap.set("n", "<leader>oa", activate_otter, { desc = "Activate Otter LSP" })
	end,
}
