vim.keymap.set("n", "-", "<cmd>Oil --float<cr>", { desc = "Open parent directory" })

return {
  "stevearc/oil.nvim",
  opts = {
    float = {
      max_height = 20,
      max_width = 40,
    },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
