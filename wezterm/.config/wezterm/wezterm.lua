local wezterm = require("wezterm")

local config = wezterm.config_builder()

config = {

  -- color
	font_size = 16,
	font = wezterm.font("IosevkaTerm Nerd Font"),
	color_scheme = "Catppuccin Macchiato",

	use_fancy_tab_bar = false,
	window_decorations = "RESIZE",
	window_padding = {
		left = 20,
		right = 20,
		bottom = 5,
		top = 10,
	},

  default_prog = { 'nu' },
}

-- keyboard binding

local act = wezterm.action
config.keys = {
	{ key = "w", mods = "ALT", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "t", mods = "ALT", action = act.SpawnTab "DefaultDomain" },
}

for i = 1, 8 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "ALT",
		action = act.ActivateTab(i - 1),
	})
end

return config
