-- [[ Basic Keymaps ]]
local map = vim.keymap.set

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
map('n', 'k', 'v:count == 0 ? \'gk\' : \'k\'', { expr = true, silent = true })
map('n', 'j', 'v:count == 0 ? \'gj\' : \'j\'', { expr = true, silent = true })

-- -- Show filetree
-- map(
--   'n',
--   '<leader>e',
--   ':Telescope file_browser path=%:p:h select_buffer=true<CR>',
--   { noremap = true, desc = 'Explorer' }
-- )

-- Move to window using the <ctrl> hjkl keys
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', remap = true })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', remap = true })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', remap = true })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Resize window using <ctrl> arrow keys
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Move Lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
map('v', '<A-j>', ':m \'>+1<cr>gv=gv', { desc = 'Move down' })
map('v', '<A-k>', ':m \'<-2<cr>gv=gv', { desc = 'Move up' })

-- buffers
map('n', '<S-h>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev buffer' })
map('n', '<S-l>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
map('n', '[b', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev buffer' })
map('n', ']b', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
map('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
map('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- telescope filebrowser
map('n', '<leader>fb', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { noremap = true }) -- open file_browser with the path of the current buffer
map('n', '<leader>fB', ':Telescope file_browser<CR>', { noremap = true })

-- Oil
local oil = require 'oil'
map('n', '<leader>oo', function()
  oil.toggle_float(oil.get_current_dir())
end, { noremap = true, desc = 'Explorer' })

-- MiniFiles
map('n', '<leader>e', function()
  print(vim.api.nvim_buf_get_name(0))
  require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
end, { noremap = true, desc = 'Open mini.files (directory of current file)' })

map('n', '<leader>E', function()
  print(vim.loop.cwd())
  require('mini.files').open(vim.loop.cwd(), true)
end, { noremap = true, desc = 'Open mini.files (cwd)' })

map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })
map('n', '<leader>w', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- Lspsaga
map('n', '<leader>sd', ':Lspsaga diagnostic_jump_next<CR>', { desc = 'diagnostics' })