vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set(
  'n',
  '<leader>cll',
  'yiwoconsole.log(\'<c-r>":\', <c-r>");<esc>_',
  { silent = true, desc = 'Console: Log variable under cursor' }
)

vim.keymap.set('n', 'n', 'nzz', { silent = true, desc = 'Center screen after n' })
vim.keymap.set('n', 'N', 'Nzz', { silent = true, desc = 'Center screen after N' })

vim.keymap.set('n', '<esc>', ':noh<cr>', { silent = true, desc = 'Center screen after N' })
