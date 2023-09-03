-- Install package manager
-- https://github.com/folke/lazy.nvim
-- `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

--  NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--  You can also configure plugins after the setup call,
--  as they will be available in your neovim runtime.

require('lazy').setup({
  --  NOTE: The import below can automatically add your own plugins, configuration, etc
  --  from `lua/plugins/*.lua`.
  --  For additional information see:
  --  https://github.com/folke/lazy.nvim#-structuring-your-plugins
  { import = 'plugins' },

  -- colorscheme
  {
    'lunarvim/darkplus.nvim',
    config = function()
      vim.cmd.colorscheme 'darkplus'
    end,
  },
}, {})

-- Setup neovim lua configuration
require('neodev').setup()
