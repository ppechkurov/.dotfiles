return {
  'nvim-mini/mini.files',
  config = function()
    local wk = require('which-key')
    wk.register({
      ['<leader>e'] = { ':lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>', 'File Tree' },
      ['<BS>'] = { ':lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>', 'File Tree' },
    })
    require('mini.files').setup()
  end,
}
