return {
  'Exafunction/codeium.vim',
  event = 'BufEnter',
  enabled = false,
  config = function()
    vim.keymap.set('i', '<C-g>', function()
      return vim.fn['codeium#Accept']()
    end, { expr = true, silent = true })
  end,
}
