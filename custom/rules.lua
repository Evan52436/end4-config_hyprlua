-- Force Waydroid to always open in fullscreen mode
hl.window_rule({
    name = "waydroid_fullscreen",
    match = {
        class = "^([Ww]aydroid)$"
    },
    fullscreen = 1
})

-- Enable blur for Quickshell background
hl.layer_rule({
    match = { namespace = "quickshell:background" },
    blur = true
})

hl.on("hyprland.start", function()
hl.exec_cmd("hyprctl keyword layerrule 'noanim, ^(coucou)$'")
hl.exec_cmd("hyprctl keyword layerrule 'ignorealpha 0.5, ^(coucou)$'")
end)
