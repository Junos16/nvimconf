return {
	"zbirenbaum/copilot-cmp",
	event = "InsertEnter",
	dependencies = {
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
				filetypes = {
					markdown = true,
					help = true,
				},
			})
		end,
	},
	config = function()
		require("copilot_cmp").setup()

		-- AI Toggle Function
		local function toggle_ai()
			if vim.g.ai_enabled then
				vim.g.ai_enabled = false
				vim.cmd("Copilot disable")
				print("🛑 AI Disabled")
			else
				vim.g.ai_enabled = true
				vim.cmd("Copilot enable")
				print("🟢 AI Enabled")
			end
		end

		vim.keymap.set("n", "<leader>ta", toggle_ai, { desc = "Toggle AI Completion" })
	end,
}
