return {
  'rest-nvim/rest.nvim',
  build = 'make',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'http' })
    end,
  },
  keys = {
    { '<leader>rr', '<cmd>Rest run<cr>', mode = 'n', desc = 'Run HTTP request' },
    { '<leader>rl', '<cmd>Rest last<cr>', mode = 'n', desc = 'Re-run last request' },
    { '<leader>re', '<cmd>Rest env select<cr>', mode = 'n', desc = 'Select .env file' },
  },
}
