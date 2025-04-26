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

  local severity = vim.diagnostic.severity
  vim.diagnostic.config({
    virtual_text = {
      prefix = '',
      spacing = 4,
      source = 'if_many',
    },

    update_in_insert = false,
    -- underline = true,
    severity_sort = true,

    signs = {
      text = {
        [severity.ERROR] = icons.diagnostics.Error,
        [severity.WARN] = icons.diagnostics.Warning,
        [severity.INFO] = icons.diagnostics.Information,
        [severity.HINT] = icons.diagnostics.Hint,
      },
    },

    underline = true,

    float = {
      focusable = true,
      style = 'minimal',
      border = 'none',
      source = true,
      header = '',
      prefix = '',
    },
  })
  local border = {
    { '┌', 'FloatBorder' },
    { '─', 'FloatBorder' },
    { '┐', 'FloatBorder' },
    { '│', 'FloatBorder' },
    { '┘', 'FloatBorder' },
    { '─', 'FloatBorder' },
    { '└', 'FloatBorder' },
    { '│', 'FloatBorder' },
  }
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.buf.hover({
    border = border,
  })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.buf.signature_help()
  -- vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.buf.signature_help({ border = 'none' })

  require('lspconfig.ui.windows').default_options.border = 'single'

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
