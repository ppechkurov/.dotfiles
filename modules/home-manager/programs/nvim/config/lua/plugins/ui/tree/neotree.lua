return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = function(_, opts)
    local wk = require('which-key')
    wk.register({
      ['<leader>e'] = { ':Neotree show toggle<cr>', 'File Tree' },
    })
    opts.event_handlers = opts.event_handlers or {}
    vim.list_extend(opts.event_handlers, {
      {
        event = 'file_opened',
        handler = function(file_path)
          -- auto close
          -- vimc.cmd("Neotree close")
          -- OR
          -- require('neo-tree.command').execute({ action = 'close' })
        end,
      },
    })
    require('neo-tree').setup(opts)
  end,
  opts = {
    close_if_last_window = true,
    window = {
      position = 'left',
      width = 30,
      mappings = {
        ['l'] = 'open',
        ['h'] = 'close_node',
      },
    },
    filesystem = {
      bind_to_cwd = true,
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      filtered_items = {
        always_show = {
          '.config',
          '.github',
        },
      },
    },
  },
}
