vim.o.colorcolumn = '80,100,120'
vim.o.conceallevel = 2 -- for obsidian nvim additional features
-- vim.o.guifont = 'CaskaydiaCove Nerd Font:h18'
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

vim.opt.backup = false -- creates a backup file
vim.opt.clipboard = 'unnamedplus' -- allows neovim to access the system clipboard
vim.opt.cmdheight = 1 -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { 'menuone', 'noselect' } -- mostly just for cmp
vim.opt.confirm = true -- confirm to save changes before exiting
vim.opt.cursorline = true -- highlight the current line
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.fillchars:append({ stl = ' ' })
vim.opt.hlsearch = true -- highlight all matches on previous search pattern
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.laststatus = 3
vim.opt.mouse = 'a' -- allow the mouse to be used in neovim
vim.opt.number = true -- set numbered lines
vim.opt.numberwidth = 4 -- set number column width to 2 {default 4}
vim.opt.pumblend = 10
vim.opt.pumheight = 10 -- pop up menu height
vim.opt.relativenumber = true -- set relative numbered lines
vim.opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.opt.shortmess:append('c')
vim.opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 1 -- always show tabs
vim.opt.signcolumn = 'yes' -- always show the sign column, otherwise it would shift the text each time
vim.opt.smartcase = true -- smart case
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.spelllang = 'en'
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false -- creates a swapfile
vim.opt.tabstop = 2 -- insert 2 spaces for a tab
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.title = false
vim.opt.undofile = true -- enable persistent undo
vim.opt.updatetime = 200 -- faster completion (4000ms default)
vim.opt.wrap = false -- display lines as one long line
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.fillchars = {
  foldopen = '',
  foldclose = '',
  -- fold = "⸱",
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
}

vim.cmd('set whichwrap+=<,>,[,],h,l')

-- folds
vim.opt.foldlevel = 99
vim.o.foldmethod = 'indent'

-- vim.cmd([[set iskeyword+=-]])
--vim.cmd([[set iskeyword+=_]])

vim.g.netrw_banner = 0
vim.g.netrw_mouse = 2

-- Sets how neovim will display certain whitespace in the editor.
--  See :help 'list'
--  and :help 'listchars'
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

if vim.g.neovide then
  vim.o.guifont = 'ShureTechMono Nerd Font:h18'
  vim.g.neovide_fullscreen = true
  vim.g.neovide_cursor_vfx_mode = 'pixiedust'
  vim.g.neovide_confirm_quit = true

  vim.o.scrolloff = 10
  vim.o.sidescrolloff = 10

  -- vim.g.neovide_transparency = 0.95
end
