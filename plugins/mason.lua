return {
	"williamboman/mason.nvim",
	config = function()
		require("mason").setup({
			ensure_installed = {
				-- Systems Programming
				"clangd", -- C/C++ LSP
				"clang-format", -- C/C++ Formatter
				"cpplint", -- C/C++ Linter
				"codelldb", -- Debugger
				"cmake-language-server",
				"cmakelang", -- CMake Formatter
				"cmakelint", -- CMake Linter
				"zls", -- Zig LSP
				"asm-lsp", -- Assembly LSP
				-- "nixd", -- Nix LSP
				"statix", -- Nix Linter

				-- Web Technologies
				"typescript-language-server",
				"html-lsp",
				"css-lsp",
				"htmx-lsp",
				"eslint-lsp",
				"prettier", -- Formatter for many web languages
				"deno",
				"htmlhint", -- HTML Linter
				"stylelint", -- CSS/SCSS Linter

				-- Data Formats
				"json-lsp",
				"jsonlint", -- JSON Linter
				"yaml-language-server",
				"yamllint", -- YAML Linter
				"taplo", -- TOML Toolkit
				"dhall-lsp",

				-- Scripting
				"lua-language-server",
				"stylua", -- Lua Formatter
				"luacheck", -- Lua Linter
				"bash-language-server",
				"shellcheck", -- Shell script linter
				"beautysh", -- Shell script formatter
				"vim-language-server",
				"vint", -- Vimscript Linter

				-- Enterprise Languages
				"gopls",
				"gofumpt",
				"goimports",
				"golangci-lint",
				"jdtls", -- Java LSP
				"google-java-format", -- Java Formatter
				"checkstyle", -- Java Linter
				"pyright", -- Python LSP
				"black", -- Python Formatter
				"ruff", -- Python Linter/Formatter
				"mypy", -- Python Type Checker
				"csharp-language-server",
				"csharpier", -- C# Formatter

				-- Functional Programming
				-- "ocaml-lsp",
				-- "ocamlformat", -- OCaml Formatter
				"purescript-language-server",
				"hlint", -- Haskell Linter

				-- Document Processing
				-- "typst-lsp",
				"tinymist",
				"marksman", -- Markdown LSP
				"markdownlint", -- Markdown Linter
				"alex", -- Markdown prose linter
				"ltex-ls", -- Grammar/spelling LSP
				"texlab", -- LaTeX LSP
				"chktex", -- LaTeX Linter
				"latexindent", -- LaTeX Formatter

				-- DevOps & Git
				"dockerfile-language-server",
				"hadolint", -- Dockerfile Linter
				"gitlint", -- Git commit message linter
				"checkmake", -- Makefile Linter
			},
		})
	end,
}
