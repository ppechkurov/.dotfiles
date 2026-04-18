vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

vim.keymap.set('n', 'n', 'nzz', { silent = true, desc = 'Center screen after n' })
vim.keymap.set('n', 'N', 'Nzz', { silent = true, desc = 'Center screen after N' })

vim.keymap.set('n', '<esc>', ':noh<cr><esc>', { silent = true, desc = 'noh' })

-- Move Lines
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- better indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

local function resize_h(delta)
  return function()
    local has_right = vim.fn.win_getid(vim.fn.winnr('l')) ~= vim.api.nvim_get_current_win()
    local d = has_right and delta or -delta
    vim.cmd(('vertical resize %+d'):format(d))
  end
end

local function resize_v(delta)
  return function()
    local has_below = vim.fn.win_getid(vim.fn.winnr('j')) ~= vim.api.nvim_get_current_win()
    local d = has_below and delta or -delta
    vim.cmd(('resize %+d'):format(d))
  end
end

vim.keymap.set('n', '<Left>', resize_h(-2), { desc = 'Move border left' })
vim.keymap.set('n', '<Right>', resize_h(2), { desc = 'Move border right' })
vim.keymap.set('n', '<Up>', resize_v(-2), { desc = 'Move border up' })
vim.keymap.set('n', '<Down>', resize_v(2), { desc = 'Move border down' })
