--- @param action function
local function exec_action(action, opts)
  local dir = require('utils').get_root_dir()
  action(dir, opts)
end

return {
  {
    'stevearc/resession.nvim',
    config = function()
      local resession = require('resession')
      resession.setup()

      resession.add_hook('pre_save', function()
        -- Need to close neo-tree before saving session, because it's not
        -- possible to restore it properly when closing with :q
        require('neo-tree.command').execute({ action = 'close' })
      end)

      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
          exec_action(resession.save)
        end,
      })

      vim.keymap.set('n', '<leader>ss', function(_, opts)
        exec_action(resession.save, opts)
      end)

      vim.keymap.set('n', '<leader>ls', function(_, opts)
        exec_action(resession.load, opts)
        require('neo-tree.command').execute({ action = 'show' })
      end)

      vim.keymap.set('n', '<leader>sd', resession.delete)
    end,
  },
}
