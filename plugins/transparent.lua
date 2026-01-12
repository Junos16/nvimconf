return {
  "xiyaowong/transparent.nvim",
  lazy = false,
  priority = 1000,
  init = function()
    vim.g.transparent_enabled = true

    -- Early highlight clearing
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    -- vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
    -- vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

    -- Add desired groups to transparent_groups
    vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {}, {
      -- 'NormalFloat',
      -- 'FloatBorder',
      -- 'NvimTreeNormal',
    })
      --[[ -- Lualine groups
      'lualine_b_normal', 'lualine_b_insert', 'lualine_b_visual',
      'lualine_b_command', 'lualine_b_replace',
      'lualine_c_normal', 'lualine_c_insert', 'lualine_c_visual',
      'lualine_c_command', 'lualine_c_replace',
      'lualine_c_filename_command', 'lualine_c_filename_inactive',
      'lualine_c_filename_insert', 'lualine_c_filename_normal',
      'lualine_c_filename_replace', 'lualine_c_filename_terminal',
      'lualine_c_filename_visual',
      'lualine_x_normal', 'lualine_x_insert', 'lualine_x_visual',
      'lualine_x_command', 'lualine_x_replace',
      'lualine_y_normal', 'lualine_y_insert', 'lualine_y_visual',
      'lualine_y_command', 'lualine_y_replace',
      'lualine_z_normal', 'lualine_z_insert', 'lualine_z_visual',
      'lualine_z_command', 'lualine_z_replace',
      -- Lualine transitions
      'lualine_transitional_lualine_a_normal_to_lualine_b_normal',
      'lualine_transitional_lualine_a_insert_to_lualine_b_insert',
      'lualine_transitional_lualine_a_visual_to_lualine_b_visual',
      'lualine_transitional_lualine_a_command_to_lualine_b_command',
      'lualine_transitional_lualine_a_replace_to_lualine_b_replace',
      'lualine_transitional_lualine_x_normal_to_lualine_y_normal',
      'lualine_transitional_lualine_x_insert_to_lualine_y_insert',
      'lualine_transitional_lualine_x_visual_to_lualine_y_visual',
      'lualine_transitional_lualine_x_command_to_lualine_y_command',
      'lualine_transitional_lualine_x_replace_to_lualine_y_replace',
      'lualine_transitional_lualine_y_normal_to_lualine_z_normal',
      'lualine_transitional_lualine_y_insert_to_lualine_z_insert',
      'lualine_transitional_lualine_y_visual_to_lualine_z_visual',
      'lualine_transitional_lualine_y_command_to_lualine_z_command',
      'lualine_transitional_lualine_y_replace_to_lualine_z_replace', ]]

  end,
  config = function()
    vim.api.nvim_create_autocmd({ 'UiEnter', 'ColorScheme' }, {
      callback = function()
        vim.cmd([[
          hi TabLineFill guibg=none
          hi WinBar guibg=none
          hi Normal guibg=NONE ctermbg=NONE
          hi TabLineFill guibg=NONE ctermbg=NONE
          hi WinBar guibg=NONE ctermbg=NONE
        ]])
          -- hi StatusLine guibg=NONE ctermbg=NONE
          -- hi StatusLineNC guibg=NONE ctermbg=NONE

        local ok, bufferline = pcall(require, 'bufferline.config')
        if ok then
          vim.g.transparent_groups = vim.list_extend(
            vim.g.transparent_groups or {},
            vim.tbl_map(function(v)
              return v.hl_group
            end, vim.tbl_values(bufferline.highlights or {}))
          )
        end
      end,
    })
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        vim.defer_fn(function()
          for _ , group in ipairs(vim.g.transparent_groups or {}) do
            vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
          end
        end, 0)
      end,
    })
  end,
}
