return {
	"numToStr/Comment.nvim",
	opts = {},
	config = function()
		require("Comment").setup({})
	end,
	keys = {
		{
			"<leader>/",
			function()
				require("Comment.api").toggle.linewise.current()
			end,
			mode = "n",
			desc = "Toggle comment",
		},
		{
			"<leader>/",
			"<Plug>(comment_toggle_linewise_visual)",
			mode = "v",
			desc = "Toggle comment in visual mode",
		},
	},
}
