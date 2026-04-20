return {
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  lazy = true,
  event = {
    ('BufReadPre ' .. vim.fn.expand('~') .. '/obsidian/**.md'),
    ('BufNewFile ' .. vim.fn.expand('~') .. '/obsidian/**.md'),
  },
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = 'work',
        path = '~/obsidian',
      },
    },
  },
}
