--- Lists the applications registered for the file's MIME type (as reported by
--- `gio mime`, Flatpaks included) and launches the chosen one with `gio launch`.

local KEYS = "123456789abcdefghijklmnopqrstuvwxyz"

local get_targets = ya.sync(function()
	local urls = {}
	for _, f in pairs(cx.active.selected) do
		urls[#urls + 1] = tostring(f.url)
	end
	local h = cx.active.current.hovered
	if #urls == 0 and h then
		urls[1] = tostring(h.url)
	end
	return urls
end)

local function data_dirs()
	local home = os.getenv("HOME")
	local dirs = { os.getenv("XDG_DATA_HOME") or (home .. "/.local/share") }
	for dir in (os.getenv("XDG_DATA_DIRS") or "/usr/local/share:/usr/share"):gmatch("[^:]+") do
		dirs[#dirs + 1] = dir
	end
	return dirs
end

-- Resolves a desktop ID to its file path and display name.
local function desktop_entry(id)
	for _, dir in ipairs(data_dirs()) do
		local path = dir:gsub("/$", "") .. "/applications/" .. id
		local f = io.open(path)
		if f then
			local name, in_entry = nil, false
			for line in f:lines() do
				if line:match("^%[") then
					in_entry = line == "[Desktop Entry]"
				elseif in_entry and not name then
					name = line:match("^Name=(.+)")
				end
			end
			f:close()
			return path, name or id
		end
	end
end

local function fail(msg)
	ya.notify { title = "Open with", content = msg, level = "error", timeout = 5 }
end

return {
	entry = function()
		local urls = get_targets()
		if #urls == 0 then
			return
		end

		local out = Command("file"):arg({ "-bL", "--mime-type", urls[1] }):output()
		local mime = out and out.stdout:gsub("%s+$", "")
		if not mime or mime == "" then
			return fail("Could not detect the MIME type")
		end

		out = Command("gio"):arg({ "mime", mime }):output()
		if not out or not out.status.success then
			return fail("`gio mime " .. mime .. "` failed")
		end

		local apps, section = {}, nil
		for line in out.stdout:gmatch("[^\n]+") do
			if line:match("^Registered applications:") then
				section = true
			elseif line:match("^%S") then
				section = false
			elseif section then
				local path, name = desktop_entry(line:match("^%s*(.-)%s*$"))
				if path and #apps < #KEYS then
					apps[#apps + 1] = { path = path, name = name }
				end
			end
		end
		if #apps == 0 then
			return fail("No applications registered for " .. mime)
		end

		local cands = {}
		for i, app in ipairs(apps) do
			cands[i] = { on = KEYS:sub(i, i), desc = app.name }
		end
		local idx = ya.which { cands = cands }
		if not idx then
			return
		end

		local _, err = Command("gio")
			:arg({ "launch", apps[idx].path })
			:arg(urls)
			:stdin(Command.NULL)
			:stdout(Command.NULL)
			:stderr(Command.NULL)
			:spawn()
		if err then
			fail("Failed to launch " .. apps[idx].name .. ": " .. tostring(err))
		end
	end,
}
