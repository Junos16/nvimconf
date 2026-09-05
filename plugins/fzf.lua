return {
  'ibhagwan/fzf-lua',
  cmd = "FzfLua",
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find Files" },
    { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Live Grep" },
    { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Find Buffers" },
    { "<leader>fh", "<cmd>FzfLua help_tags<CR>", desc = "Find Help" },
    { "<leader>fs", "<cmd>FzfLua git_status<CR>", desc = "Git Status" },
    { "<leader>fc", "<cmd>FzfLua git_commits<CR>", desc = "Git Commits" },
  },
  config = function()
    -- calling `setup` is optional for customization
    require('fzf-lua').setup({})
  end
}
