# ~/.config/hypr

Hyprland configuration written in Lua, based on [end-4's dots-hyprland](https://github.com/end-4/dots-hyprland) with personal overrides on top.

Everything is configured with Lua modules, except `hyprlock` and `hypridle`, which use their own native `.conf` syntax.

## Prerequisites

- [Hyprland](https://hyprland.org/) **0.55 or newer** (native Lua config support; no extra plugin needed)
- [Quickshell](https://quickshell.org/) shell from end-4's dots (the config references `quickshell:*` layers and global shortcuts)
- [hyprlock](https://wiki.hypr.land/Hypr-Ecosystem/hyprlock/) and [hypridle](https://wiki.hypr.land/Hypr-Ecosystem/hypridle/)

## Structure

```
~/.config/hypr/
├── hyprland.lua            # Entry point: loads hyprland/*, then custom/*, then monitors/workspaces
├── monitors.lua            # Monitor layout (nwg-displays support)
│
├── hyprland/               # Upstream defaults (end-4). Avoid editing, override in custom/ instead
│   ├── lib/init.lua        # Helpers (HOME, is_file_exists, ...)
│   ├── services/
│   │   ├── init.lua
│   │   └── create_custom_config.lua
│   ├── env.lua             # Default environment variables
│   ├── execs.lua           # Default autostart
│   ├── general.lua         # Gaps, borders, decoration, blur, animations, input, misc
│   ├── rules.lua           # Default window and layer rules
│   ├── colors.lua          # Border / background colors
│   ├── keybinds.lua        # Default keybinds
│   ├── variables.lua       # Shared variables
│   ├── shellOverrides/
│   │   └── main.lua        # Quickshell-driven overrides, loaded last
│   └── scripts/            # Helper scripts (fuzzel-emoji, snip_to_search, ai/, ...)
│
├── custom/                 # Personal overrides, loaded after hyprland/*
│   ├── env.lua             # Extra environment variables (loaded before defaults)
│   ├── execs.lua           # Extra autostart
│   ├── general.lua         # Touchpad, per-app opacity, blur, monitor tweaks
│   ├── rules.lua           # Extra window and layer rules
│   ├── keybinds.lua        # Extra keybinds
│   ├── window.lua          # Window look: border color/size, gaps, rounding, snapping
│   ├── variables.lua       # Personal variables (currently empty)
│   └── scripts/
│       └── __restore_video_wallpaper.sh
│
├── scripts/                # Standalone helper scripts
│   ├── hypr-watchdog.sh
│   └── idle-fade-stop.sh
│
├── hyprlock.conf           # Lock screen entry point (native syntax)
├── hyprlock/               # Lock screen parts
│   ├── colors.conf
│   ├── music.conf
│   ├── layouts/            # layout13, layout14, layout20, layoutaero
│   └── scripts/            # battery, weather, music, cava, stopwatch, ...
├── hypridle.conf           # Idle behavior (native syntax)
└── lockscreen_kotone.jpg   # Lock screen wallpaper
```

### Load order

1. `hyprland/lib`, `hyprland/services`
2. `hyprland/env` → `custom/env`
3. `hyprland/{execs,general,rules,colors,keybinds}`
4. `custom/{execs,general,rules,keybinds,window}` (later files win, so these override the defaults)
5. `workspaces.lua` and `monitors.lua` (only if present)
6. `hyprland/shellOverrides/main`

### Legacy files (old hyprlang format, not loaded by `hyprland.lua`)

`hyprland.conf.old`, `monitors.conf`, `workspaces.conf`, `hypridle.conf.new`, `hyprlock.conf.new`, `custom/execs.conf`, `custom/keybinds.conf`, `custom/userrules.conf`, `custom.zip`

## Installation

1. Back up your existing configuration:
   ```bash
   mv ~/.config/hypr ~/.config/hypr.bak
   ```

2. Clone this repository to `~/.config/hypr`:
   ```bash
   git clone https://github.com/<your-username>/<your-repo-name>.git ~/.config/hypr
   ```

3. Reload Hyprland or start a new session.

## Notes

- **Lua config**: since Hyprland 0.55, `hyprland.lua` is the main config and the old `hyprland.conf` format is deprecated. Docs: <https://wiki.hypr.land/Configuring/Basics/Variables/>
- **Where to edit**: put changes in `custom/`. For window appearance (borders, gaps, rounding), edit `custom/window.lua`.
- **hyprlock / hypridle**: they read their own config format, so `hyprlock.conf` and `hypridle.conf` stay as `.conf`.
