local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Palenight (Gogh)'
config.front_end = "WebGpu"
config.font = wezterm.font('Agave Nerd Font')
config.window_background_opacity = 0.8
config.hide_tab_bar_if_only_one_tab = true

local nushell = {'distrobox', 'enter', '--name', 'fedora', '--', '/usr/bin/nu', '-l'}
config.default_prog = nushell

config.launch_menu = {{
    args = {'top'}
}, {
    label = 'Bash',
    args = {'bash', '-l'}
}, {
    label = 'NuShell (DistroBox)',
    args = nushell
}}

config.keys = {{
    key = 'l',
    mods = 'ALT',
    action = wezterm.action.ShowLauncher
}}

return config
