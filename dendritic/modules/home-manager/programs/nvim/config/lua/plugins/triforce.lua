return {
  'gisketch/triforce.nvim',
  dependencies = { 'nvzone/volt' },
  keys = {
    {
      '<leader>tp',
      function()
        require('triforce').show_profile()
      end,
    },
  },
  opts = {},
}
