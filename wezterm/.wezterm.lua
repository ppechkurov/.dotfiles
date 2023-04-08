local wezterm = require("wezterm")
return {
	font = wezterm.font("CaskaydiaCove Nerd Font"),
	font_size = 18,
	color_scheme = "Gruvbox Dark",
	enable_scroll_bar = true,
	audible_bell = "Disabled",
	default_cwd = "/home/pp/projects/",
	window_close_confirmation = "NeverPrompt",
	window_background_opacity = 0.95,
	window_padding = {
		left = 2,
		right = 2,
		top = 2,
		bottom = 2,
	},
	-- tab bar
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = true,
	switch_to_last_active_tab_when_closing_tab = true,
	-- keys
	keys = {
		{ key = "z", mods = "ALT", action = wezterm.action.ShowLauncher },
		{ key = "h", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "w", mods = "CTRL", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	},
	-- inactive pane hsb
	inactive_pane_hsb = {
		saturation = 0.8,
		brightness = 0.4,
	},
}
