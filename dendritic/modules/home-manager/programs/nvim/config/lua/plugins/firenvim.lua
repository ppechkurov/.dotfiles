local M = {
  {
    "glacambre/firenvim",

    -- Lazy load firenvim
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    lazy = not vim.g.started_by_firenvim,
    build = function()
      vim.fn["firenvim#install"](0)
    end,
  },
}

if vim.g.started_by_firenvim == true then
  vim.o.laststatus = 0
  vim.o.guifont = "CaskaydiaCove Nerd Font:h12"

  table.insert(M, { "folke/noice.nvim", enabled = false })
  table.insert(M, { "nvimdev/dashboard-nvim", enabled = false })
  table.insert(M, { "nvim-lualine/lualine.nvim", enabled = false })
  table.insert(M, { "folke/tokyonight.nvim", opts = { transparent = false, style = "day" } })
end

return M
