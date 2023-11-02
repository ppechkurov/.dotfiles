return {
  "petertriho/nvim-scrollbar",
  config = function()
    -- add feature
    require("scrollbar").setup({
      handle = { color = "#9e9e9e" },
      excluded_filetypes = { "alpha" },
    })
    -- feature 1
  end,
}
