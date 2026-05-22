local autostart_preset = {
	{ name = "Trivalent", workspace = "1", command = "trivalent" },
	{ name = "Kitty", workspace = "2", command = "kitty" },
	{ name = "Zed", workspace = "3", command = "zed" },
	{
		name = "Apple Music",
		workspace = "4",
		command = "/usr/lib64/trivalent/trivalent.sh --profile-directory=Default --app-id=blgdilankhbcpipclgpdndahbehalgkh",
	},
	{ name = "Discord", workspace = "11", command = "flatpak run com.discordapp.Discord" },
	{
		name = "WhatsApp Web",
		workspace = "12",
		command = "/usr/lib64/trivalent/trivalent.sh --profile-directory=Default --app-id=hnpfjngllnobngcgfapefoaidbinmjnm",
	},
}

local function shell_quote(value)
	return "'" .. tostring(value):gsub("'", "'\"'\"'") .. "'"
end

local function notify_launch_failure_command(app)
	return "notify-send --app-name=Hyprland --urgency=critical "
		.. shell_quote("Autostart failed: " .. app.name)
		.. " "
		.. shell_quote("Workspace " .. app.workspace .. ": " .. app.command)
end

local function launch_command(app)
	return "sh -c "
		.. shell_quote("uwsm app -- " .. app.command .. " || " .. notify_launch_failure_command(app))
end

local function launch_on_workspace(app)
	hl.dispatch(hl.dsp.exec_cmd("[workspace " .. app.workspace .. " silent] " .. launch_command(app)))
end

local function launch_autostart_preset()
	for _, app in ipairs(autostart_preset) do
		launch_on_workspace(app)
	end
end

local function autostart_marker_path()
	local runtime_dir = os.getenv("XDG_RUNTIME_DIR")
	local signature = os.getenv("HYPRLAND_INSTANCE_SIGNATURE")

	if runtime_dir == nil or signature == nil then
		return nil
	end

	return runtime_dir .. "/hypr/" .. signature .. "/autostart-preset"
end

local function marker_exists(path)
	local marker = io.open(path, "r")

	if marker == nil then
		return false
	end

	marker:close()
	return true
end

local function mark_autostart_preset(path)
	local marker = io.open(path, "w")

	if marker == nil then
		return
	end

	marker:write("started\n")
	marker:close()
end

local function launch_autostart_preset_once()
	local marker_path = autostart_marker_path()

	if marker_path ~= nil then
		if marker_exists(marker_path) then
			return
		end

		mark_autostart_preset(marker_path)
	end

	launch_autostart_preset()
end

hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm finalize")
	hl.exec_cmd("caelestia shell -d")
	hl.exec_cmd("uwsm app -- flatpak run --command=easyeffects com.github.wwmm.easyeffects --gapplication-service")
	hl.timer(launch_autostart_preset_once, { timeout = 1000, type = "oneshot" })
end)
