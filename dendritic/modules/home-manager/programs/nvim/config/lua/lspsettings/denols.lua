return {
  -- deno = {
  root_dir = require('lspconfig.util').root_pattern('deno.json', 'deno.jsonc'),
  unstable = true,
  lint = false,
  inlayHints = {
    parameterNames = { enabled = 'all', suppressWhenArgumentMatchesName = true },
    parameterTypes = { enabled = true },
    variableTypes = { enabled = true, suppressWhenTypeMatchesName = true },
    propertyDeclarationTypes = { enabled = true },
    functionLikeReturnTypes = { enable = true },
    enumMemberValues = { enabled = true },
  },
  -- },
}
