hl.bind("CTRL+SUPER+ALT+Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"), {description = "Edit user keybinds"} )

-- SWAP PRESETS
hl.bind("CTRL + SUPER + SHIFT + 1",hl.dsp.exec_cmd("pkill -x mpvpaper; mpvpaper -o 'no-audio loop panscan=1.0' -f -p -a FULL '*' /home/chargerleptop/Downloads/miyakofr.mp4 && /home/chargerleptop/scripts/miyako.sh"))
hl.bind("CTRL + SUPER + SHIFT + 2",hl.dsp.exec_cmd("pkill -x mpvpaper; mpvpaper -o 'no-audio loop panscan=1.0' -f -p -a FULL '*' /home/chargerleptop/Downloads/arona.mp4 && /home/chargerleptop/scripts/arona.sh"))
hl.bind("CTRL + SUPER + SHIFT + 3",hl.dsp.exec_cmd("pkill -x mpvpaper; mpvpaper -o 'no-audio loop panscan=1.0' -f -p -a FULL '*' /home/chargerleptop/Downloads/kita.mp4 && /home/chargerleptop/scripts/kita.sh"))
hl.bind("CTRL + SUPER + SHIFT + 4",hl.dsp.exec_cmd("pkill -x mpvpaper; /home/chargerleptop/scripts/miku.sh left show"))
hl.bind("CTRL + SUPER + SHIFT + 5",hl.dsp.exec_cmd("pkill -x mpvpaper; /home/chargerleptop/scripts/mikuold.sh right show"))
hl.bind("CTRL + SUPER + SHIFT + 6",hl.dsp.exec_cmd("pkill -x mpvpaper; /home/chargerleptop/scripts/perlica.sh left show"))
hl.bind("CTRL + SUPER + SHIFT + 7",hl.dsp.exec_cmd("pkill -x mpvpaper; /home/chargerleptop/scripts/mika.sh left show"))
hl.bind("CTRL + SUPER + SHIFT + 8",hl.dsp.exec_cmd("pkill -x mpvpaper; /home/chargerleptop/scripts/iroha.sh right show"))
hl.bind("CTRL + SUPER + SHIFT + 9",hl.dsp.exec_cmd("pkill -x mpvpaper; /home/chargerleptop/scripts/azusa.sh right show"))

-- ZOOM (macOS-style): float + fill the screen so tiled windows stay rendered behind it.
-- Real maximize/fullscreen makes Hyprland skip drawing the other windows, so transparency shows nothing.
-- Replaces the default SUPER + D (maximize) from hyprland/keybinds.lua.
hl.unbind("SUPER + D") -- case-sensitive, must match the original bind string exactly

-- Zoom area = bounding box of the TILED windows on the current workspace.
-- The tiling layout already keeps clear of the bar (left OR right), so this follows your
-- bar-position presets automatically, and matches your gaps_out. No hardcoded bar side.
-- zoom_fallback is only used when there are no tiled windows to measure (bar on the right here).
local zoom_fallback = { top = 12, bottom = 12, left = 12, right = 70 }
local zoomed = {} -- [window address] = true if WE floated it
local zoom_seq, last_zoomed_at = 0, {} -- order in which windows were last zoomed (for SUPER+Z)

local function xy(v)
    if type(v) ~= "table" then return nil end
    return v.x or v[1], v.y or v[2]
end

local function geom(win)
    local x, y = xy(win.at)
    if not x then x, y = win.x, win.y end
    local sw, sh = xy(win.size)
    if x and y and sw and sh then return x, y, sw, sh end
end

local function tiled_bounds(w)
    local x1, y1, x2, y2
    for _, win in ipairs(hl.get_workspace_windows(w.workspace)) do
        if not win.floating then
            local x, y, sw, sh = geom(win)
            if x then
                x1 = math.min(x1 or x, x);          y1 = math.min(y1 or y, y)
                x2 = math.max(x2 or (x + sw), x + sw); y2 = math.max(y2 or (y + sh), y + sh)
            end
        end
    end
    if x1 then return x1, y1, x2 - x1, y2 - y1 end
end

local last_good = nil -- last plausible usable area, reused if a later measurement looks broken

-- kitty only: change ONLY its background opacity (text stays crisp) via kitty remote control.
-- Needs in kitty.conf:  allow_remote_control yes  +  listen_on unix:/tmp/kitty-{kitty_pid}
-- Keep kitty_normal equal to background_opacity in kitty.conf.
local kitty_normal = 0.85 -- kitty when it has nothing behind it
local kitty_zoomed = 0.15 -- kitty when zoomed over another window (lower = more see-through)

local function kitty_opacity(w, value)
    if w.class ~= "kitty" then return end
    local sock = w.pid and ("/tmp/kitty-" .. w.pid) or "/tmp/kitty-*"
    hl.exec_cmd(string.format(
        "for s in %s; do kitten @ --to unix:$s set-background-opacity %s >/dev/null 2>&1; done",
        sock, value))
