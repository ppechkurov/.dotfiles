return {
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  keys = {
    { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
    { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
    { '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete Other Buffers' },
    { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
    { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
    { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
    { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
    { '[B', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
    { ']B', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
  },
  opts = {
    options = {
      diagnostics = 'nvim_lsp',
      always_show_bufferline = false,
      -- diagnostics_indicator = function(_, _, diag)
      --   local icons = LazyVim.config.icons.diagnostics
      --   local ret = (diag.error and icons.Error .. diag.error .. ' ' or '')
      --     .. (diag.warning and icons.Warn .. diag.warning or '')
      --   return vim.trim(ret)
      -- end,
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'Neo-tree',
          highlight = 'Directory',
          text_align = 'left',
        },
      },
      ---@param opts bufferline.IconFetcherOpts
      -- get_element_icon = function(opts)
      --   return LazyVim.config.icons.ft[opts.filetype]
      -- end,
      custom_filter = function(buf_number)
        if not not vim.api.nvim_buf_get_name(buf_number):find(vim.fn.getcwd(), 0, true) then
          return true
        end
        return false
      end,
    },
  },
  -- config = function(_, opts)
  --   opts.options.custom_filter = function(buf_number)
  --     if not not vim.api.nvim_buf_get_name(buf_number):find(vim.fn.getcwd(), 0, true) then
  --       return true
  --     end
  --     return false
  --   end
  --   print(vim.inspect(opts))
  --
  --   require('bufferline').setup(opts)
  --   -- Fix bufferline when restoring a session
  --   vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
  --     callback = function()
  --       vim.schedule(function()
  --         pcall(nvim_bufferline)
  --       end)
  --     end,
  --   })
  -- end,
}
