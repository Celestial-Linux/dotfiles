local wezterm = require 'wezterm'
local wezterm_config_nvim = wezterm.plugin.require('https://github.com/winter-again/wezterm-config.nvim')

local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Mocha'
config.colors = {
    background = "#2c2a42"
}

config.webgpu_preferred_adapter = {
    backend = "Vulkan",
    device = 8710,
    device_type = "DiscreteGpu",
    driver = "NVIDIA",
    driver_info = "575.57.08",
    name = "NVIDIA GeForce RTX 3080",
    vendor = 4318,
}
config.front_end = "WebGpu"

config.enable_wayland = true
config.font = wezterm.font('Agave Nerd Font')
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.window_background_opacity = 0.5
-- config.text_background_opacity = 0.4
config.bold_brightens_ansi_colors = "BrightOnly"
-- config.dpi = 192.0
config.enable_kitty_keyboard = true

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

wezterm.on('user-var-changed', function(window, pane, name, value)
    local overrides = window:get_config_overrides() or {}
    overrides = wezterm_config_nvim.override_user_var(overrides, name, value)
    window:set_config_overrides(overrides)
end)

return config
