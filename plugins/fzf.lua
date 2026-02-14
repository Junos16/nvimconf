return {
  'ibhagwan/fzf-lua',
  cmd = "FzfLua",
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- calling `setup` is optional for customization
    require('fzf-lua').setup({})
  end
}
