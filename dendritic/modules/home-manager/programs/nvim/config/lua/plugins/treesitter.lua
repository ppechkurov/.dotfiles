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
  end,
  config = function()
    require('nvim-treesitter').setup()

    require('nvim-treesitter').install({
      'bash',
      'c',
      'diff',
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
