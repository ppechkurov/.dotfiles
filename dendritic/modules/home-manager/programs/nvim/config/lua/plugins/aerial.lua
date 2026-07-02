return {
  'stevearc/aerial.nvim',
  commit = 'c5e56945d9703f7079ccff484b35d0e4c231dd6c', -- nvim-0.11 branch
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
