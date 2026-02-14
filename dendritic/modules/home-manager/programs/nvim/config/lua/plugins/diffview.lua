return {
  'sindrets/diffview.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
  keys = {
    { '<leader>vv', '<cmd>DiffviewFileHistory %<cr>', desc = 'View git history for current file' },
    { '<leader>vh', '<cmd>DiffviewFileHistory<cr>', desc = 'View git history for repo' },
    { '<leader>vo', '<cmd>DiffviewOpen<cr>', desc = 'View modified files' },
    { '<leader>vc', '<cmd>DiffviewClose<cr>', desc = 'Close Diffview' },
  },
  opts = {
    enhanced_diff_hl = true,
    use_icons = true,
    view = {
      default = {
        layout = 'diff2_horizontal',
      },
    },
  },
  config = function(_, opts)
    require('diffview').setup(opts)

    -- Credits to [this](https://gist.github.com/koushikyemula/cc4448719b6aa18d6a614dca94178430)
    local function set_diff_highlights()
      local is_dark = vim.o.background == 'dark'

      if is_dark then
        vim.api.nvim_set_hl(0, 'DiffAdd', { fg = 'none', bg = '#2e4b2e', bold = true })
        vim.api.nvim_set_hl(0, 'DiffDelete', { fg = 'none', bg = '#4c1e15', bold = true })
        vim.api.nvim_set_hl(0, 'DiffChange', { fg = 'none', bg = '#45565c', bold = true })
        vim.api.nvim_set_hl(0, 'DiffText', { fg = 'none', bg = '#996d74', bold = true })
      else
        vim.api.nvim_set_hl(0, 'DiffAdd', { fg = 'none', bg = 'palegreen', bold = true })
        vim.api.nvim_set_hl(0, 'DiffDelete', { fg = 'none', bg = 'tomato', bold = true })
        vim.api.nvim_set_hl(0, 'DiffChange', { fg = 'none', bg = 'lightblue', bold = true })
        vim.api.nvim_set_hl(0, 'DiffText', { fg = 'none', bg = 'lightpink', bold = true })
      end
    end

    set_diff_highlights()

    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('DiffColors', { clear = true }),
      callback = set_diff_highlights,
    })
  end,
}
