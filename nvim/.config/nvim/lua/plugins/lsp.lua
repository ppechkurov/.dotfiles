return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    ensure_installed = {
      "typescript-language-server",
      "apex-language-server",
      "prettier",
      "stylua",
      "eslint_d",
      "shellcheck",
    },

    config = function(plugin)
      require("mason").setup()
      local mr = require("mason-registry")
      for _, tool in ipairs(plugin.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },

  "onsails/lspkind.nvim",

  "b0o/SchemaStore.nvim",

  {
    "VonHeikemen/lsp-zero.nvim",
    event = "BufReadPost",

    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },

      -- Autocompletion
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },

      -- Snippets
      { "L3MON4D3/LuaSnip" },
      -- Snippet Collection (Optional)
      { "rafamadriz/friendly-snippets" },
    },

    config = function()
      local lsp = require("lsp-zero")
      lsp.preset("recommended")
      lsp.ensure_installed({
        "tsserver",
        "eslint",
        "sumneko_lua",
        "apex_ls",
        "jsonls",
      })

      -- Fix Undefined global 'vim'
      lsp.configure("sumneko_lua", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      lsp.setup_nvim_cmp(require("config.cmp"))

      lsp.configure("jsonls", {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      lsp.configure("apex_ls", {
        filetypes = { "st" },
        on_attach = function(client, bufnr)
          require("nvim-treesitter.parsers").filetype_to_parsername.st = "java"
          vim.cmd.TSEnable("highlight")
          vim.cmd.TSEnable("indent")
          vim.cmd.TSEnable("rainbow")

          --        vim.cmd([[
          -- 	augroup highlight_current_word
          -- 			au!
          -- 			au CursorHold * :exec 'match Search /\V\<' . expand('<cword>') . '\>/'
          -- 	augroup END
          -- ]]      )
        end,
        apex_enable_semantic_errors = true,
      })

      lsp.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }
        require("illuminate").on_attach(client)

        if client.server_capabilities.documentRangeFormattingProvider then
          vim.keymap.set("v", "gma", vim.lsp.formatexpr, opts)
        end

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>lf", function()
          vim.lsp.buf.format({ timeout_ms = 2000 })
        end, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
      end)

      lsp.setup()

      vim.diagnostic.config({
        virtual_text = true,
      })
    end,
  },

  -- null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    config = function()
      local nls = require("null-ls")
      nls.setup({
        sources = {
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.prettier,
          nls.builtins.formatting.prettier.with({ filetypes = { "st" } }),
          nls.builtins.diagnostics.eslint,
          nls.builtins.formatting.prettierd.with({
            filetypes = { "markdown" }, -- only runs `deno fmt` for markdown
          }),
        },
      })
    end,
  },
}
