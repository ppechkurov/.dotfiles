return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    servers = {
      tsserver = {
        root_dir = require("lspconfig.util").root_pattern(".git"),
        init_options = {
          preferences = {
            importModuleSpecifierPreference = "relative", -- relative path import
            -- importModuleSpecifierEnding = "minimal", -- remove .js from import
          },
        },
      },
    },
  },
}
