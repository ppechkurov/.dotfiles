return {
  'kritag/k8s-yaml-schemas.nvim',
  event = 'FileType yaml',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('k8s-yaml-schemas').setup_autocmd()
  end,
}
