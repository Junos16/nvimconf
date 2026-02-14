return {
	"neovim/nvim-lspconfig",
	dependencies = { "mason-lspconfig.nvim" },
	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Auto-setup Mason-managed servers
		local servers = require("mason-lspconfig").get_installed_servers()
		for _, server_name in ipairs(servers) do
			lspconfig[server_name].setup({
				capabilities = capabilities,
			})
		end

		-- System-wide servers

		-- Dart_Ls
		if vim.fn.executable("dartls") == 1 then
			lspconfig.dartls.setup({
				cmd = { "dart", "language-server", "--protocol=lsp" },
				filetypes = { "dart" },
				root_markers = { "pubspec.yaml" },
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

		-- Rust Analyzer
		if vim.fn.executable("rust-analyzer") == 1 then
			lspconfig.rust_analyzer.setup({
				cmd = { "rust-analyzer" },
				filetypes = { "rust" },
				capabilities = capabilities,
				settings = {
					["rust-analyzer"] = {
						check = {
							command = "cargo clippy",
						},
					},
				},
			})
		end

		-- Haskell Language Server
		-- if vim.fn.executable("haskell-language-server-wrapper") == 1 then
		-- 	lspconfig.hls.setup({
		-- 		capabilities = capabilities,
		-- 		cmd = { "haskell-language-server-wrapper", "--lsp" },
		-- 		filetypes = { "haskell", "lhaskell", "cabal" },
		-- 		root_dir = lspconfig.util.root_pattern(
		-- 			"hie.yaml",
		-- 			"stack.yaml",
		-- 			"cabal.project",
		-- 			"*.cabal",
		-- 			"package.yaml"
		-- 		),
		-- 		settings = {
		-- 			haskell = {
		-- 				formattingProvider = "fourmolu",
		-- 				cabalFormattingProvider = "cabalfmt",
		-- 			},
		-- 		},
		-- 	})
		-- end
		--
		-- Ocaml Language Server
		if vim.fn.executable("ocaml-lsp-server") == 1 then
			lspconfig.ocamllsp.setup({
				cmd = { "ocamllsp" },
				filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
				root_dir = lspconfig.util.root_pattern(
					"*.opam",
					"esy.json",
					"package.json",
					".git",
					"dune-project",
					"dune-workspace"
				),
				-- on_attach = on_attach,
				capabilities = capabilities,
			})
		end

		-- Language-specific configurations
		lspconfig.clangd.setup({
			capabilities = capabilities,
			cmd = { "clangd", "--background-index", "--clang-tidy" },
			filetypes = { "c", "cpp", "objc", "objcpp" },
		})

		lspconfig.cmake.setup({
			capabilities = capabilities,
			filetypes = { "cmake" },
		})

		lspconfig.zls.setup({
			capabilities = capabilities,
			filetypes = { "zig" },
		})

		lspconfig.ts_ls.setup({
			capabilities = capabilities,
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		})

		lspconfig.denols.setup({
			capabilities = capabilities,
			root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
		})

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

		lspconfig.gopls.setup({
			capabilities = capabilities,
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
				},
			},
		})

		lspconfig.pyright.setup({
			capabilities = capabilities,
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "basic",
					},
				},
			},
		})

		-- Keymaps
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP Definition" })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "LSP References" })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "LSP Implementation" })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
		vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
	end,
}
