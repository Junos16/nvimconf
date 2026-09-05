return {
	"frabjous/knap",

	config = function()
		vim.g.knap_settings = {
			mdoutputext = "pdf",

			mdtopdf = "pandoc %docroot% --pdf-engine=tectonic -o %outputfile%",

			mdtopdfviewerlaunch = "zathura %outputfile%",

			-- Zathura detects changes itself
			mdtopdfviewerrefresh = "none",

			delay = 300,
		}

		vim.keymap.set("n", "<leader>mp", function()
			require("knap").toggle_autopreviewing()
		end, { desc = "Markdown live preview" })
	end,
}
