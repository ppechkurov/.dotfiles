return {
  "petertriho/nvim-scrollbar",
  config = function()
    require("scrollbar").setup({
      handle = { color = "#9e9e9e" },
      excluded_filetypes = { "alpha" },
    })
    require("scrollbar").setup({
      handle = { color = "#9e9e9e" },
      excluded_filetypes = { "alpha" },
    })
  end,
}
