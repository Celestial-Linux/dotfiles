hl.window_rule({
	name = "maximize-ignore",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "xwayland-drag-fix",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "wezterm-window-rule",
	match = { class = "org.wezfurlong.wezterm" },
	opacity = "1",
})

hl.window_rule({
	name = "easyeffects-window-rule",
	match = { class = "com.github.wwmm.easyeffects" },
	workspace = "special:magic",
})

hl.window_rule({
	name = "boatswain-window-rule",
	match = { class = "com.feaneron.Boatswain" },
	workspace = "special:magic",
})

hl.window_rule({
	name = "webcord-window-rule",
	match = { class = "WebCord" },
	workspace = "11",
})

hl.window_rule({
	name = "vesktop-window-rule",
	match = { class = "vesktop" },
	workspace = "11",
})

hl.window_rule({
	name = "fullscreen-rule-1",
	match = { fullscreen = 1 },
	immediate = true,
})

hl.window_rule({
	name = "fullscreen-rule-2",
	match = { fullscreen = 2 },
	immediate = true,
})

hl.window_rule({
	name = "floating-rule-1",
	match = { class = "floating" },
	float = true,
})

hl.window_rule({
	name = "floating-rule-2",
	match = { class = "it.mijorus.smile" },
	float = true,
})

hl.window_rule({
	name = "cuteview-window-rule-1",
	match = { class = "^(cuteview)$" },
	float = true,
	size = "500 800",
	center = true,
	no_blur = true,
	border_size = 0,
	decorate = false,
	focus_on_activate = false,
	no_focus = true,
	no_shadow = true,
	no_screen_share = true,
	no_follow_mouse = true,
	border_color = "rgba(00000000)",
	pin = true,
	suppress_event = "activate activatefocus fullscreen maximize",
	rounding = 0,
})

hl.layer_rule({
	name = "caelestia-no-anim",
	match = { namespace = "caelestia-(launcher|osd|notifications|border-exclusion|area-picker)" },
	no_anim = true,
})

hl.layer_rule({
	name = "caelestia-drawers-fade",
	match = { namespace = "caelestia-(drawers|background)" },
	animation = "fade",
})

hl.layer_rule({
	name = "caelestia-border-exclusion-order",
	match = { namespace = "caelestia-border-exclusion" },
	order = 1,
})

hl.layer_rule({
	name = "caelestia-bar-order",
	match = { namespace = "caelestia-bar" },
	order = 2,
})

hl.layer_rule({
	name = "caelestia-xray",
	match = { namespace = "caelestia-(border|launcher|bar|sidebar|navbar|mediadisplay|sc.*)" },
	xray = true,
})

hl.layer_rule({
	name = "caelestia-blur",
	match = { namespace = "caelestia-.*" },
	blur = true,
})

hl.layer_rule({
	name = "quickshell-blur",
	match = { namespace = "qs-.*" },
	blur = true,
})

hl.layer_rule({
	name = "caelestia-ignore-alpha",
	match = { namespace = "caelestia-.*" },
	ignore_alpha = 0.57,
})
