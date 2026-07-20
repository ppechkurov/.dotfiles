return {
  'stevearc/aerial.nvim',
  branch = 'master',
  opts = {},
  -- Optional dependencies
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('aerial').setup({
      layout = {
        placement = 'edge',
        min_width = { 20 },
      },
      close_automatic_events = {
        'unsupported',
      },

      -- optionally use on_attach to set keymaps when aerial has attached to a buffer
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
      end,
    })
    -- You probably also want to set a keymap to toggle aerial
    vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
    require('telescope').load_extension('aerial')
  end,
}
