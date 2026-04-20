return {
  'shortcuts/no-neck-pain.nvim',
  config = function()
    require('no-neck-pain').setup({
      buffers = {
        scratchPad = {
          enabled = true,
          location = '~/Documents/',
        },
        bo = {
          filetype = 'md',
        },
      },
    })
  end,
  keys = {
    {
      '<leader>np',
      '<cmd>NoNeckPain<cr>',
      desc = 'No Neck Pain',
    },
  },
}
