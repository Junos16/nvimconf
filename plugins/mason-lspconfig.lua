return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local mason_lspconfig = require("mason-lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- 1. SETUP MASON-LSPCONFIG
		mason_lspconfig.setup({
			ensure_installed = {
				-- Systems
				"clangd",
				"cmake",
				"zls",
				"asm_lsp",
				-- Web
				"ts_ls",
				"html",
				"cssls",
				"htmx",
				"eslint",
				"denols",
				-- Data / Scripts
				"jsonls",
				"yamlls",
				"taplo",
				"lua_ls",
				"bashls",
				"vimls",
				-- Enterprise
				"gopls",
				"jdtls",
				"pyright",
				"csharp_ls",
				-- Docs
				"tinymist",
				"texlab",
				"marksman",
				"ltex",
				"dockerls",
			},
			-- Automatically enable servers (Neovim 0.11+ feature)
			automatic_enable = true,
		})

		-- 2. GLOBAL DEFAULT CONFIG
		-- Apply capabilities to all servers by default
		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		-- 3. CUSTOM OVERRIDES
		-- These will be merged with the defaults and what mason-lspconfig provides
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					workspace = { library = vim.api.nvim_get_runtime_file("", true) },
					telemetry = { enable = false },
				},
			},
		})

		vim.lsp.config("gopls", {
			settings = {
				gopls = {
					analyses = { unusedparams = true },
					staticcheck = true,
				},
			},
		})

		vim.lsp.config("pyright", {
			settings = {
				python = {
					analysis = { typeCheckingMode = "basic" },
				},
			},
		})

		vim.lsp.config("clangd", {
			cmd = { "clangd", "--background-index", "--clang-tidy" },
		})

		vim.lsp.config("ts_ls", {
			single_file_support = false,
			root_markers = { "package.json" },
		})

		vim.lsp.config("denols", {
			root_markers = { "deno.json", "deno.jsonc" },
		})

		-- 4. EXPLICITLY DISABLE (Handled by other plugins)
		-- Setting enable = false prevents mason-lspconfig from auto-enabling them
		vim.lsp.enable("rust_analyzer", false)
		vim.lsp.enable("hls", false)
	end,
}
