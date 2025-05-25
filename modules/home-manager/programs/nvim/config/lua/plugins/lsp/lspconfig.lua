local M = {
  'neovim/nvim-lspconfig',
  event = { 'VeryLazy' },
  dependencies = {
    {
      'folke/neodev.nvim',
      'folke/which-key.nvim',
    },
  },
}

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap
  -- gD is the default mapping for go to first occurence of a word under the cursor
  keymap(bufnr, 'n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
  keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
end

M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true)
  end
end

function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return capabilities
end

function M.config()
  local wk = require('which-key')
  wk.register({
    ['<leader>cf'] = { "<cmd> lua require('conform').format()<cr>", 'Format' },
    ['<leader>ch'] = { '<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>', 'Hints' },
    ['<leader>cl'] = { '<cmd>lua vim.lsp.codelens.run()<cr>', 'CodeLens Action' },
    ['<leader>cq'] = { '<cmd>lua vim.diagnostic.setloclist()<cr>', 'Quickfix' },
    ['gra'] = { '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Code Action' },
    ['gri'] = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Implementation' },
    ['grn'] = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename' },
    ['grr'] = { '<cmd>Telescope lsp_references<CR>', 'References' },
    ['<C-W>d'] = { '<cmd>lua vim.diagnostic.open_float()<CR>', 'Float diagnostics' },
  })

  local lspconfig = require('lspconfig')
  local icons = require('config.icons')

  local severity = vim.diagnostic.severity
  vim.diagnostic.config({
    virtual_text = {
      prefix = ' ',
      spacing = 4,
      source = 'if_many',
    },

    severity_sort = true,

    underline = true,
    update_in_insert = false,

    signs = {
      text = {
        [severity.ERROR] = icons.diagnostics.Error,
        [severity.WARN] = icons.diagnostics.Warning,
        [severity.INFO] = icons.diagnostics.Information,
        [severity.HINT] = icons.diagnostics.Hint,
      },
    },

    float = {
      focusable = true,
      style = 'minimal',
      border = 'none',
      source = true,
      header = '',
      prefix = '',
    },
  })

  local servers = {
    'lua_ls',
    'html',
    -- 'tsserver', // configured in typescript-tools
    'eslint',
    'bashls',
    'jsonls',
    'yamlls',
    'ansiblels',
    'marksman',
    'nil_ls',
    'gopls',
    'golangci_lint_ls',
    'terraformls',
    'docker_compose_language_service',
    'clangd',
    'asm_lsp',
    'denols',
  }

  for _, server in pairs(servers) do
    local opts = {
      on_attach = M.on_attach,
      capabilities = M.common_capabilities(),
    }

    local require_ok, settings = pcall(require, 'lspsettings.' .. server)
    if require_ok then
      opts = vim.tbl_deep_extend('force', settings, opts)
    end

    if server == 'lua_ls' then
      require('neodev').setup({})
    end

    lspconfig[server].setup(opts)
  end
end

return M
