return {
  {
    'sainnhe/gruvbox-material',
    priority = 1000,
    config = function()
      vim.o.background = 'dark' -- or "light" for light mode
      vim.cmd("let g:gruvbox_material_background='hard'") -- 'hard', 'medium'(default), 'soft'
      vim.cmd('let g:gruvbox_material_better_performance=1')
      -- vim.cmd('let g:gruvbox_material_dim_inactive_windows=1')
      vim.cmd("let g:gruvbox_material_visual='green background'") -- visual selection color
      vim.cmd("let g:gruvbox_material_current_word='grey background'")
      vim.cmd("let g:gruvbox_material_float_style='dim'") -- oil bg
      vim.cmd("let g:gruvbox_material_ui_contrast='high'")
      -- vim.cmd('let g:gruvbox_material_transparent_background=2')
      vim.cmd("let g:gruvbox_material_diagnostic_virtual_text='colored'")
      vim.cmd('let g:gruvbox_material_enable_bold=1')
      vim.cmd('let g:gruvbox_material_enable_italic=1')

      -- changing bg and border colors
      vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
      vim.api.nvim_set_hl(0, 'LspInfoBorder', { link = 'Normal' })
      vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })

      vim.cmd.colorscheme('gruvbox-material')
    end,
  },
  -- {
  --   'diegoulloao/neofusion.nvim',
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme('neofusion')
  --   end,
  --   opts = { transparent_mode = false },
  -- },
}
