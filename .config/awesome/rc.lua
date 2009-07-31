-- Standard awesome library
require("awful")
-- Theme handling library
require("beautiful")
-- Notification library
--require("naughty")

require("rodentbane")
require("shifty")

-- Load Debian menu entries
require("debian.menu")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- The default is a dark theme
--theme_path = "/usr/share/awesome/themes/default/theme.lua"
-- Uncommment this for a lighter theme
-- theme_path = "/usr/share/awesome/themes/sky/theme.lua"

theme_path = os.getenv("HOME") .. "/.config/awesome/theme.lua"

-- Actually load theme
beautiful.init(theme_path)

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    awful.layout.suit.floating
}
-- }}}

-- {{{ Shifty configuration
local mypicklayout = function (s)
    local wa = screen[s].workarea
    local layout

    if math.max(wa.width, wa.height) < 1200 then
        layout = awful.layout.suit.max
    elseif wa.width >= wa.height then
        layout = awful.layout.suit.tile
    else
        layout = awful.layout.suit.tile.bottom
    end

    return layout
end

local mygeometry = function (s, struts)
    local wa = screen[s].workarea
    local geometry = { 100, 100, 100, 100 }

    if struts.left ~= nil then
        geometry = { 0, 0, struts.left, wa.height }
    elseif struts.right ~= nil then
        geometry = { wa.width-struts.right, 0, struts.right, wa.height }
    elseif struts.top ~= nil then
        geometry = { 0, 0, wa.width, struts.top }
    elseif struts.bottom ~= nil then
        geometry = { 0, wa.height-struts.bottom, wa.width, struts.bottom }
    end

    return geometry
end

shifty.config.tags = {
    ["web"]  = { position = 1, init = true },
    ["ssh"]  = { position = 2, init = true },
    ["term"] = { position = 3, init = true },
}

local gimp_toolbox_struts = { left = 186 }
local gimp_dock_struts    = { right = 186 }

shifty.config.apps = {
    { match = { "Navigator", "Firefox", "Shiretoko" }, tag = "web" },

    { match = { "gnome%-terminal" }, tag = "term" },
    { match = { },                   tag = "ssh" },

    { match = { "Gimp" },          tag = "gimp" },
    { match = { "gimp%-toolbox" }, struts = gimp_toolbox_struts,
                                   geometry = mygeometry(1, gimp_toolbox_struts),
                                   skip_taskbar = true, float = true, slave = true },
    { match = { "gimp%-dock" },    struts = gimp_dock_struts,
                                   geometry = mygeometry(1, gimp_dock_struts),
                                   skip_taskbar = true, float = true, slave = true },

    { match = { "x%-nautilus%-desktop", "gnome%-panel" }, intrusive = true },

    { match = { "cellwriter", "Dasher", "^Do$", "Event Tester", "scim" }, float = true, intrusive = true },

    { match = { "MPlayer", "Totem", "Vlc" }, float = true },

    { match = { "" }, honorsizehints = false },
}

shifty.config.defaults = {
    layout = mypicklayout(1),
    mwfact = 0.5,
    exclusive = true,
    floatBars = true,
}

shifty.config.layouts = layouts

shifty.init()
-- }}}

-- {{{ Wibox
-- Create a textbox widget
--mytextbox = widget({ type = "textbox", align = "right" })
-- Set the default text in textbox
--mytextbox.text = "<b><small> " .. awesome.release .. " </small></b>"

-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu.new({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                        { "open terminal", terminal },
                                        { "Debian", debian.menu.Debian_menu.Debian }
                                      }
                            })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })

-- Create a systray
mysystray = widget({ type = "systray", align = "right" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, function (tag) tag.selected = not tag.selected end),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ align = "left" })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = widget({ type = "imagebox", align = "right" })
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = wibox({ position = "left", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = { mylauncher,
                           mytaglist[s],
                           mytasklist[s],
                           mypromptbox[s],
                           --mytextbox,
                           mylayoutbox[s],
                           s == 1 and mysystray or nil }
    mywibox[s].screen = s
end

shifty.taglist = mytaglist
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1) end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1) end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus( 1)       end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus(-1)       end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

