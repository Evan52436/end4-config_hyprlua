-- Custom Startup Applications & Portal Fix
hl.on("hyprland.start", function ()
-- 1. Import env vars, trigger your new custom target, and sequentially restart portals
hl.exec_cmd("sleep 2 && systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user start hyprland-session.target && sleep 1 && systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal")

-- 2. Put any of your other autostart applications below if you have them
-- hl.exec_cmd("sleep 5 && keepassxc")
end)

-- Force-injection sequence for Wayland Screensharing
hl.on("hyprland.start", function ()
    -- 1. Broadcast environment variables instantly to both D-Bus and systemd wrappers
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland")
    
    -- 2. Obliterate any lingering zombie portal instances and cleanly start fresh
    hl.exec_cmd("sleep 1 && killall -9 xdg-desktop-portal-hyprland xdg-desktop-portal && systemctl --user restart xdg-desktop-portal")
    hl.exec_cmd("fcitx5 &")
    hl.exec_cmd("/home/chargerleptop/.local/bin/rotate-hyprland.sh")
    hl.exec_cmd("~/.config/hypr/scripts/hypr-watchdog.sh")
    hl.exec_cmd("pkill -x mpvpaper; /home/chargerleptop/scripts/aero.sh right show")
end)

-- Testing!!
-- hl.on("hyprland.start", function ()
-- hl.exec_cmd("~/Downloads/eDEX-UI-Linux-x86_64.AppImage")
-- end)

