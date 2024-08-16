return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    separate_diagnostic_server = true,
    root_dir = require('lspconfig.util').root_pattern('.git'),
  },
}
