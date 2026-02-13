return {
  settings = {
    yaml = {
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin and its advanced options like `ignore`.
        enable = false,
        validate = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        -- url = '',
      },
      schemas = require('schemastore').yaml.schemas(),
      -- schemas = {
      --   kubernetes = 'k8s-*.{yml,yaml}',
      --   ['http://json.schemastore.org/github-workflow'] = '.github/workflows/*',
      --   ['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
      --   ['http://json.schemastore.org/kustomization'] = 'kustomization.{yml,yaml}',
      -- },
    },
  },
}
