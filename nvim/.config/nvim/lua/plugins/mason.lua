return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    servers = {
      tsserver = {
        root_dir = require("lspconfig.util").root_pattern(".git"),
      },
    },
  },
}
