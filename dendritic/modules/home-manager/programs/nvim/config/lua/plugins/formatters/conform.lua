return {
  'stevearc/conform.nvim',
  ---@class ConformOpts
  opts = {
    -- log_level = vim.log.levels.DEBUG,
    formatters = {
      sql_formatter = {
        prepend_args = { '--language', 'mysql' },
      },
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
      ['terraform-vars'] = { 'tofu_fmt' },
      asm = { 'nasmfmt' },
      c = { 'clang-format' },
      go = { 'goimports', 'gofumpt' },
      hcl = { 'hcl' },
      javascript = { 'prettierd' },
      json = { 'prettierd' },
      jsonc = { 'prettierd' },
      kdl = { 'kdlfmt' },
      lua = { 'stylua' },
      markdown = { 'markdownlint' },
      -- markdown = { 'prettierd' },
      nix = { 'nixfmt' },
      odin = { 'odinfmt' },
      rust = { 'rustfmt' },
      sh = { 'shfmt' },
      sql = { 'sql_formatter' },
      terraform = { 'tofu_fmt' },
      typescript = { 'biome', 'prettierd' },
      -- typescript = { 'prettierd' },
      zig = { 'zigfmt' },
      zsh = { 'shfmt' },
    },
  },
}
