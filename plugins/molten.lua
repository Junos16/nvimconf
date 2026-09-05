return {
	"benlubas/molten-nvim",
	version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
	build = ":UpdateRemotePlugins",
	lazy = false,
	init = function()
		-- Molten options
		vim.g.molten_image_provider = "image.nvim"
		vim.g.molten_output_win_max_height = 20
		vim.g.molten_auto_open_output = false
		vim.g.molten_wrap_output = true
		vim.g.molten_virt_text_output = true
		vim.g.molten_virt_lines_off_by_1 = true

		-- Better Cell Running (Respects # %% markers)
		-- Better Cell Running (Respects # %% markers)
		local function run_cell()
			local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
			local last_line = vim.api.nvim_buf_line_count(0)
			local start_line = 1
			local end_line = last_line

			-- Find cell start
			for i = cursor_line, 1, -1 do
				local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
				if line:match("^# %%%%") then
					start_line = i
					break
				end
			end

			-- Find cell end
			for i = cursor_line + 1, last_line do
				local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
				if line:match("^# %%%%") then
					end_line = i - 1
					break
				end
			end

			-- Set marks and evaluate
			vim.api.nvim_buf_set_mark(0, "<", start_line, 0, {})
			vim.api.nvim_buf_set_mark(0, ">", end_line, 0, {})
			vim.cmd("normal! gv")
			vim.cmd("MoltenEvaluateVisual")
		end

		local map = vim.keymap.set
		map("n", "<leader>mi", ":MoltenInit<CR>", { desc = "Initialize Molten" })
		map("n", "<leader>mx", run_cell, { desc = "Molten Execute Cell" })
		map("n", "<leader>mr", ":MoltenEvaluateOperator<CR>", { desc = "Molten Run Operator" })
		map("n", "<leader>rl", ":MoltenEvaluateLine<CR>", { desc = "Run Line" })
		map("v", "<leader>rv", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Run Visual" })
		map("n", "<leader>rd", ":MoltenDelete<CR>", { desc = "Delete Cell Output" })
		map("n", "<leader>os", ":MoltenShowOutput<CR>", { desc = "Show Output" })
		map("n", "<leader>oh", ":MoltenHideOutput<CR>", { desc = "Hide Output" })
		map("n", "<leader>oe", ":MoltenEnterOutput<CR>", { desc = "Enter Output Window" })

		-- Cell Navigation
		map("n", "]c", function()
			vim.fn.search("^# %%")
		end, { desc = "Next Cell" })
		map("n", "[c", function()
			vim.fn.search("^# %%", "b")
		end, { desc = "Previous Cell" })
	end,
}
