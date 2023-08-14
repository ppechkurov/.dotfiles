return {
  'echasnovski/mini.files',
  opts = {
    windows = {
      max_number = 3, -- maximum number of windows to show side by side
      preview = true, -- whether to show preview of file/directory under cursor
      width_focus = 25, -- width of focused window
      width_nofocus = 15, -- width of non-focused window
      width_preview = 80, -- width of preview window
    },
    mappings = {
      go_in = 'L',
      go_in_plus = 'l',
    },
  },

  config = function(_, opts)
    require('mini.files').setup(opts)

    local show_dotfiles = true
    local filter_show = function(fs_entry)
      return true
    end
    local filter_hide = function(fs_entry)
      return not vim.startswith(fs_entry.name, '.')
    end

    local toggle_dotfiles = function()
      show_dotfiles = not show_dotfiles
      local new_filter = show_dotfiles and filter_show or filter_hide
      require('mini.files').refresh { content = { filter = new_filter } }
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        local buf_id = args.data.buf_id
        -- Tweak left-hand side of mapping to your liking
        vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id })
      end,
    })
  end,
}
