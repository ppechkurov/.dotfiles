return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "apex-language-server",
        "typescript-language-server",
        "prettier",
        "stylua",
        "eslint_d",
        "shfmt",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type lspconfig.options
      servers = {
        cssls = {},
        tsserver = {},
        eslint = {},
        html = {},
        apex_ls = {
          filetypes = { "st" },
          apex_enable_semantic_errors = true,
          on_attach = function(client, bufnr)
            require("nvim-treesitter.parsers").filetype_to_parsername.st = "java"
            vim.cmd.TSEnable("highlight")
            vim.cmd.TSEnable("indent")
            vim.cmd.TSEnable("rainbow")
          end,
        },
      },
      format = {
        timeout_ms = 2000,
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local nls = require("null-ls")
      nls.setup({
        debounce = 150,
        save_after_format = false,
        sources = {
          nls.builtins.formatting.prettier,
          nls.builtins.formatting.prettier.with({ filetypes = { "st" } }),
          nls.builtins.formatting.stylua,
          -- nls.builtins.formatting.fixjson.with({ filetypes = { "jsonc" } }),
          -- nls.builtins.formatting.eslint_d,
          -- nls.builtins.diagnostics.shellcheck,
          nls.builtins.formatting.shfmt,
          nls.builtins.diagnostics.markdownlint,
          -- nls.builtins.diagnostics.luacheck,
          -- nls.builtins.code_actions.gitsigns,
        },
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git"),
      })
    end,
  },
}
