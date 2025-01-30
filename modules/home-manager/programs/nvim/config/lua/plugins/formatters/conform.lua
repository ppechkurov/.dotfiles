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
    formatters_by_ft = {
      go = { 'goimports', 'gofumpt' },
      javascript = { 'prettierd' },
      json = { 'prettierd' },
      jsonc = { 'prettierd' },
      lua = { 'stylua' },
      markdown = { 'prettierd' },
      nix = { 'nixfmt' },
      sh = { 'shfmt' },
      sql = { 'sql_formatter' },
      typescript = { 'prettierd' },
      terraform = { 'tofu_fmt' },
      ['terraform-vars'] = { 'tofu_fmt' },
      zsh = { 'shfmt' },
      zig = { 'zls' },
    },
  },
}
