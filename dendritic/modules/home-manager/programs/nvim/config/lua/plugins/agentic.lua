vim.print('[agentic.nvim] Loading...')

return {
  'carlos-algms/agentic.nvim',

  config = function()
    local Config = require('agentic.config')
    Config.provider = 'opencode-acp'
    Config.acp_providers['opencode-acp'] = {
      name = 'OpenCode ACP',
      command = '/home/petrp/.npm-global/bin/opencode',
      args = { 'acp' },
      env = {
        OPENCODE_MODEL = 'minimax/MiniMax-M2.5-Free',
      },
    }
    vim.print('[agentic.nvim] Loaded with custom config')
  end,

  opts = {
    provider = 'opencode-acp',
    acp_providers = {
      ['opencode-acp'] = {
        command = '/home/petrp/.npm-global/bin/opencode',
        args = { 'acp' },
      },
    },
  },

  keys = {
    {
      '<C-\\>',
      function()
        require('agentic').toggle()
      end,
      mode = { 'n', 'v', 'i' },
      desc = 'Toggle Agentic Chat',
    },
    {
      "<C-'>",
      function()
        require('agentic').add_selection_or_file_to_context()
      end,
      mode = { 'n', 'v' },
      desc = 'Add file or selection to Agentic to Context',
    },
    {
      '<C-,>',
      function()
        require('agentic').new_session()
      end,
      mode = { 'n', 'v', 'i' },
      desc = 'New Agentic Session',
    },
    {
      '<A-i>r', -- ai Restore
      function()
        require('agentic').restore_session()
      end,
      desc = 'Agentic Restore session',
      silent = true,
      mode = { 'n', 'v', 'i' },
    },
    {
      '<leader>ad', -- ai Diagnostics
      function()
        require('agentic').add_current_line_diagnostics()
      end,
      desc = 'Add current line diagnostic to Agentic',
      mode = { 'n' },
    },
    {
      '<leader>aD', -- ai all Diagnostics
      function()
        require('agentic').add_buffer_diagnostics()
      end,
      desc = 'Add all buffer diagnostics to Agentic',
      mode = { 'n' },
    },
  },
}
