return {
  'folke/which-key.nvim',
  config = function()
    local mappings = {
      q = { '<cmd>confirm q<CR>', 'Quit' },
      c = {
        name = '[c]lose buffers',
        o = { '<cmd>%bd|e#|bd#<CR>', '[o]thers' },
        c = { '<cmd>bd<CR>', '[c]urrent' },
      },
      d = { name = '[d]ebug' },
      s = { name = '[s]earch' },
      g = { name = '[g]it' },
      l = { name = '[L]SP' },
      -- p = { name = "Plugins" },
      t = {
        name = '[t]abs',
        n = { '<cmd>$tabnew<cr>', 'New Empty Tab' },
        N = { '<cmd>tabnew %<cr>', 'New Tab' },
        o = { '<cmd>tabonly<cr>', 'Only' },
        h = { '<cmd>-tabmove<cr>', 'Move Left' },
        l = { '<cmd>+tabmove<cr>', 'Move Right' },
      },
    }

    local which_key = require('which-key')
    which_key.setup({
      plugins = {
        marks = true,
        registers = true,
        spelling = { enabled = true, suggestions = 20 },
        presets = {
          operators = false,
          motions = false,
          text_objects = false,
          windows = false,
          nav = false,
          z = false,
          g = false,
        },
      },
      window = {
        border = 'none',
        position = 'bottom',
        padding = { 2, 2, 2, 2 },
      },
      ignore_missing = true,
      show_help = false,
      show_keys = false,
      disable = {
        buftypes = {},
        filetypes = { 'TelescopePrompt' },
      },
    })

    local opts = {
      mode = 'n', -- NORMAL mode
      prefix = '<leader>',
    }

    which_key.register(mappings, opts)
  end,
}
