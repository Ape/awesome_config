local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local vicious = require("vicious")

local pulsedefault = require("pulsedefault")
local localconfig = require("localconfig")

--### Error handling ###--
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
         title = "Oops, there were errors during startup!",
         text = awesome.startup_errors,
    })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err),
        })
        in_error = false
    end)
end

--### Definitions ###--
beautiful.init(localconfig.theme .. "/theme.lua")
beautiful.wallpaper = localconfig.wallpaper

modkey = "Mod4"
tag_keys  = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "q", "w", "e", "r", "t", "y", "u", "i", "o", "p" }
numpad_keys = { 87, 88, 89, 83, 84, 85, 79, 80, 81, 90, 91 }

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.floating,
}

--### Wibar ###--
clockwidget = wibox.widget.textclock("%H:%M:%S", 1)

cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, "<span color='" .. localconfig.colors["cpu"] .. "'>$1%</span> ", 1)

memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, "<span color='" .. localconfig.colors["memory"] .."'>$2MB</span> ", 5)

diowidget = wibox.widget.textbox()
vicious.register(diowidget, vicious.widgets.dio, function (widgets, args)
    local function dio_value(device, key, symbols, limit)
        value = tonumber(args["{" .. device .. " " .. key .. "}"])

        if value == nil then
            return "?"
        elseif value > limit then
            return string.sub(symbols, 3, 3)
        elseif value > 0.0 then
            return string.sub(symbols, 2, 2)
        else
            return string.sub(symbols, 1, 1)
        end
    end

    local result = ""
    for i, device in ipairs(localconfig.diskdevices) do
        local read  = dio_value(device, "read_mb",  "-rR", 150.0)
        local write = dio_value(device, "write_mb", "-wW", 100.0)
        result = result .. read .. write .. " "
    end

    return "<span color='" .. localconfig.colors["dio"] .. "'>" .. result .. "</span>"
end, 2)

networkwidget = wibox.widget.textbox()
vicious.register(networkwidget, vicious.widgets.net,
                 "<span color='" .. localconfig.colors["net"] .. "'>${" .. localconfig.networkdevice .. " down_mb}MB/s ${" .. localconfig.networkdevice .. " up_mb}MB/s</span> ", 1)

batterywidget = wibox.widget.textbox()
vicious.register(batterywidget, vicious.widgets.bat, function (widgets, args)
    if args[1] == "⌁" or args[1] == "↯" then
        return ""
    end

    if args[1] == "-" then
        if args[2] < 10 then
            color = localconfig.colors["bat_low"]
        else
            color = localconfig.colors["bat_discharging"]
        end
    else
        color = localconfig.colors["bat_charging"]
    end

    return "<span color='" .. color .. "'>" .. args[2] .. "% " .. args[1] .. args[3] ..  "</span> "
end, 10, localconfig.batterydevice)

pulsewidget = wibox.widget.textbox()
if localconfig.pulsesinks ~= nil then
    vicious.register(pulsewidget, pulsedefault, "<span color='" .. localconfig.colors["volume"] .. "'>$1</span>", 2, localconfig.pulsesinks)
end

volumewidget = wibox.widget.textbox()
vicious.register(volumewidget, vicious.widgets.volume, function (widgets, args)
    if args[2] == "♩" then
        value = "--"
    elseif args[1] then
        value = args[1]
    else
        value = "??"
    end

    return "<span color='" .. localconfig.colors["volume"] .. "'>" .. value .. "%</span> "
end, 1, localconfig.audiodevice)

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({}, 4, function () awful.client.focus.byidx(1) end),
    awful.button({}, 5, function () awful.client.focus.byidx(-1) end)
)

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, false)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag(tag_keys, s, awful.layout.layouts[1])

    for i, tag in ipairs(s.tags) do
        tag.master_width_factor = .6
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
        awful.button({}, 1, function () awful.layout.inc( 1) end),
        awful.button({}, 3, function () awful.layout.inc(-1) end),
        awful.button({}, 4, function () awful.layout.inc( 1) end),
        awful.button({}, 5, function () awful.layout.inc(-1) end))
    )
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        height = beautiful.panel_height,
        screen = s,
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            wibox.widget.systray(),
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            cpuwidget,
            memwidget,
            diowidget,
            networkwidget,
            batterywidget,
            pulsewidget,
            volumewidget,
            clockwidget,
            s.mylayoutbox,
        },
    }

    for tagname, func in pairs(localconfig.tagsetup) do
        func(awful.tag.find_by_name(s, tagname))
    end
end)

--### Key bindings ###--
globalkeys = awful.util.table.join(
    awful.key({ modkey }, "Left", awful.tag.viewprev),
    awful.key({ modkey }, "Right", awful.tag.viewnext),
    awful.key({ modkey }, "Escape", awful.tag.history.restore),

    awful.key({ "Mod1" }, "Tab", function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),

    awful.key({ "Mod1", "Shift" }, "Tab", function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),

    awful.key({ modkey }, "Tab", function ()
        awful.screen.focus_relative(1)
    end),

    awful.key({ modkey, "Shift" }, "Tab", function ()
        if client.focus then awful.client.movetoscreen(client.focus) end
    end),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(  1) end),
    awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx( -1) end),

    -- Standard program
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey }, "l", function () awful.tag.incmwfact( 0.05) end),
    awful.key({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end),
    awful.key({ modkey, "Shift" }, "h", function () awful.tag.incnmaster( 1, nil, true) end),
    awful.key({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1, nil, true) end),
    awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol( 1, nil, true) end),
    awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1, nil, true) end),
    awful.key({ modkey          }, "space", function () awful.layout.inc( 1) end),
    awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(-1) end),

    awful.key({ modkey, "Control" }, "n", function ()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            client.focus = c
            c:raise()
        end
    end),

    -- Prompt
    awful.key({ modkey }, "a", function () awful.screen.focused().mypromptbox:run() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey, }, "f", function (c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end),
    awful.key({ "Mod1", }, "F4", function (c) c:kill() end),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey }, "n", function (c) c.minimized = true end)
)

