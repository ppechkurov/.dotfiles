-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
require 'setup'

require 'config.lsp'

require 'config.options'
require 'config.keymaps'

require 'autocommands'

-- remove treesitter colors glitch
for _, group in ipairs(vim.fn.getcompletion('@lsp', 'highlight')) do
  vim.api.nvim_set_hl(0, group, {})
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
