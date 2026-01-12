return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = { "mason.nvim" },
	config = function()
		require("mason-lspconfig").setup({
			ensure_installed = {
				-- Systems Programming
				"clangd",
				"cmake",
				"zls",
				"asm_lsp",
				-- "nixd",

				-- Web Technologies
				"ts_ls",
				"html",
				"cssls",
				"htmx",
				"eslint",
				"denols",

				-- Data Formats
				"jsonls",
				"yamlls",
				"taplo",
				"dhall_lsp_server",

				-- Scripting
				"lua_ls",
				-- "luacheck",
				"vimls",
				"bashls",

				-- Enterprise Languages
				"gopls",
				"jdtls",
				"pyright",
				"csharp_ls",

				-- Functional Programming
				"purescriptls",

				-- Document Processing
				"tinymist",
				"texlab",
				"marksman",
				"ltex",

				-- DevOps
				"dockerls",
			},
		})
	end,
}
