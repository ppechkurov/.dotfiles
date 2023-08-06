return {
  'echasnovski/mini.files',
  version = false,
  config = function()
    require('mini.files').setup {
      mappings = {
        go_in = 'L',
        go_in_plus = 'l',
      },
      -- Customization of explorer windows
      windows = {
        -- Maximum number of windows to show side by side
        max_number = 3,
        -- Whether to show preview of file/directory under cursor
        preview = true,
        -- Width of focused window
        width_focus = 25,
        -- Width of non-focused window
        width_nofocus = 15,
        -- Width of preview window
        width_preview = 80,
      },
    }
  end,
}
