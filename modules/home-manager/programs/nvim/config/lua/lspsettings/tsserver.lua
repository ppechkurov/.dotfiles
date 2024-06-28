return {
  root_dir = require('lspconfig.util').root_pattern('.git'),
  keys = {
    {
      '<leader>co',
      function()
        vim.lsp.buf.code_action({
          apply = true,
          context = {
            only = { 'source.organizeImports.ts' },
            diagnostics = {},
          },
        })
      end,
      desc = 'Organize Imports',
    },
  },
  init_options = {
    preferences = {
      importModuleSpecifierPreference = 'non-relative', -- relative path import
      -- importModuleSpecifierEnding = "minimal",   -- remove .js from import
    },
  },
  commands = {
    OrganizeImports = {
      function()
        local params = {
          command = '_typescript.organizeImports',
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = '',
        }
        vim.lsp.buf.execute_command(params)
      end,
      description = 'Organize Imports',
    },
  },
}
