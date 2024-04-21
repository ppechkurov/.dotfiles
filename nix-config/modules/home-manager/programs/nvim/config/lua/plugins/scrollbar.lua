return {
  "petertriho/nvim-scrollbar",
  config = function()
    require("scrollbar").setup({
      handle = { color = "#9e9e9e" },
      excluded_filetypes = { "alpha", "noice", "cmp_docs", "cmp_menu", "prompt", "TelescopePrompt" },
    })
  end,
}
