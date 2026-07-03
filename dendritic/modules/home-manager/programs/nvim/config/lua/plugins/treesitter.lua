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
        pcall(function()
          vim.treesitter.start(args.buf)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end)
      end,
    })
  end,
  config = function()
    require('nvim-treesitter').setup()

    local ensureInstalled = {
      'bash', 'c', 'diff', 'html', 'http', 'javascript',
      'jsdoc', 'json', 'just', 'lua', 'markdown',
      'markdown_inline', 'nix', 'query', 'regex', 'sql',
      'toml', 'tsx', 'typescript', 'vim', 'vimdoc', 'yaml', 'zig',
    }
    local alreadyInstalled = require('nvim-treesitter.config').get_installed()
    local parsersToInstall = vim.iter(ensureInstalled)
      :filter(function(parser)
        return not vim.tbl_contains(alreadyInstalled, parser)
      end)
      :totable()
    if #parsersToInstall > 0 then
      require('nvim-treesitter').install(parsersToInstall)
    end
  end,
}
