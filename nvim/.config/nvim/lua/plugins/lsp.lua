return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    ensure_installed = {
      "tsserver",
      "prettierd",
      "stylua",
      "luacheck",
      "eslint_d",
      "shellcheck",
    },
  },
  "onsails/lspkind.nvim",
  {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      -- Snippet Collection (Optional)
      {'rafamadriz/friendly-snippets'},
    },

    event = "BufReadPost",

    config = function()
      local lsp = require('lsp-zero')
      lsp.preset('recommended')
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

      lsp.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }
        if client.name ~= "apex_ls" then
          require("illuminate").on_attach(client)
        end

        if client.server_capabilities.documentRangeFormattingProvider then
          vim.keymap.set("v", "gma", vim.lsp.formatexpr, opts)
        end

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
      end)

      lsp.setup()
    end,
  }
}

