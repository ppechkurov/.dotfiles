return {
  'esmuellert/codediff.nvim',
  cmd = 'CodeDiff',
  keys = {
    {
      '<leader>df',
      function()
        local current = vim.api.nvim_buf_get_name(0)
        local opts = {
          attach_mappings = function(_, map)
            map('i', '<CR>', function(prompt_bufnr)
              local actions = require('telescope.actions')
              local state = require('telescope.actions.state')
              local selection = state.get_selected_entry()
              actions.close(prompt_bufnr)
              if selection then
                vim.cmd('CodeDiff file ' .. current .. ' ' .. selection.path)
              end
            end)
            return true
          end,
        }
        require('telescope.builtin').find_files(opts)
      end,
      mode = 'n',
      desc = 'Diff current file with selected',
    },
  },
}
