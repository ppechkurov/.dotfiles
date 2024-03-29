return {
  'stevearc/conform.nvim',
  ---@class ConformOpts
  opts = {
    format_on_save = { timeout_ms = 500, lsp_fallback = true },
    ---@type table<string, conform.FormatterUnit[]>
    formatters_by_ft = {
      lua = { 'stylua' },
      zsh = { 'shfmt' },
      sh = { 'shfmt' },
      sql = { 'sql_formatter' },
      markdown = { 'prettierd' },
      typescript = { 'prettierd' },
      javascript = { 'prettierd' },
      json = { 'prettierd' },
    },
  },
}
