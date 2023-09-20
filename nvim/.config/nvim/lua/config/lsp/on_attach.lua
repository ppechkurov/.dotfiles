-- [[ configure lsp ]]
--  this function gets run when an lsp connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- formatting on save
  -- if client.supports_method 'textDocument/formatting' then
  --   local format_on_save = vim.api.nvim_create_augroup('LspFormatting', { clear = true })
  --   vim.api.nvim_create_autocmd('BufWritePre', {
  --     group = format_on_save,
  --     buffer = bufnr,
  --     callback = function()
  --       vim.lsp.buf.format {
  --         bufnr = bufnr,
  --         filter = function(_client)
  --           return _client.name == 'vtsls'
  --         end,
  --       }
  --     end,
  --   })
  -- end

  client.server_capabilities.semanticTokensProvider = nil

  if client.server_capabilities.documentSymbolProvider then
    require('nvim-navic').attach(client, bufnr)
  end

  --  NOTE: remember that lua is a real programming language, and as such it is possible
  --  to define small helper and utility functions so you don't have to repeat yourself
  --  many times.
  --
  -- in this case, we create a function that lets us more easily define mappings specific
  -- for lsp related items. it sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('gd', vim.lsp.buf.definition, '[g]oto [d]efinition')
  nmap('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')
  nmap('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[g]oto [I]mplementation')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  nmap('<leader>lr', vim.lsp.buf.rename, '[r]ename')
  nmap('<leader>lc', vim.lsp.buf.code_action, '[a]ction')
  nmap('<leader>lD', vim.lsp.buf.type_definition, 'type [D]efinition')
  nmap('<leader>lf', function()
    vim.lsp.buf.format { timeout_ms = 2000, async = true }
  end, '[f]ormat')
end

return on_attach
