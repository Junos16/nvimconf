return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- 1. LSP Keymaps (Buffer-local)
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover", buffer = ev.buf })
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP Definition", buffer = ev.buf })
				vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "LSP References", buffer = ev.buf })
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "LSP Implementation", buffer = ev.buf })
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action", buffer = ev.buf })
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename", buffer = ev.buf })
				vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line Diagnostics", buffer = ev.buf })
			end,
		})

		-- 2. Mason-LSPConfig Setup Handlers
		mason_lspconfig.setup_handlers({
			-- Default handler
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,

			-- Specific overrides
			["lua_ls"] = function()
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim" } },
							workspace = { library = vim.api.nvim_get_runtime_file("", true) },
							telemetry = { enable = false },
						},
					},
				})
			end,

			["gopls"] = function()
				lspconfig.gopls.setup({
					capabilities = capabilities,
					settings = {
						gopls = {
							analyses = { unusedparams = true },
							staticcheck = true,
						},
					},
				})
			end,

			["pyright"] = function()
				lspconfig.pyright.setup({
					capabilities = capabilities,
					settings = {
						python = {
							analysis = { typeCheckingMode = "basic" },
						},
					},
				})
			end,

			["clangd"] = function()
				lspconfig.clangd.setup({
					capabilities = capabilities,
					cmd = { "clangd", "--background-index", "--clang-tidy" },
				})
			end,

			["ts_ls"] = function()
				lspconfig.ts_ls.setup({
					capabilities = capabilities,
					single_file_support = false,
					root_dir = lspconfig.util.root_pattern("package.json"),
				})
			end,

			["denols"] = function()
				lspconfig.denols.setup({
					capabilities = capabilities,
					root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
				})
			end,

			-- Handled by specialized plugins
			["rust_analyzer"] = function() end,
			["hls"] = function() end,
		})

		-- 3. Manual setup for non-Mason servers

		-- Dart_Ls
		if vim.fn.executable("dartls") == 1 then
			lspconfig.dartls.setup({
				cmd = { "dart", "language-server", "--protocol=lsp" },
				capabilities = capabilities,
				init_options = {
					onlyAnalyzeProjectsWithOpenFiles = true,
					suggestFromUnimportedLibraries = true,
					closingLabels = true,
					outline = true,
					flutterOutline = true,
				},
				settings = {
					dart = {
						completeFunctionCalls = true,
						showTodos = true,
					},
				},
			})
		end

		-- Ocaml
		if vim.fn.executable("ocamllsp") == 1 then
			lspconfig.ocamllsp.setup({
				capabilities = capabilities,
			})
		end
	end,
}
