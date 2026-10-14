hl.device({
    name = "elan06fa:00-04f3:327e-touchpad",
    -- Sensitivity ranges from -1.0 to 1.0. 
    -- 0.0 is the raw driver speed. Try 0.4 to 0.7 for a noticeably higher sensitivity.
    sensitivity = 0.4,
})

-- Force opacity and compositing properties directly on the terminal instance
hl.window_rule({
    match = { class = "kitty" }, 
    opacity = "1.0 override 1.0 override", -- kitty's own background_opacity (kitty.conf) handles transparency now
    no_blur = false,
    xray = true 
})

hl.window_rule({
    match = { class = "org.kde.dolphin" }, 
    opacity = "0.85 override 0.60 override",
    no_blur = false,
    xray = true 
})

hl.window_rule({
    match = { class = "antigravity-ide" }, 
    opacity = "0.86 override 0.75 override",
    no_blur = false,
    xray = true 
})

hl.window_rule({
    match = { class = "code" }, 
    opacity = "0.86 override 0.75 override",
    no_blur = false,
    xray = true 
})

hl.window_rule({
    match = { class = "feishin" }, 
    opacity = "0.80 override 0.85 override",
    no_blur = false,
    xray = true 
})

hl.window_rule({
    match = { class = "vesktop" }, 
    opacity = "0.85 override 0.75 override",
    no_blur = false,
    xray = true 
})

hl.window_rule({
    match = { class = "discord" },
    opacity = "0.85 override 0.75 override",
    no_blur = false,
    xray = true
})


hl.window_rule({
    match = { class = "org.kde.kate" },
    opacity = "0.90 override 0.75 override",
    no_blur = false,
    xray = true
})

hl.window_rule({
    match = { class = "mp3tag" },
    opacity = "0.86 override 0.75 override",
    no_blur = false,
    xray = true
})

-- Floating windows (incl. the SUPER+D "zoom" in custom/keybinds.lua) must NOT use xray,
-- otherwise their blur samples only the wallpaper and hides the tiled window behind them.
-- Keep this AFTER the per-class xray rules above so it wins.
hl.window_rule({
    match = { float = true },
    xray = false
})

-- Zoomed windows get the tag "zoomed" from SUPER+D (custom/keybinds.lua).
-- No opacity override on purpose: every app keeps its own normal opacity (the per-class rules
-- above), so text-heavy apps like Claude Desktop don't get extra see-through when zoomed.
-- If you ever want a zoom-only opacity for one app, copy this (it must stay below the class rules):
-- hl.window_rule({ match = { tag = "zoomed", class = "kitty" }, opacity = "0.9 override 0.9 override" })

-- Blur engine code block
hl.config({
    decoration = {
        blur = {
            enabled = true,
            passes = 4,
            special = true,        -- blur windows UNDER the special workspace too (main config has false = wallpaper only)
            brightness = 1.1,      -- >1 lifts the dark look of the blurred backdrop
 	    vibrancy = 0.1,
	    contrast = 0.8,
            size = 12,             -- Blur radius (higher = softer blur)
            xray = true,           -- idk what this does, gemini told me to add ts
	    ignore_opacity = true, --forces bluer through the opacity
        }
    }
})

hl.layer_rule({
    match = { namespace = "quickshell:background" },
    blur = true,
    ignore_alpha = 0
})

hl.layer_rule({
    match = { namespace = "quickshell:sidebarRight" }, -- confirm the real name via `hyprctl layers`
    blur = true,
    ignore_alpha = 0.9,
})


--MonitorAutoRotate
hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "auto",
    scale = 1,
    transform = 0,
})