for i, tag_key in ipairs(tag_keys) do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, tag_key, function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, tag_key, function ()
            if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:move_to_tag(tag)
            end
            end
        end)
    )
end

clientbuttons = awful.util.table.join(
    awful.button({}, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)

for i, hotkey in ipairs(localconfig.hotkeys) do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key(hotkey[3], hotkey[2], function ()
            awful.spawn(hotkey[1])
        end)
    )
end

--## Mouse control ###--
local mouse_speed = 30

local function click(button)
    awful.spawn("xdotool keyup Super_L click " .. button .. " keydown Super_L")
end

globalkeys = awful.util.table.join(globalkeys,
    awful.key({"Mod4"}, "#" .. numpad_keys[4], function() mouse.coords({
        x = mouse.coords().x - mouse_speed,
    }) end),
    awful.key({"Mod4"}, "#" .. numpad_keys[6], function() mouse.coords({
        x = mouse.coords().x + mouse_speed,
    }) end),
    awful.key({"Mod4"}, "#" .. numpad_keys[8], function() mouse.coords({
        y = mouse.coords().y - mouse_speed,
    }) end),
    awful.key({"Mod4"}, "#" .. numpad_keys[2], function() mouse.coords({
        y = mouse.coords().y + mouse_speed,
    }) end),
    awful.key({"Mod4"}, "#" .. numpad_keys[7], function() mouse.coords({
        x = mouse.coords().x - mouse_speed,
        y = mouse.coords().y - mouse_speed,
    }) end),
    awful.key({"Mod4"}, "#" .. numpad_keys[9], function() mouse.coords({
        x = mouse.coords().x + mouse_speed,
        y = mouse.coords().y - mouse_speed,
    }) end),
    awful.key({"Mod4"}, "#" .. numpad_keys[1], function() mouse.coords({
        x = mouse.coords().x - mouse_speed,
        y = mouse.coords().y + mouse_speed,
    }) end),
    awful.key({"Mod4"}, "#" .. numpad_keys[3], function() mouse.coords({
        x = mouse.coords().x + mouse_speed,
        y = mouse.coords().y + mouse_speed,
    }) end),
    awful.key({"Mod4"}, "#" .. numpad_keys[11], function() mouse.coords({
        x = 1620,
        y = 0,
    }) end),
    awful.key({"Mod4"}, "#" .. numpad_keys[5], function() click(1) end),
    awful.key({"Mod4"}, "#" .. numpad_keys[10], function() click(3) end),
    awful.key({"Mod4", "Control"}, "#" .. numpad_keys[5], function() click(1) end),
    awful.key({"Mod4", "Control"}, "#" .. numpad_keys[10], function() click(3) end),
    awful.key({"Mod4"}, "Prior", function() awful.spawn("xdotool click 4") end),
    awful.key({"Mod4"}, "Next", function() awful.spawn("xdotool click 5") end)
)

--### Apply bindings ###--
root.keys(globalkeys)

--### Rules ###-
awful.rules.rules = {
    {
        rule = {}, properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
            maximized = false,
        }
    },
    {
        rule_any = { class = localconfig.fullscreenclasses },
        properties = { fullscreen = true },
    },
}

for class, tag in pairs(localconfig.applicationtags) do
    table.insert(awful.rules.rules, {
        rule = { class = class },
        properties = { tag = tag },
    })
end

--### Signals ###-
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Hide tags with no clients
local function hidetags(s)
    local function hidetag(t, hide)
        awful.tag.setproperty(s.tags[t], "hide", hide)
    end

    for t = 1, #s.tags do
        if t == 1 or t == 11 then
            extratagshown = false
        end

        if #s.tags[t]:clients() > 0 then
            extratagshown = false
            hidetag(t, false)
        elseif s.tags[t].selected or not extratagshown then
            extratagshown = true
            hidetag(t, false)
        else
            hidetag(t, true)
        end
    end
end

local function hidetagsc(c) hidetags(c.screen) end
local function hidetagst(t) hidetags(t.screen) end

client.connect_signal("unmanage", hidetagsc)
client.connect_signal("new", function(c)
    c:connect_signal("property::screen", hidetagsc)
    c:connect_signal("tagged", hidetagsc)
    c:connect_signal("untagged", hidetagsc)
end)

awful.screen.connect_for_each_screen(function(s)
    hidetags(s)
    awful.tag.attached_connect_signal(s, "property::selected", hidetagst)
end)

--### Autostart ###--
-- Run the command if the program is not running already
local function run_once(command)
    if not command then
        do return nil end
    end

    if not os.execute("pgrep -f '" .. command .. "'") then
        awful.spawn(command)
    end
end

for i = 1, #localconfig.autorun do
    run_once(localconfig.autorun[i])
end
