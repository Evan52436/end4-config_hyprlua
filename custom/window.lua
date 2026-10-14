-- ~/.config/hypr/custom/window.lua
-- Window look: border color/size, gaps, rounding, snapping.
-- Loaded from hyprland.lua AFTER hyprland.colors and custom.general, so these values win.
-- Reference: https://wiki.hypr.land/Configuring/Basics/Variables/

-- =========================================================
-- Tweak these, then `hyprctl reload` (or save, Hyprland auto-reloads)
-- =========================================================
local BORDER_SIZE = 2        -- border thickness in px (0 = no border)
local GAPS_IN     = 5        -- gap BETWEEN windows
local GAPS_OUT    = 10       -- gap between windows and the SCREEN EDGE
local ROUNDING    = 18       -- corner radius in px

-- Colors are rgba(RRGGBBAA). The last two hex digits are alpha (transparency).
local ACTIVE_A   = "rgba(211, 103, 133, 1)"  -- active border, gradient start (your cyan)
local ACTIVE_B   = "rgba(7C83FDee)"  -- active border, gradient end
local ACTIVE_ANGLE = 45              -- gradient direction in degrees
local INACTIVE   = "rgba(59595988)"  -- unfocused windows

hl.config({
    general = {
        border_size = BORDER_SIZE,

        -- single number = same gap on all sides.
        -- Or per side: { top = 10, right = 10, bottom = 10, left = 10 }
        gaps_in  = GAPS_IN,
        gaps_out = GAPS_OUT,

        col = {
            -- gradient = table with colors + angle. For a solid color use a plain string instead:
            -- active_border = "rgba(0DB7D4ee)",
            active_border   = { colors = { ACTIVE_A, ACTIVE_B }, angle = ACTIVE_ANGLE },
            inactive_border = INACTIVE,
        },

        -- Keep snapping consistent with the gaps above
        snap = {
            enabled      = true,
            window_gap   = GAPS_IN,
            monitor_gap  = GAPS_OUT,
            respect_gaps = true,
        },
    },

    decoration = {
        rounding       = ROUNDING,
        rounding_power = 2.5,   -- 2 = true circle, higher = squircle
    },
})

-- =========================================================
-- Optional extras (uncomment to use)
-- =========================================================

-- Different border for floating windows (first color = active, second = inactive)
-- hl.window_rule({
--     match        = { float = true },
--     border_color = "rgba(F5C2E7ee) rgba(F5C2E755)",
-- })

-- No gaps when a workspace has a single tiled window
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
