-- which-key helps you remember key bindings by showing a popup
-- with the active keybindings of the command you started typing.
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    plugins = { spelling = true },
    defaults = {
      mode = { 'n', 'v' },
      ['g'] = { name = '+goto' },
      ['gz'] = { name = '+surround' },
      [']'] = { name = '+next' },
      ['['] = { name = '+prev' },
      ['<leader>b'] = { name = '+buffer' },
      ['<leader>c'] = { name = '+code' },
      ['<leader>d'] = { name = '+document' },
      ['<leader>f'] = { name = '+file/find' },
      ['<leader>g'] = { name = '+git' },
      ['<leader>gh'] = { name = '+hunks' },
      ['<leader>s'] = { name = '+search' },
      ['<leader>x'] = { name = '+diagnostics/quickfix' },
    },
  },
  config = function(_, opts)
    local wk = require 'which-key'
    wk.register({
      l = {
        name = 'lsp',
        f = { '[f]ormat' },
      },
      g = {
        name = 'git',
        p = { '[p]revious hunk' },
        n = { '[n]ext hunk' },
      },
      s = {
        name = 'search',
        d = { 'diagnostics' },
      },
    }, { prefix = '<leader>' })

    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