end

-- A measurement is only trusted if it sits inside the monitor and covers most of it.
-- Tiled windows mid-animation (opening/closing/screenshot overlays) can report odd geometry.
local function plausible(x, y, width, height, m)
    local mx, my = m.x or 0, m.y or 0
    return width >= m.width * 0.6 and height >= m.height * 0.6
        and x >= mx - 2 and y >= my - 2
        and x + width <= mx + m.width + 2 and y + height <= my + m.height + 2
end

local function toggle_zoom()
    local w = hl.get_active_window()
    if not w then return end

    local key = w.address
    if zoomed[key] and w.floating then
        zoomed[key] = nil
        hl.dispatch(hl.dsp.window.tag({ tag = "-zoomed" }))
        kitty_opacity(w, kitty_normal)
        hl.dispatch(hl.dsp.window.float({ action = "unset" }))
        return
    end

    local m = hl.get_active_monitor()
    if not (m and m.width and m.height) then
        hl.notification.create({ text = "zoom: can't read monitor, check /usr/share/hypr/stubs/hl.meta.lua", timeout = 4000 })
        return
    end

    -- measure BEFORE floating, while the active window still counts as tiled
    local x, y, width, height = tiled_bounds(w)
    if x and plausible(x, y, width, height, m) then
        last_good = { x = x, y = y, w = width, h = height }
    elseif last_good and plausible(last_good.x, last_good.y, last_good.w, last_good.h, m) then
        x, y, width, height = last_good.x, last_good.y, last_good.w, last_good.h
    else
        x, y = (m.x or 0) + zoom_fallback.left, (m.y or 0) + zoom_fallback.top
        width = m.width - zoom_fallback.left - zoom_fallback.right
        height = m.height - zoom_fallback.top - zoom_fallback.bottom
    end

    zoomed[key] = true
    zoom_seq = zoom_seq + 1
    last_zoomed_at[key] = zoom_seq
    hl.dispatch(hl.dsp.window.tag({ tag = "+zoomed" }))
    kitty_opacity(w, kitty_zoomed)
    hl.dispatch(hl.dsp.window.float({ action = "set" }))
    hl.dispatch(hl.dsp.window.resize({ x = width, y = height, relative = false }))
    hl.dispatch(hl.dsp.window.move({ x = x, y = y, relative = false }))
end

-- SUPER + Z: while a window is zoomed, swap it with another tiled window on the workspace.
-- The zoomed one goes back to its tile, the next one takes the same area. With 3+ windows it
-- rotates: the window that was zoomed longest ago (or never) comes to the front next.
local function swap_zoom()
    local w = hl.get_active_window()
    if not (w and zoomed[w.address] and w.floating) then
        hl.notification.create({ text = "zoom swap: no zoomed window (SUPER+D first)", timeout = 1500 })
        return
    end
    local m = hl.get_active_monitor()
    if not (m and m.width and m.height) then return end

    -- area to hand over = where the zoomed window is right now
    local x, y, width, height = geom(w)
    if not (x and plausible(x, y, width, height, m)) then
        if last_good and plausible(last_good.x, last_good.y, last_good.w, last_good.h, m) then
            x, y, width, height = last_good.x, last_good.y, last_good.w, last_good.h
        else
            return
        end
    end

    local target, oldest
    for _, win in ipairs(hl.get_workspace_windows(w.workspace)) do
        if not win.floating and win.address ~= w.address then
            local t = last_zoomed_at[win.address] or 0
            if not oldest or t < oldest then target, oldest = win, t end
        end
    end
    if not target then
        hl.notification.create({ text = "zoom swap: no other tiled window", timeout = 1500 })
        return
    end

    -- current one goes back to its tile
    zoomed[w.address] = nil
    hl.dispatch(hl.dsp.window.tag({ tag = "-zoomed", window = w }))
    kitty_opacity(w, kitty_normal)
    hl.dispatch(hl.dsp.window.float({ action = "unset", window = w }))

    -- target takes the zoomed area
    zoomed[target.address] = true
    zoom_seq = zoom_seq + 1
    last_zoomed_at[target.address] = zoom_seq
    hl.dispatch(hl.dsp.focus({ window = target }))
    hl.dispatch(hl.dsp.window.tag({ tag = "+zoomed", window = target }))
    kitty_opacity(target, kitty_zoomed)
    hl.dispatch(hl.dsp.window.float({ action = "set", window = target }))
    hl.dispatch(hl.dsp.window.resize({ x = width, y = height, relative = false, window = target }))
    hl.dispatch(hl.dsp.window.move({ x = x, y = y, relative = false, window = target }))
end

hl.bind("SUPER + D", toggle_zoom, { description = "Window: Zoom (transparent-friendly maximize)" })
hl.bind("SUPER + Z", swap_zoom, { description = "Window: Swap zoomed window with the next tiled one" })
