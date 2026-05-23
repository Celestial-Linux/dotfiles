local lg_monitor = "desc:LG Electronics 27GL650F 0x00059204"
local acer_monitor = "desc:Acer Technologies K202HQL T0CAA0028519"

local lg_workspace_layouts = {
	[1] = "scrolling",
	[2] = "master",
	[3] = "master",
	[9] = "monocle",
}

local workspace_default_names = {
	[1] = "browser",
	[2] = "terminal",
	[3] = "code",
	[4] = "music",
	[11] = "discord",
	[12] = "whatsapp",
}

for workspace = 1, 10 do
	hl.workspace_rule({
		workspace = tostring(workspace),
		persistent = true,
		monitor = lg_monitor,
		default = workspace == 1,
		default_name = workspace_default_names[workspace],
		layout = lg_workspace_layouts[workspace] or "dwindle",
	})
end

for workspace = 11, 20 do
	hl.workspace_rule({
		workspace = tostring(workspace),
		persistent = true,
		monitor = acer_monitor,
		default = workspace == 11,
		default_name = workspace_default_names[workspace],
		layout = "monocle",
	})
end
