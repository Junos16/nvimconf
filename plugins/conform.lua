-- conform.lua

return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			-- Systems Programming
			c = { "clang_format" },
			cpp = { "clang_format" },
			cmake = { "cmake_format" },
			zig = { "zig fmt" },
			rust = { "rustfmt" },

			-- Web Technologies
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			less = { "prettier" },
			dart = { "dart_format" },

			-- Data Formats
			json = { "prettier" },
			jsonc = { "prettier" },
			yaml = { "prettier" },
			toml = { "taplo" },

			-- Scripting
			lua = { "stylua" },
			sh = { "beautysh" },
			bash = { "beautysh" },
			zsh = { "beautysh" },

			-- Enterprise Languages
			go = { "goimports", "gofumpt" },
			java = { "google-java-format" },
			python = { "black" },
			cs = { "csharpier" },

			-- Functional Programming
			ocaml = { "ocamlformat" },
			haskell = { "fourmolu" },

			-- Document Processing
			markdown = { "prettier" },
			tex = { "latexindent" },
			typst = { "typstfmt" },

			-- Build files
			dockerfile = { "prettier" },
		},

		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
}
