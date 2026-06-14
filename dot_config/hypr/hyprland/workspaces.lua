local lg_monitor = "desc:LG Electronics 27GL650F 0x00059204"
local acer_monitor = "desc:Acer Technologies K202HQL T0CAA0028519"

hl.layout.register("dashboardy", {
	recalculate = function(ctx)
		local area = ctx.area

		local left = ctx:split(area, "left", 0.336)
		local right = ctx:split(area, "right", 0.664)

		local cal_area = ctx:split(left, "top", 0.70)
		local clock_area = ctx:split(left, "bottom", 0.30)

		local top_row = ctx:split(right, "top", 0.45)
		local today_area = ctx:split(right, "bottom", 0.55)

		local art_area = ctx:split(top_row, "left", 0.5)
		local goals_area = ctx:split(top_row, "right", 0.5)

		local placements = {
			calendar = cal_area,
			clock = clock_area,
			art = art_area,
			goals = goals_area,
			today = today_area,
		}

		for _, target in ipairs(ctx.targets) do
			local window = target.window
			local title = window and window.title or nil
			local box = title and placements[title] or today_area
			target:place(box)
		end
	end,
})

local lg_workspace_layouts = {
	[1] = "scrolling",
	[2] = "master",
	[3] = "master",
	[5] = "lua:dashboardy",
	[9] = "monocle",
}

local workspace_default_names = {
	[1] = "browser",
	[2] = "terminal",
	[3] = "code",
	[4] = "music",
	[5] = "dashboard",
	[9] = "game",
	[11] = "discord",
	[12] = "whatsapp",
}

hl.config({ scrolling = { column_width = 0.9 } })

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
