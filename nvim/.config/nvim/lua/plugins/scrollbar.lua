return {
  'petertriho/nvim-scrollbar',
  config = function()
    require('scrollbar').setup {
      handle = { color = '#e0e0e0' },
      excluded_filetypes = { 'alpha' },
    }
  end,
}
