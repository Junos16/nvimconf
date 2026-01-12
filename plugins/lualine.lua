return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'xiyaowong/transparent.nvim',
  },
  lazy = false,
  config = function()
    require('lualine').setup({
      options = {
        theme = 'tokyonight-night',
      },
      sections = {
        lualine_c = {
          {
            'filename',
            file_status = true,
            path = 1,
            color = { fg = '#757575' },
          },
        },
      },
    })
  end,
}
