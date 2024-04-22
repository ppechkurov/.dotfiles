local M = {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    'williamboman/mason.nvim',
  },
}

function M.config()
  local servers = {
    'lua_ls',
    'html',
    'tsserver',
    'eslint',
    'bashls',
    'jsonls',
    'ansiblels',
    'marksman',
  }

  require('mason').setup({
    ui = { border = 'single' },
  })
  --
  -- require('mason-lspconfig').setup({
  --   ensure_installed = servers,
  -- })
end

return M

-- return {
--   "williamboman/mason.nvim",
--   cmd = "Mason",
--   keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
--   build = ":MasonUpdate",
--   opts = {
--     ensure_installed = {
--       "bash-language-server",
--       "eslint-lsp",
--       "js-debug-adapter",
--       "json-lsp",
--       "jsonlint",
--       "lua-language-server",
--       "prettier",
--       "prettierd",
--       "rust-analyzer",
--       "shfmt",
--       "sql-formatter",
--       "sqlls",
--       "stylua",
--       "typescript-language-server",
--       "yaml-language-server",
--     },
--   },
--
--   ---@param opts MasonSettings | {ensure_installed: string[]}
--   config = function(_, opts)
--     require("mason").setup(opts)
--     local mr = require("mason-registry")
--     mr:on("package:install:success", function()
--       vim.defer_fn(function()
--         -- trigger FileType event to possibly load this newly installed LSP server
--         require("lazy.core.handler.event").trigger({
--           event = "FileType",
--           buf = vim.api.nvim_get_current_buf(),
--         })
--       end, 100)
--     end)
--     local function ensure_installed()
--       for _, tool in ipairs(opts.ensure_installed) do
--         local p = mr.get_package(tool)
--         if not p:is_installed() then
--           p:install()
--         end
--       end
--     end
--     if mr.refresh then
--       mr.refresh(ensure_installed)
--     else
--       ensure_installed()
--     end
--   end,
-- }

--return {
--  "neovim/nvim-lspconfig",
--  ---@class PluginLspOpts
--  opts = {
--    servers = {
--      tsserver = {
--        root_dir = require("lspconfig.util").root_pattern(".git"),
--        init_options = {
--          preferences = {
--            importModuleSpecifierPreference = "relative", -- relative path import
--            -- importModuleSpecifierEnding = "minimal",   -- remove .js from import
--          },
--        },
--      },
--    },
--  },
--}
