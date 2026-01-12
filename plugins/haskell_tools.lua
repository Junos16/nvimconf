return {
  "mrcjkb/haskell-tools.nvim",
  version = "^6",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    vim.g.haskell_tools = {
      tools = {
        formatting = {
          driver = "ormolu",
        },
        linting = {
          hlint = true,
        },
      },
    }
  end,
}