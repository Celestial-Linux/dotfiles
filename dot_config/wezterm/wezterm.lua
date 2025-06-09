local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Macchiato'
config.front_end = "OpenGL"
config.enable_wayland = true
config.font = wezterm.font('Agave Nerd Font')
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.window_background_opacity = 0.5

config.hide_tab_bar_if_only_one_tab = true

local nushell = { '/usr/bin/nu', '-l' }
config.default_prog = nushell

config.launch_menu = { {
    label = 'NuShell (Host)',
    args = nushell
}, {
    label = 'NuShell (Arch DistroBox)',
    args = { 'distrobox', 'enter', '--name', 'arch', '--', '/usr/bin/nu', '-l' }
}, {
    label = 'fastfetch',
    args = { 'bash', '-c', '~/.local/bin/runfetch.sh' }
} }

config.keys = { {
    key = 'l',
    mods = 'ALT',
    action = wezterm.action.ShowLauncher
} }

return config
