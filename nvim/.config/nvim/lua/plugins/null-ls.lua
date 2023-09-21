local on_attach = require 'config.lsp.on_attach'
-- formatters
return {
  'jose-elias-alvarez/null-ls.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'mason.nvim' },
  opts = function()
    local nls = require 'null-ls'
    return {
      root_dir = require('null-ls.utils').root_pattern('.null-ls-root', '.neoconf.json', 'Makefile', '.git'),
      sources = {
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.shfmt,
        nls.builtins.formatting.prettierd,
        nls.builtins.diagnostics.eslint_d,
        nls.builtins.code_actions.eslint_d,
      },
      on_attach = on_attach,
    }
  end,
}
