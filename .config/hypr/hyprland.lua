-- Hyprland configuration (Lua format)
--
-- Ported from the legacy .conf format, which Hyprland 0.56 deprecated:
--   "You are using the .conf config format, support for which will be
--    removed in Hyprland 0.57."
--
-- Sources merged into this single file:
--   hyprland.conf + windows.conf + shortcuts.conf
-- (monitor.conf / monitors.conf were NOT sourced by hyprland.conf and are
--  therefore not included here -- the active monitor config was the single
--  `monitor=,preferred,auto,1` line in hyprland.conf.)
--
-- API reference: /usr/share/hypr/stubs/hl.meta.lua
-- Example config: /usr/share/hypr/hyprland.lua

------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1, -- from `monitor=,preferred,auto,1`; NOT "auto" (that picks 1.5 here)
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "foot"
local fileManager = "thunar"
local menu = "wofi --show drun"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("waybar & ~/.config/hypr/scripts/hyprpaper-launch.sh")
	hl.exec_cmd("gammastep -O 3400")
	hl.exec_cmd("dunst")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("~/.config/hypr/lid-watcher.sh")
	hl.exec_cmd("rclone --vfs-cache-mode writes mount OneDrive: ~/OneDrive &")
	-- nm-applet removed: the wofi wifi popup (SUPER+W) replaces it
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("GDK_BACKEND", "wayland,x11,*")

hl.env("LIBVA_DRIVER_NAME", "iHD")

-- VM / software-rendering fallbacks
hl.env("WLR_NO_HARDWARE_CURSORS", "1") -- superseded by cursor.no_hardware_cursors below
hl.env("WLR_RENDERER_ALLOW_SOFTWARE", "1")

-- Firefox hardware acceleration
hl.env("MOZ_DISABLE_RDD_SANDBOX", "1")
hl.env("EGL_PLATFORM", "wayland")

hl.env("AQ_DRM_DEVICES", "/dev/dri/card1")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 5,
		border_size = 2,

		col = {
			active_border = "rgba(7aa2f7aa)",
			inactive_border = "rgba(414868aa)",
		},

		layout = "dwindle",
		resize_on_border = true,
	},
	render = {
		use_shader_blur_blend = false,
	},

	decoration = {
		rounding = 5,
		active_opacity = 0.85,
		inactive_opacity = 0.85,
		fullscreen_opacity = 0.95,
		rounding_power = 2,

		blur = {
			enabled = true,
			size = 7,
			passes = 4,
			new_optimizations = true,
			ignore_opacity = true,
			noise = 0.08,
			contrast = 1.1,
			brightness = 0.40,
			xray = false,
			vibrancy = 0.2,
			vibrancy_darkness = 0.1,
			special = true,
			popups = true,
		},

		shadow = {
			enabled = true,
			range = 6,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
	},

	animations = {
		enabled = false,
	},

	dwindle = {
		preserve_split = true,
	},

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		vrr = 0,

		-- Safety net: both default to false, which means a blanked display
		-- (dpms off) can ONLY be woken by whatever turned it off. If that
		-- fails the session looks frozen and needs a reboot. With these on,
		-- any keypress or mouse move brings the display back.
		key_press_enables_dpms = true,
		mouse_move_enables_dpms = true,
	},

	cursor = {
		no_hardware_cursors = true,
	},

	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "caps:escape",
		kb_rules = "",

		follow_mouse = 1,
		sensitivity = 0,

		touchpad = {
			natural_scroll = false,
		},
	},
})

-- Animation curves / leaves are kept for reference; animations.enabled is
-- false above, so none of these are currently in effect.
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = false, speed = 1, bezier = "default" })

--------------------
---- LAYER RULES ----
--------------------

hl.layer_rule({
	name = "waybar",
	match = { namespace = "waybar" },
	blur = true,
	ignore_alpha = 0.5,
	no_anim = true,
})

-- hl.layer_rule({
-- 	name = "swww",
-- 	match = { namespace = "swww-daemon" },
-- 	blur = true,
-- 	ignore_alpha = 0.5,
-- })

