return {
  'lewis6991/gitsigns.nvim',
  event = 'BufEnter',
  cmd = 'Gitsigns',
  opts = {
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
      untracked = { text = '▎' },
    },
    signs_staged = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
    },
  },
  config = function()
    local wk = require('which-key')
    wk.register({
      ['<leader>gj'] = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", 'Next Hunk' },
      ['<leader>gk'] = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", 'Prev Hunk' },
      ['<leader>gp'] = { "<cmd>lua require 'gitsigns'.preview_hunk_inline()<cr>", 'Preview Hunk' },
      ['<leader>gr'] = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", 'Reset Hunk' },
      ['<leader>gl'] = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", 'Blame' },
      ['<leader>gR'] = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", 'Reset Buffer' },
      ['<leader>gs'] = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", 'Stage Hunk' },
      ['<leader>gu'] = {
        "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
        'Undo Stage Hunk',
      },
      ['<leader>gd'] = {
        '<cmd>Gitsigns diffthis HEAD<cr>',
        'Git Diff',
      },
    })

    require('gitsigns').setup({
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = true,
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      update_debounce = 200,
      max_file_length = 40000,
      preview_config = {
        border = 'none',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
    })
  end,
}
