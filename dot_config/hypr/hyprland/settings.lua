hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 18,
		gaps_workspaces = 20,
		border_size = 1,
		col = {
			active_border = "rgba(d4cddce6)",
			inactive_border = "rgba(88abcb80)",
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
			range = 10,
			render_power = 8,
			color = "rgba(13131740)",
		},
		blur = {
			enabled = true,
			size = 4,
			passes = 3,
			new_optimizations = true,
			vibrancy = 0.1696,
			brightness = 0.8,
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
