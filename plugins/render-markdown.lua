return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
	ft = { "markdown" },
	opts = {
		heading = {
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
		},
		checkbox = {
			enabled = true,
		},
		code = {
			sign = false,
			width = "block",
			right_pad = 1,
		},
	},
}
