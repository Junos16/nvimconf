return {
	"mfussenegger/nvim-lint",
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			-- Systems Programming
			c = { "cpplint" },
			cpp = { "cpplint" },
			cmake = { "cmakelint" },
			nix = { "statix" },

			-- Web Technologies
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			html = { "htmlhint" },
			css = { "stylelint" },
			scss = { "stylelint" },
			dart = { "dartanalyzer" },

			-- Data Formats
			json = { "jsonlint" },
			yaml = { "yamllint" },

			-- Scripting
			lua = { "luacheck" },
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			zsh = { "shellcheck" },
			vim = { "vint" },

			-- Enterprise Languages
			go = { "golangcilint" },
			java = { "checkstyle" },
			python = { "ruff", "mypy" },

			-- Functional Programming
			haskell = { "hlint" },

			-- Document Processing
			-- markdown = { "markdownlint", "alex" },
			tex = { "chktex" },

			-- Build files
			dockerfile = { "hadolint" },
			make = { "checkmake" },
			gitcommit = { "gitlint" },
		}

		-- Auto-lint on save and buffer enter
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
