-- This file sources other files in `hyprland` and `custom` folders
-- You wanna add your stuff in files in `custom`

-- Internal stuff --
require("hyprland.lib")
require("hyprland.services")

-- Environment variables --
require("hyprland.env")
if is_file_exists(HOME .. "/.config/hypr/custom/env.lua") then
    require("custom.env")
end

-- Default configurations --
require("hyprland.execs")
require("hyprland.general")
require("hyprland.rules")
require("hyprland.colors")
require("hyprland.keybinds")

-- Custom configurations --
if is_file_exists(HOME .. "/.config/hypr/custom/execs.lua") then
    require("custom.execs")
end
if is_file_exists(HOME .. "/.config/hypr/custom/general.lua") then
    require("custom.general")
end
if is_file_exists(HOME .. "/.config/hypr/custom/rules.lua") then
    require("custom.rules")
end
if is_file_exists(HOME .. "/.config/hypr/custom/keybinds.lua") then
    require("custom.keybinds")
end
if is_file_exists(HOME .. "/.config/hypr/custom/window.lua") then
    require("custom.window")
end

-- nwg-displays support --
if is_file_exists(HOME .. "/.config/hypr/workspaces.lua") then
    require("workspaces")
end
if is_file_exists(HOME .. "/.config/hypr/monitors.lua") then
    require("monitors")
end

-- Shell overrides --
require("hyprland.shellOverrides.main")

hl.config({
    input = {
        touchpad = {
            natural_scroll = true,
            scroll_factor = 1.0
        }
    }
})

-- Define the improved, fully native toggle logic
local function toggleLaptopScreen()
local monitors = hl.get_monitors()
local edp_active = false
local monitor_count = 0

for _, mon in ipairs(monitors) do
    monitor_count = monitor_count + 1
    if mon.name == "eDP-1" then
        edp_active = true
        end
        end

        if edp_active then
            if monitor_count > 1 then
                hl.monitor({ output = "eDP-1", disabled = true })
                else
                    hl.notification.create({ text = "Safeguard: Cannot disable the only active screen!", timeout = 3000 })
                    end
                    else
                        -- EXPLICIT WAKE WITH COORDINATES:
                        -- This forces eDP-1 to wake up directly BELOW your external monitor automatically.
                        -- "auto-up" tells Hyprland to place this display under the adjacent one.
                        hl.monitor({
                            output = "eDP-1",
                            disabled = false,
                            mode = "preferred",
                            position = "auto-down", -- Forces layout to place laptop below external screen
                            scale = 1
                        })
                        end
                        end

                        hl.bind("SUPER + F9", toggleLaptopScreen)


                        hl.bind("SUPER + F8", hl.dsp.exec_cmd(
                            "mpv --no-video --loop=inf --audio-client-name=hypridle-audio ~/Music/idle.mp3 &"
                        ))

                        hl.bind("SUPER + SHIFT + F8", hl.dsp.exec_cmd(
                            "~/.config/hypr/scripts/idle-fade-stop.sh"
                        ))


