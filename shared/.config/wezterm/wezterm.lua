local wezterm = require("wezterm")
local config = {}

config = {
	font = wezterm.font("JetBrainsMono Nerd Font"),
	font_size = 18,
	color_scheme = "Catppuccin Frappe",
	colors = {
		background = "2B2E3D",
	},
	line_height = 1.2,
	enable_scroll_bar = false,
	window_decorations = "RESIZE",
	enable_tab_bar = false,
	show_tabs_in_tab_bar = false,
	use_fancy_tab_bar = false,
}

config.window_padding = {
	left = 6,
	right = 6,
	top = 6,
	bottom = 2,
}

return config
