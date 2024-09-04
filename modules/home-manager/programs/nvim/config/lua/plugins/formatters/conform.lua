return {
  'stevearc/conform.nvim',
  ---@class ConformOpts
  opts = {
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 1000, lsp_format = 'fallback' }
    end,
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
      nix = { 'nixfmt' },
      go = { 'gofmt', 'goimports' },
    },
  },
}
