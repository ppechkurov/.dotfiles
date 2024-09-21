return {
  settings = {
    gopls = {
      ['ui.inlayhint.hints'] = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        constantValues = true,
        parameterNames = true,
      },
    },
  },
  setup = {},
}
