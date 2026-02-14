-- plugins/haskell_tools.lua
return {
	"mrcjkb/haskell-tools.nvim",
	version = "^6",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	-- 'init' runs before the plugin loads, preventing the "boolean index" crash
	init = function()
		vim.g.haskell_tools = {
			tools = {
				codeLens = {
					autoRefresh = true,
				},
				hoogle = {
					mode = "auto",
				},
				hover = {
					enable = true,
					stylize_markdown = true,
					auto_focus = false,
				},
			},
			hls = {
				auto_attach = true,
				on_attach = function(client, bufnr, ht)
					local opts = { noremap = true, silent = true, buffer = bufnr }

					-- Keybindings
					opts.desc = "Haskell: Toggle REPL"
					vim.keymap.set("n", "<leader>rr", ht.repl.toggle, opts)
					opts.desc = "Haskell: Toggle REPL (Project)"
					vim.keymap.set("n", "<leader>rf", function()
						ht.repl.toggle(vim.api.nvim_buf_get_name(0))
					end, opts)
					opts.desc = "Haskell: Quit REPL"
					vim.keymap.set("n", "<leader>rq", ht.repl.quit, opts)
					opts.desc = "Haskell: Hoogle Search"
					vim.keymap.set("n", "<leader>hs", ht.hoogle.hoogle_signature, opts)
					opts.desc = "Haskell: Run CodeLens"
					vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, opts)
				end,
			},
		}
	end,
}
