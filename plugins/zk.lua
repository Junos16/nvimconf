return {
	"mickael-menu/zk-nvim",
	config = function()
		local zk = require("zk")
		local commands = require("zk.commands")

		zk.setup({
			picker = "fzf", -- You already have fzf-lua installed
		})

		-- Helper for visual selection linking
		local function make_link_from_selection()
			zk.new({ dir = "notes", title = vim.fn.input("Title: ") }, { post_action = "insert_link" })
		end

		-- Keymaps
		local opts = { noremap = true, silent = true }
		
		-- Create new note
		vim.keymap.set("n", "<leader>zn", "<cmd>ZkNew { title = vim.fn.input('Title: ') }<cr>", { desc = "New Note" })
		
		-- Search notes
		vim.keymap.set("n", "<leader>zf", "<cmd>ZkNotes { sort = { 'modified' } }<cr>", { desc = "Find Notes" })
		vim.keymap.set("n", "<leader>zt", "<cmd>ZkTags<cr>", { desc = "Search Tags" })
		
		-- Linking & Backlinks
		-- In normal mode, search and insert link at cursor
		vim.keymap.set("n", "<leader>zi", "<cmd>ZkInsertLink<cr>", { desc = "Insert Link" })
		-- In visual mode, create a new note from selection and link it
		vim.keymap.set("v", "<leader>zn", ":' <,'>ZkNewFromTitleSelection<cr>", { desc = "New Note from Selection" })
		-- Search backlinks for the current note
		vim.keymap.set("n", "<leader>zb", "<cmd>ZkBacklinks<cr>", { desc = "Backlinks" })
	end,
}
