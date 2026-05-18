local terminal = "kitty"
local file_manager = "kitty yazi"
local menu = "caelestia shell drawers toggle launcher"
local browser = "trivalent"
local color_picker = "hyprpicker --autocopy"
local screenshot_window = "hyprshot -m window"
local screenshot_monitor = "hyprshot -m output"
local screenshot_region = "hyprshot -m region"
local runfetch = "kitty --class floating -- /var/home/celeste/.local/bin/fetch"
local emoji_picker = "flatpak run it.mijorus.smile"
local exit = "uwsm stop"

local main_mod = "SUPER"
local shift_mod = "SHIFT"

local function uwsm_app(command)
	return hl.dsp.exec_cmd("uwsm app -- " .. command)
end

local function turn_off_screens()
	hl.timer(function()
		hl.dispatch(hl.dsp.dpms({ action = "disable" }))
	end, { timeout = 500, type = "oneshot" })
end

hl.bind(main_mod .. " + Return", uwsm_app(terminal))
hl.bind(main_mod .. " + SHIFT + Return", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + I", hl.dsp.exec_cmd(runfetch))
hl.bind(main_mod .. " + C", uwsm_app(browser))
hl.bind(main_mod .. " + SHIFT + C", uwsm_app(color_picker))
hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(main_mod .. " + SHIFT + Q", hl.dsp.window.kill())
hl.bind(main_mod .. " + M", hl.dsp.exec_cmd(exit))
hl.bind(main_mod .. " + E", uwsm_app(file_manager))
hl.bind(main_mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + Space", uwsm_app(menu))
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo())
hl.bind(main_mod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(main_mod .. " + period", hl.dsp.exec_cmd(emoji_picker))
hl.bind(main_mod .. " + SHIFT + O", turn_off_screens, { locked = true })
hl.bind(main_mod .. " + SHIFT + Z", hl.dsp.global("caelestia:screenshotFreeze"))

hl.bind(main_mod .. " + Print", hl.dsp.exec_cmd(screenshot_window))
hl.bind(shift_mod .. " + Print", hl.dsp.exec_cmd(screenshot_monitor))
hl.bind("Print", hl.dsp.exec_cmd(screenshot_region))

hl.bind(main_mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + down", hl.dsp.focus({ direction = "down" }))

for _, key in ipairs({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }) do
	hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = "r~" .. key, on_current_monitor = true }))
	hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = "r~" .. key }))
end

hl.bind(main_mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(main_mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "r-1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(main_mod .. " + SHIFT + mouse_down", hl.dsp.focus({ monitor = "-1" }))
hl.bind(main_mod .. " + SHIFT + mouse_up", hl.dsp.focus({ monitor = "+1" }))
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("SUPER + SHIFT + Left", hl.dsp.global(":prev_suggestion"))
hl.bind("SUPER + SHIFT + Right", hl.dsp.global(":next_suggestion"))
hl.bind("SUPER + SHIFT + M", hl.dsp.global(":cycle_copilot_model"))
hl.bind("SUPER + SHIFT + C", hl.dsp.global(":clear_copilot_context"))
hl.bind("SUPER + SHIFT + W", hl.dsp.global(":close_app"))
hl.bind("SUPER + SHIFT + X", hl.dsp.global(":toggle_ui_visibility"))
