return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    root_dir = require('lspconfig.util').root_pattern('.git'),
    on_attach = function()
      vim.lsp.inlay_hint.enable(true)
    end,

    settings = {
      separate_diagnostic_server = false,
      publish_diagnostic_on = 'change',
      expose_as_code_action = {
        'fix_all',
        'organize_imports',
      },
      tsserver_file_preferences = {
        includeCompletionsForModuleExports = true,
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayParameterNameHints = 'all',
        includeInlayVariableTypeHints = true,
      },
    },
  },
}
