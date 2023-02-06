return {
  "jackMort/ChatGPT.nvim",
  cmd = "ChatGPT",
  init = function()
    require("chatgpt").setup({
      -- optional configuration
    })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
}
