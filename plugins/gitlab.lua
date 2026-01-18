return {
	"harrisoncramer/gitlab.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("gitlab").setup()
	end,
}
