return {
  'stevearc/oil.nvim',
  opts = {
    columns = { 'permissions', { 'ctime', format = '%Y/%m/%d %H:%M:%S' }, 'size', 'icon' },
    keymaps = {
      ['gh'] = 'actions.toggle_hidden',
    },
  },
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
