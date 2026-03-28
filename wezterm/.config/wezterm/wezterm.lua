local wezterm = require("wezterm")

local config = wezterm.config_builder()

config = {

  -- color
  font_size = 16,
  -- font = wezterm.font("IosevkaTerm Nerd Font"),
  font = wezterm.font_with_fallback({
    -- 1. 优先使用 Iosevka Term (处理英文和代码符号)
    { family = 'Sarasa Term SC', weight = 'Regular' },

    -- 2. 其次使用 霞鹜文楷 (处理中文)
    { family = 'LXGW WenKai',            weight = 'Regular' },

    -- 3. 最后使用 Noto Sans CJK SC (处理冷僻字或兜底)
    { family = 'Noto Sans CJK SC',       weight = 'Regular' },
  }),
  color_scheme = "Catppuccin Macchiato",

  use_fancy_tab_bar = false,
  window_decorations = "NONE",
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
