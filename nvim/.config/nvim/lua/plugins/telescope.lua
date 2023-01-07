return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function(plugin)
    local telescope = require("telescope")
    telescope.load_extension("fzf")
  end,
}