hl.layer_rule({
	name = "wofi",
	match = { namespace = "wofi" },
	blur = true,
	ignore_alpha = 0.5,
	animation = "popin 95%",
})

hl.layer_rule({
	name = "fuzzel",
	match = { namespace = "launcher" },
	blur = true,
	ignore_alpha = 0.5,
	animation = "popin 95%",
})

-- NOTE: the original config set `ignore_alpha` on `launcher` a second time
-- under its "Blur Dunst" heading, almost certainly a typo for `notifications`.
-- Ported as-written: dunst gets blur but no ignore_alpha.
hl.layer_rule({
	name = "dunst",
	match = { namespace = "notifications" },
	blur = true,
})

---------------------
---- WINDOW RULES ----
---------------------

hl.window_rule({
	name = "focus-on-activate",
	match = { class = ".*" },
	focus_on_activate = true,
})

-- FORCED FOOT BLUR & OPACITY
hl.window_rule({
	name = "foot-opacity",
	match = { class = "^(foot)$" },
	opacity = "0.85 0.75",
})

hl.window_rule({
	name = "foot-blur-fix",
	match = { class = "^(foot)$" },
	opacity = "0.85 0.75",
})
---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + return", hl.dsp.exec_cmd("foot --title TerminalEmulator"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind("CTRL + ALT + delete", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("fuzzel"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("wofi --show drun -s ~/.config/wofi/style.css"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + U", hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("pavucontrol"))
-- NOTE: verbatim port of `$restartwaybar = exec ./.config/waybar/waybar.sh`.
-- The leading `exec` and the relative `./` path are as they were in the
-- original config; the path resolves against Hyprland's working directory.
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("exec ./.config/waybar/waybar.sh"))
hl.bind(mainMod .. " + CTRL + W", hl.dsp.exec_cmd("waypaper"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("~/.config/waybar/theme-switcher"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/foot-theme-switch.sh"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wifi-menu.sh"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("~/.config/hypr/scripts/foot-blur-toggle.sh"))

-- Screenshots (full screen / region), saved and copied to the clipboard
hl.bind(
	mainMod .. " + ALT + S",
	hl.dsp.exec_cmd([[grim - | tee ~/Pictures/sc/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png | wl-copy]])
)
hl.bind(
	mainMod .. " + SHIFT + S",
	hl.dsp.exec_cmd([[grim -g "$(slurp)" - | tee ~/Pictures/sc/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png | wl-copy]])
)

-- Move focus: vim keys and arrow keys
local focusDirs = {
	h = "left",
	l = "right",
	k = "up",
	j = "down",
	left = "left",
	right = "right",
	up = "up",
	down = "down",
}
for key, dir in pairs(focusDirs) do
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = dir }))
end

-- Move the active window within the layout
local moveDirs = { H = "left", L = "right", K = "up", J = "down" }
for key, dir in pairs(moveDirs) do
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
end

-- Workspaces: SUPER + [0-9] to switch, SUPER + SHIFT + [0-9] to move window
for i = 1, 10 do
	local key = i % 10 -- workspace 10 lives on key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize with SUPER + LMB/RMB drag
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-------------------------
---- MEDIA / FN KEYS ----
-------------------------

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"))
hl.bind("XF86Calculator", hl.dsp.exec_cmd("qalculate-gtk"))
-- NOTE: the original had `bind = , XF86Lock, exec, hyprlock`, but XF86Lock is
-- not a real X11 keysym, so that bind has never done anything. The old .conf
-- parser skipped the bad line silently; the Lua parser raises an error that
-- aborts the rest of the config, so it is left disabled here to keep behaviour
-- identical. The real keysym for this key is XF86ScreenSaver -- uncomment the
-- line below to actually get a working lock key:
-- hl.bind("XF86ScreenSaver", hl.dsp.exec_cmd("hyprlock"))
hl.bind("XF86Tools", hl.dsp.exec_cmd("alacritty --class dotfiles-floating -e ~/dotfiles/hypr/settings/settings.sh"))

-- `binde` in the old format == key repeat, i.e. { repeating = true }
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("backlight up"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("backlight down"), { repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("volume up"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("volume down"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("volume mute"))
