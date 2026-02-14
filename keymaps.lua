local map = vim.keymap.set

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

-- AI Toggle Keymap
map("n", "<leader>ta", toggle_ai, { desc = "Toggle AI Completion" })

-- Oil Keymaps
map("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open file explorer" })

-- Fuzzy Finding
map("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>", { desc = "Find help" })
map("n", "<leader>fs", "<cmd>FzfLua git_status<CR>", { desc = "Git Status" })
map("n", "<leader>fc", "<cmd>FzfLua git_commits<CR>", { desc = "Git Commits" })

-- Insert mode navigation
map("i", "<C-h>", "<Left>", { desc = "Move cursor left" })
map("i", "<C-j>", "<Down>", { desc = "Move cursor down" })
map("i", "<C-k>", "<Up>", { desc = "Move cursor up" })
map("i", "<C-l>", "<Right>", { desc = "Move cursor right" })
map("i", "<C-a>", "<Home>", { desc = "Move cursor to beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Move cursor to end of line" })

-- Insert Mode deleting
map("i", "<C-BS>", "<C-W>", { desc = "Delete word behind cursor" })
map("i", "<C-Del>", "<Esc>dwi", { desc = "Delete word after cursor" })
