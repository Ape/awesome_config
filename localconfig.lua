local localconfig = {}

-- Set the theme
localconfig.theme = "apesome"
localconfig.wallpaper = "/home/ape/.wallpaper/pallas.jpg"

-- Applications to run on startup
localconfig.autorun = {
	"unclutter -idle 2",
	"xset -dpms",
	"xset s off",
	"nvidia-settings -l",
	"pulseaudio --start",
}

-- Assign specific applications to selected tags
localconfig.classtags = {
	["Gajim"] = { 1, 12 },
	["Thunderbird"] = { 1, 13 },
}

-- Set special tag properties
localconfig.tagproperties = {
	{ localconfig.classtags["Gajim"], function(t) t.master_width_factor = .14 end },
	{ localconfig.classtags["Gajim"], function(t) t.column_count = 4 end },
}

-- Add custom hotkeys
localconfig.hotkeys = {
	-- Launch useful applications
	{ "scrot", "Print" },
	{ "termite", "Return", { "Mod4" } },
	{ "xkill", "s", { "Mod4" } },
	{ "chromium --user-data-dir=/home/ape/.config/chromium", "x", { "Mod4" } },
	{ "chromium --user-data-dir=/home/ape/.config/chromium-guest", "v", { "Mod4" } },
	{ "termite -e 'ranger'", "c", { "Mod4" } },
	{ "qalculate-gtk -n", "z", { "Mod4" } },
	{ "slimlock", "m", { "Mod4" } },

	-- MPD control
	{ "musiccontrol toggle", "F1", { "Mod4" } },
	{ "musiccontrol prev", "F2", { "Mod4" } },
	{ "musiccontrol next", "F3", { "Mod4" } },
	{ "musiccontrol extra", "F4", { "Mod4" } },

	-- Monitor control
	{ "monitorcontrol desktop", "F5", { "Mod4" } },
	{ "monitorcontrol tv", "F6", { "Mod4" } },
	{ "monitorcontrol tv2", "F6", { "Mod4", "Control" } },
	{ "monitorcontrol both", "F7", { "Mod4" } },
	{ "monitorcontrol mirror", "F8", { "Mod4" } },
	{ "monitorcontrol desktop2", "F5", { "Mod4", "Control" } },
	{ "3d", "F8", { "Mod4", "Control" } },

	-- Audio sink control
	{ "pamove speakers_eq", "F9", { "Mod4" } },
	{ "pamove speakers_desk", "F10", { "Mod4" } },
	{ "pamove speakers_plain", "F11", { "Mod4" } },
	{ "pamove headphones", "F12", { "Mod4" } },

	-- Manage volume using Super + numpad and media keys
	{ "volumecontrol 5%+", "KP_Add", { "Mod4" } },
	{ "volumecontrol 5%-", "KP_Subtract", { "Mod4" } },
	{ "volumecontrol toggle", "KP_Multiply", { "Mod4" } },
	{ "volumecontrol 5%+", "XF86AudioLowerVolume", {} },
	{ "volumecontrol 5%-", "XF86AudioRaiseVolume", {} },
	{ "volumecontrol toggle", "XF86AudioMute", {} },
	{ "pavucontrol", "KP_Divide", { "Mod4"} },
}

-- Set windows to run fullscreen
localconfig.fullscreenclasses = {
	"Xephyr",
}

localconfig.diskdevices = { "sda", "md127" }
localconfig.networkdevice = "enp3s0"
localconfig.batterydevice = "BAT0"
localconfig.audiodevice = "Master"

localconfig.pulsesinks = {
	speakers_eq = "",
	speakers_desk = "D",
	speakers_plain = "P",
	headphones = "H",
}

-- Disable default pulse sink indicator with 'nil'
--localconfig.pulsesinks = nil

return localconfig
