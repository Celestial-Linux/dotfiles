local lg_monitor = "desc:LG Electronics 27GL650F 0x00059204"
local acer_monitor = "desc:Acer Technologies K202HQL T0CAA0028519"

for workspace = 1, 10 do
	hl.workspace_rule({
		workspace = tostring(workspace),
		persistent = true,
		monitor = lg_monitor,
		default = workspace == 1,
	})
end

for workspace = 11, 20 do
	hl.workspace_rule({
		workspace = tostring(workspace),
		persistent = true,
		monitor = acer_monitor,
		default = workspace == 11,
	})
end
