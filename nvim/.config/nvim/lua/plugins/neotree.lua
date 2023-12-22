return {
  "nvim-neo-tree/neo-tree.nvim",
  config = function(_, opts)
    opts.event_handlers = opts.event_handlers or {}
    vim.list_extend(opts.event_handlers, {
      {
        event = "file_opened",
        handler = function(file_path)
          -- auto close
          -- vimc.cmd("Neotree close")
          -- OR
          require("neo-tree.command").execute({ action = "close" })
        end,
      },
    })
    require("neo-tree").setup(opts)
  end,
  opts = {
    window = {
      position = "right",
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
      },
    },
    filesystem = {
      filtered_items = {
        always_show = {
          ".config",
          ".github",
        },
      },
    },
  },
}
