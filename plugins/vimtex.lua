return {
  "lervag/vimtex",
  lazy = false, -- Recommended by VimTeX for proper startup
  init = function()
    -- Use Zathura as the default viewer (highly recommended for Linux)
    -- If you don't have zathura, you can change this to 'general'
    vim.g.vimtex_view_method = "zathura"
    
    -- Set the compiler to latexmk (standard)
    vim.g.vimtex_compiler_method = "latexmk"

    -- Disable VimTeX's internal syntax highlighting to let Treesitter handle it
    -- but keep VimTeX for the logic/features
    vim.g.vimtex_syntax_enabled = 0
  end,
}
