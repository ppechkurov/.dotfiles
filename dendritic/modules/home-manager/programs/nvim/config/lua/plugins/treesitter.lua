return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  init = function()
    local group = vim.api.nvim_create_augroup('nvim-treesitter', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      callback = function(args)
        local ft = args.match or vim.bo[args.buf].filetype
        if not ft or ft == '' or ft:find('^[A-Z]') then
          return
        end
        local lang = vim.treesitter.language.get_lang(ft) or ft
        local ok, has_parser = pcall(vim.treesitter.language.inspect, lang)
        if not ok or not has_parser then
          return
        end
        vim.treesitter.start(args.buf)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client.name == 'gopls' then
          vim.lsp.semantic_tokens.enable(false, {
            client_id = client.id,
          })
        end
      end,
    })
  end,
  config = function()
    require('nvim-treesitter').setup()

    require('nvim-treesitter').install({
      'bash',
      'c',
      'diff',
      'go',
      'html',
      'http',
      'javascript',
      'jsdoc',
      'json',
      'just',
      'lua',
      'markdown',
      'markdown_inline',
      'nix',
      'query',
      'regex',
      'sql',
      'terraform',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'yaml',
      'zig',
    })
  end,
}
