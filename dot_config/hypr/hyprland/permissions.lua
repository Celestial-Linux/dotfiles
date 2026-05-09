for _, permission in ipairs({
	{ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" },
	{ binary = "/usr/bin/grim", type = "screencopy", mode = "allow" },
	{ binary = "/usr/bin/hyprlock", type = "screencopy", mode = "allow" },
	{ binary = "/usr/bin/hyprpicker", type = "screencopy", mode = "allow" },
	{ binary = "/usr/bin/quickshell", type = "screencopy", mode = "allow" },
}) do
	hl.permission(permission)
end