-- Rodentbane
globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey, "Control" }, "m", rodentbane.start))

-- Shifty
globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey                     }, "t", function() shifty.add({ rel_index = 1 }) end, nil, "new tag"),
    awful.key({ modkey, "Control"          }, "t", function() shifty.add({ rel_index = 1, nopopup = true }) end, nil, "new tag in bg"),
    awful.key({ modkey,                    }, "n", shifty.rename, nil, "tag rename"),
    awful.key({ modkey, "Control", "Shift" }, "c", shifty.del, nil, "tag delete"))

for i = 1, (shifty.config.maxtags or 9) do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, i,
                  function ()
                      local t = awful.tag.viewonly(shifty.getpos(i))
                  end),

        awful.key({ modkey, "Control" }, i,
                  function ()
                      local t = shifty.getpos(i)
                      t.selected = not t.selected
                  end),

        awful.key({ modkey, "Control", "Shift" }, i,
                  function ()
                      if client.focus then
                          awful.client.toggletag(shifty.getpos(i))
                      end
                  end),

        -- move clients to other tags
        awful.key({ modkey, "Shift" }, i,
                  function ()
                      if client.focus then
                          local t = shifty.getpos(i)
                          awful.client.movetotag(t)
                          awful.tag.viewonly(t)
                      end
                  end))
end

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey }, "t", awful.client.togglemarked),
    awful.key({ modkey,}, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Set keys
root.keys(globalkeys)
shifty.config.globalkeys = globalkeys
shifty.config.clientkeys = clientkeys
-- }}}

-- {{{ Hooks
-- Hook function to execute when focusing a client.
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

-- Hook function to execute when marking a client
awful.hooks.marked.register(function (c)
    c.border_color = beautiful.border_marked
end)

-- Hook function to execute when unmarking a client.
awful.hooks.unmarked.register(function (c)
    c.border_color = beautiful.border_focus
end)

-- Hook function to execute when the mouse enters a client.
awful.hooks.mouse_enter.register(function (c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Hook function to execute when arranging the screen.
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    local layout = awful.layout.getname(awful.layout.get(screen))
    if layout and beautiful["layout_" ..layout] then
        mylayoutbox[screen].image = image(beautiful["layout_" .. layout])
    else
        mylayoutbox[screen].image = nil
    end

    -- Give focus to the latest client in history if no window has focus
    -- or if the current window is a desktop or a dock one.
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end
end)

-- Hook called every minute
--awful.hooks.timer.register(60, function ()
--    mytextbox.text = os.date(" %a %b %d, %H:%M ")
--end)
-- }}}

-- {{{ Backlight control
local backlight_low  = 40
local backlight_high = 100

local backlight_match = { "MPlayer", "Totem", "Vlc" }

local backlight_cmd = "dbus-send --session --type=method_call " ..
                      "--print-reply --dest=org.gnome.PowerManager " ..
                      "/org/gnome/PowerManager/Backlight " ..
                      "org.gnome.PowerManager.Backlight.SetBrightness"

local backlight_set = function (brightness)
    awful.util.spawn(backlight_cmd .. " uint32:" .. tostring(brightness))
end

local backlight_bright = false
backlight_set(backlight_low)

awful.hooks.focus.register(function (c)
    local new_bright = false

    for _, v in pairs(backlight_match) do
        if (c.cls and c.cls:find(v)) or
           (c.instance and c.instance:find(v)) or
           (c.name and c.name:find(v)) or
           (c.type and c.type:find(v)) then
            new_bright = true
        end
    end

    if backlight_bright ~= new_bright then
        local val
        if new_bright then
            val = backlight_high
        else
            val = backlight_low
        end
        backlight_set(val)
        backlight_bright = new_bright
    end
end)
-- }}}

-- vim:set et sw=4 sts=4 foldmethod=marker:
