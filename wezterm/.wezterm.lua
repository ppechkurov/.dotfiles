local wezterm = require("wezterm")
return {
  font = wezterm.font("CaskaydiaCove Nerd Font"),
  font_size = 18,
  color_scheme = "Gruvbox Dark",
  default_cwd = "/home/pp/projects/",
  keys = { { key = "z", mods = "ALT", action = wezterm.action.ShowLauncher } },
  window_background_opacity = 0.85,
  enable_scroll_bar = true,
  default_prog = { "zsh" },
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
}
