return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function()
		require("luasnip").setup({
			history = true,
			delete_check_events = "InsertLeave",
		})
	end,
}
