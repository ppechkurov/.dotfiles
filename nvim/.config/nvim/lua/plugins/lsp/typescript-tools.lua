return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    root_dir = require('lspconfig.util').root_pattern('.git'),
    separate_diagnostic_server = false,
  },
}
