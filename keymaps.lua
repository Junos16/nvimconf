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

-- Markdown Link Pasting
local function paste_url_as_link()
	local url = vim.fn.getreg("+"):gsub("%s+", "")
	if url:match("^https?://") or url:match("^www%.") then
		vim.snippet.expand(string.format("[$1](%s)$0", url))
	else
		vim.api.nvim_feedkeys("p", "n", false)
	end
end

map("n", "<leader>ml", paste_url_as_link, { desc = "Paste URL as Markdown Link" })
map("v", "<leader>ml", function()
	local url = vim.fn.getreg("+"):gsub("%s+", "")
	if url:match("^https?://") or url:match("^www%.") then
		-- Exit visual mode to set the marks '< and '>
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", true)
		
		vim.schedule(function()
			-- Get the selected text accurately
			local start_pos = vim.fn.getpos("'<")
			local end_pos = vim.fn.getpos("'>")
			local lines = vim.api.nvim_buf_get_text(0, start_pos[2]-1, start_pos[3]-1, end_pos[2]-1, end_pos[3], {})
			local selected_text = table.concat(lines, "\n"):gsub("\n$", "") -- Trim trailing newline from Shift+V
			
			-- Expand snippet with the selected text as placeholder
			vim.snippet.expand(string.format("[${1:%s}](%s)$0", selected_text, url))
		end)
	else
		vim.api.nvim_feedkeys("p", "n", false)
	end
end, { desc = "Wrap Selection in URL" })
