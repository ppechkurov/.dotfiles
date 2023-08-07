-- [[ configure lsp ]]
--  this function gets run when an lsp connects to a particular buffer.
local on_attach = function(client, bufnr)
  if client.name == 'vtsls' then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
  if client.server_capabilities.documentSymbolProvider then
    require('nvim-navic').attach(client, bufnr)
  end

  -- note: remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
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
  nmap('<leader>lf', vim.lsp.buf.format, '[f]ormat')
end

return on_attach
