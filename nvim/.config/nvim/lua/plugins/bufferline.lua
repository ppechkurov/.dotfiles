-- This is what powers LazyVim's fancy-looking
-- tabs, which include filetype icons and close buttons.
return {
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  keys = {
    {
      '<leader>bp',
      '<Cmd>BufferLineTogglePin<CR>',
      desc = 'Toggle pin',
    },
    {
      '<leader>bP',
      '<Cmd>BufferLineGroupClose ungrouped<CR>',
      desc = 'Delete non-pinned buffers',
    },
  },
  opts = {
    options = {
			-- stylua: ignore
			close_command = function(n) require("mini.bufremove").delete(n, false) end,
			-- stylua: ignore
			right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
      diagnostics = 'nvim_lsp',
      always_show_bufferline = false,
      diagnostics_indicator = function(_, _, diag)
        local icons = require('core.icons').diagnostics
        local ret = (diag.error and icons.Error .. diag.error .. ' ' or '')
          .. (diag.warning and icons.Warn .. diag.warning or '')
        return vim.trim(ret)
      end,
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'Neo-tree',
          highlight = 'Directory',
          text_align = 'left',
        },
      },
    },
  },
}
