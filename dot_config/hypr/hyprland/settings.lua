hl.config({
	general = {
		gaps_in = 6,
		gaps_out = 18,
		gaps_workspaces = 20,
		border_size = 2,
		col = {
			active_border = "rgba(b4b1aa20)",
			inactive_border = "rgba(b4b1aa20)",
		},
		resize_on_border = true,
		allow_tearing = true,
		layout = "dwindle",
		snap = {
			enabled = true,
		},
	},

	debug = {
		disable_logs = false,
	},

	cursor = {
		no_hardware_cursors = true,
	},

	decoration = {
		rounding = 15,
		shadow = {
			enabled = true,
			range = 12,
			render_power = 8,
			color = "rgba(13131722)",
			-- offset = { 1.4, 1.4 },
		},
		blur = {
			enabled = true,
			size = 2,
			passes = 3,
			new_optimizations = true,
			vibrancy = 0.1996,
			contrast = 0.8,
			brightness = 0.8,
			noise = 0.0617,
		},
	},

	render = {
		direct_scanout = 2,
		cm_auto_hdr = 2,
	},

	ecosystem = {
		no_donation_nag = true,
		enforce_permissions = true,
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		middle_click_paste = false,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		vrr = 0,
		enable_anr_dialog = false,
	},

	input = {
		kb_layout = "us",
		kb_variant = "altgr-intl",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = -0.70,
		accel_profile = "flat",
		touchpad = {
			natural_scroll = false,
		},
	},
})
