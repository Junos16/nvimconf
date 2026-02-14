return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- 1. MANUAL SERVERS (Not in Mason)
		if vim.fn.executable("dart") == 1 then
			vim.lsp.config("dartls", {
				cmd = { "dart", "language-server", "--protocol=lsp" },
				capabilities = capabilities,
			})
			vim.lsp.enable("dartls")
		end

		if vim.fn.executable("ocamllsp") == 1 then
			vim.lsp.config("ocamllsp", {
				capabilities = capabilities,
			})
			vim.lsp.enable("ocamllsp")
		end

		-- 2. KEYMAPS
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
			end,
		})
	end,
}
