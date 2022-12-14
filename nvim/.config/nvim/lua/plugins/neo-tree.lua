return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
  end,
  config = {
    filesystem = {
      follow_current_file = true,
      hijack_netrw_behavior = "open_current",
    },
    window = {
      position = "right",
      mappings = {
        ["l"] = "open",
        ["h"] = "open",
      }
    },
  },
}
