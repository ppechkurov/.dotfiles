return {
  root_dir = require('lspconfig.util').root_pattern('.git'),
  init_options = {
    preferences = {
      importModuleSpecifierPreference = 'non-relative', -- relative path import
      -- importModuleSpecifierEnding = "minimal",   -- remove .js from import
    },
  },
}
