return {
	"RRethy/vim-illuminate",
	event = "BufReadPost",
	config = function()
		require("illuminate").configure({
			delay = 200,
			large_file_cutoff = 2000,
		})
	end,
}
