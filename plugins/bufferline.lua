return {
	"akinsho/bufferline.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"xiyaowong/transparent.nvim",
	},
	opts = {
		options = {
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					text_align = "left",
					separator = true,
				},
			},
			always_show_bufferline = true,
		},
	},
	config = function(_, opts)
		require("bufferline").setup(opts)

		-- Buffer navigation
		vim.keymap.set("n", "<C-Tab>", "<Cmd>BufferLineCycleNext<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<C-S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { noremap = true, silent = true })

		-- Go to buffer by number
		for i = 1, 9 do
			vim.keymap.set(
				"n",
				"<leader>" .. i,
				"<Cmd>BufferLineGoToBuffer " .. i .. "<CR>",
				{ noremap = true, silent = true }
			)
		end

		-- Close buffers
		vim.keymap.set("n", "<leader>c", "<Cmd>bdelete<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>C", "<Cmd>%bdelete|edit#|bdelete#<CR>", { noremap = true, silent = true })
	end,
	lazy = false,
}
