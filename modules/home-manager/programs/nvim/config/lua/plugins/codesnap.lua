return {
  'mistricky/codesnap.nvim',
  build = 'make',
  opts = {
    save_path = '~/Pictures/screenshot/snap.png',
    bg_x_padding = 10,
    bg_y_padding = 10,
    mac_window_bar = false,
    has_breadcrumbs = true,
    has_line_number = true,
    show_workspace = true,
  },
}
