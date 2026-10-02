return {
  'ldelossa/gh.nvim',
  cmd = 'GH',
  dependencies = {
    {
      'ldelossa/litee.nvim',
      config = function()
        require('litee.lib').setup()
      end,
    },
  },
  config = function()
    require('litee.gh').setup()
  end,
}
