return {
  'stevearc/conform.nvim',
  ---@class ConformOpts
  opts = {
    -- log_level = vim.log.levels.DEBUG,
    formatters = {
      nasmfmt = {
        inherit = false,
        command = 'nasmfmt',
        args = { '-' }, -- to read from stdin. source: https://github.com/yamnikov-oleg/nasmfmt/blob/e010ffea9224f500c3d18e64329e079cf71f0e85/main.go#L220
      },
    },
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
      typescript = { 'biome' },
      terraform = { 'tofu_fmt' },
      hcl = { 'hcl' },
      ['terraform-vars'] = { 'tofu_fmt' },
      zsh = { 'shfmt' },
      zig = { 'zls' },
      asm = { 'nasmfmt' },
    },
  },
}
