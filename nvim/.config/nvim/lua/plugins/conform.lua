return {
  "stevearc/conform.nvim",
  ---@class ConformOpts
  opts = {
    ---@type table<string, conform.FormatterUnit[]>
    formatters_by_ft = {
      zsh = { "shfmt" },
    },
  },
}
