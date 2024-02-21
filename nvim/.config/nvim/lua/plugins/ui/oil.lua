return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('oil').setup({
      default_file_explorer = true,
      prompt_confirm_for_simple_edits = false,
      float = {
        padding = 10,
        border = 'single',
        max_height = 20,
        max_width = 60,
      },
      keymaps = {
        ['<esc>'] = 'actions.close',
        ['<S-h>'] = 'actions.toggle_hidden',
      },
    })
    vim.keymap.set('n', '-', '<CMD>Oil --float<CR>', { desc = 'Open parent directory' })
  end,
}
