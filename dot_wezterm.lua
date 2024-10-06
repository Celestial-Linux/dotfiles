local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Palenight (Gogh)'
config.front_end = "WebGpu"
config.font = wezterm.font('Agave Nerd Font')
config.window_background_opacity = 0.8
return config