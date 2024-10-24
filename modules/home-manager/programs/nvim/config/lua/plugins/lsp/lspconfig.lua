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
  keymap(bufnr, 'n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  keymap(bufnr, 'n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  keymap(bufnr, 'n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
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
    ['<leader>ca'] = { '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Code Action' },
    ['<leader>cA'] = {
      '<cmd>lua vim.lsp.buf.code_action({ context = { only = { "source" } }, diagnostics = {}})<cr>',
      'Code Action',
    },
    ['<leader>cf'] = { "<cmd> lua require('conform').format()<cr>", 'Format' },
    ['<leader>ci'] = { '<cmd>LspInfo<cr>', 'Info' },
    ['<leader>cj'] = { '<cmd>lua vim.diagnostic.goto_next()<cr>', 'Next Diagnostic' },
    ['<leader>ch'] = { '<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>', 'Hints' },
    ['<leader>ck'] = { '<cmd>lua vim.diagnostic.goto_prev()<cr>', 'Prev Diagnostic' },
    ['<leader>cl'] = { '<cmd>lua vim.lsp.codelens.run()<cr>', 'CodeLens Action' },
    ['<leader>cq'] = { '<cmd>lua vim.diagnostic.setloclist()<cr>', 'Quickfix' },
    ['<leader>cr'] = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename' },
  })

  local lspconfig = require('lspconfig')
  local icons = require('config.icons')

  local default_diagnostic_config = {
    signs = {
      active = true,
      values = {
        { name = 'DiagnosticSignError', text = icons.diagnostics.Error },
        { name = 'DiagnosticSignWarn', text = icons.diagnostics.Warning },
        { name = 'DiagnosticSignHint', text = icons.diagnostics.Hint },
        { name = 'DiagnosticSignInfo', text = icons.diagnostics.Information },
      },
    },
    virtual_text = {
      spacing = 4,
      source = 'if_many',
      prefix = '●',
    },
    update_in_insert = false,
    -- underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = 'minimal',
      border = 'none',
      source = 'always',
      header = '',
      prefix = '',
    },
  }

  vim.diagnostic.config(default_diagnostic_config)

  for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), 'signs', 'values') or {}) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'none' })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'none' })

  require('lspconfig.ui.windows').default_options.border = 'none'

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
