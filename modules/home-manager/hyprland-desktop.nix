{ pkgs, ... }:
let
    monitor1 = "DP-1";
    monitor2 = "DP-2";
    monitor3 = "HDMI-A-1";

    # Lua table for the left monitor, shared by the config and the toggle script
    monitor3Spec = ''{ output = "${monitor3}", mode = "1920x1080@60", position = "-2560x0", scale = 1, bitdepth = 10 }'';

    # Toggle a monitor off/on, restoring its layout from monitor3Spec
    toggleMonitor = pkgs.writeShellScript "togglemonitor" ''
        if ${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -e '.[] | select(.name == "${monitor3}")' >/dev/null; then
            ${pkgs.hyprland}/bin/hyprctl eval 'hl.monitor({ output = "${monitor3}", disabled = true })'
        else
            ${pkgs.hyprland}/bin/hyprctl eval 'hl.monitor(${monitor3Spec})'
        fi
    '';
in
{
    home.packages = [ pkgs.wofi-emoji ];

    wayland.windowManager.hyprland = {
        enable = true;
        # Lua config (hyprland.lua) so DankMaterialShell can manage its fragments in ~/.config/hypr/dms/
        configType = "lua";

        extraConfig = ''
            -- --- Monitor Configuration ---
            hl.monitor({ output = "${monitor1}", mode = "2560x1440@144", position = "0x0", scale = 1, bitdepth = 10 })
            hl.monitor({ output = "${monitor2}", mode = "1920x1080@75", position = "2560x0", scale = 1, bitdepth = 10 })
            hl.monitor(${monitor3Spec})

            -- --- Workspaces ---
            for i = 1, 5 do
                hl.workspace_rule({ workspace = tostring(i), monitor = "${monitor1}", default = (i == 1) })
            end
            for i = 6, 10 do
                hl.workspace_rule({ workspace = tostring(i), monitor = "${monitor2}", default = (i == 6) })
            end
            hl.workspace_rule({ workspace = "11", monitor = "${monitor3}", default = true })
            hl.workspace_rule({ workspace = "12", monitor = "${monitor3}" })

            -- --- Exec Once ---
            -- Bar, wallpaper, notifications and polkit agent come from DankMaterialShell (dms.nix)
            hl.on("hyprland.start", function()
                hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
                hl.exec_cmd("solaar -w hide")
                hl.exec_cmd("ydotoold")
            end)

            -- --- Variables ---
            local terminal       = "ghostty"
            local fileManager    = "thunar"
            local appMenu        = "dms ipc call spotlight toggle"
            local windowMoveMenu = "hyprmwh --windows"
            local browser        = "zen-twilight"
            local mainMod        = "SUPER"

            hl.env("XCURSOR_SIZE", "24")
            hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
            -- Only plasma-applications.menu is installed; without this, "Open With" menus are empty
            hl.env("XDG_MENU_PREFIX", "plasma-")

            hl.config({
                -- --- Input ---
                input = {
                    kb_layout = "us",
                    follow_mouse = 1,
                    mouse_refocus = true,
                    touchpad = {
                        natural_scroll = false,
                    },
                    accel_profile = "flat",
                    sensitivity = 0,
                },

                -- --- General ---
                general = {
                    gaps_in = 2,
                    gaps_out = 3,
                    border_size = 1,
                    col = {
                        active_border = "rgba(ffffff30)",
                        inactive_border = "rgba(2c2b3180)",
                    },
                    layout = "dwindle",
                    allow_tearing = false,
                },

                -- --- Decoration ---
                decoration = {
                    rounding = 12,
                    blur = {
                        enabled = true,
                        new_optimizations = true,
                        size = 8,
                        passes = 2,
                    },
                    shadow = {
                        enabled = true,
                        range = 10,
                        render_power = 3,
                        color = "rgba(00000040)",
                    },
                },

                -- --- Animations ---
                animations = {
                    enabled = false,
                },

                dwindle = {
                    preserve_split = true,
                },

                misc = {
                    force_default_wallpaper = 0,
                },
            })

            hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1} } })
            hl.animation({ leaf = "windows",     enabled = true, speed = 3,  bezier = "myBezier" })
            hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
            hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
            hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
            hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
            hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })

            -- --- Fix Zoom ---
            hl.window_rule({ name = "zoom-no-follow-mouse", match = { class = "^(zoom)$" }, no_follow_mouse = true })
            hl.window_rule({ name = "zoom-suppress-maximize", match = { class = "^(zoom)$" }, suppress_event = "maximize" })

            hl.layer_rule({ match = { namespace = "Launcher" }, blur = true, ignore_alpha = 0.1 })
            hl.layer_rule({ match = { namespace = "hyprmwh" }, blur = true, ignore_alpha = 0.1 })

            -- --- Keybinds ---
            local function exec(cmd, rules)
                return hl.dsp.exec_cmd(cmd, rules)
            end

            -- System/Rice
            hl.bind(mainMod .. " + RETURN", exec(terminal))
            hl.bind(mainMod .. " + SHIFT + RETURN", exec(terminal, { float = true }))
            hl.bind(mainMod .. " + Q", hl.dsp.window.close())
            hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit())
            hl.bind(mainMod .. " + E", exec(fileManager))
            hl.bind(mainMod .. " + SHIFT + E", exec(fileManager, { float = true }))
            hl.bind(mainMod .. " + W", exec(browser))
            hl.bind(mainMod .. " + TAB", hl.dsp.window.float({ action = "toggle" }))
            hl.bind(mainMod .. " + SPACE", exec(appMenu))
            hl.bind(mainMod .. " + grave", exec(windowMoveMenu))
            hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
            hl.bind(mainMod .. " + V", hl.dsp.layout("togglesplit"))
            hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }))
            hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
            hl.bind(mainMod .. " + Escape", hl.dsp.focus({ last = true }))
            hl.bind(mainMod .. " + SHIFT + P", exec("systemctl --user restart dms"))
            hl.bind(mainMod .. " + SHIFT + S", exec("dms screenshot region --no-confirm"))
            hl.bind(mainMod .. " + HOME", exec("wofi-emoji"))

            -- Focus / Move / Resize
            local dirs = { h = "left", l = "right", k = "up", j = "down" }
            local resize = { h = { -160, 0 }, l = { 160, 0 }, k = { 0, -160 }, j = { 0, 160 } }
            for key, dir in pairs(dirs) do
                hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = dir }))
                hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
                hl.bind(mainMod .. " + ALT + " .. key,
                    hl.dsp.window.resize({ x = resize[key][1], y = resize[key][2], relative = true }))
            end

            -- Workspaces 1-10 on number keys, 11-12 on ALT+1/2
            for i = 1, 10 do
                local key = i % 10
                hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
                hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
            end
            for i = 11, 12 do
                local key = i - 10
                hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.focus({ workspace = i }))
                hl.bind(mainMod .. " + ALT + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
            end

            -- Special
            hl.bind(mainMod .. " + O", hl.dsp.workspace.toggle_special("magic"))
            hl.bind(mainMod .. " + SHIFT + O", hl.dsp.window.move({ workspace = "special:magic" }))

            -- Custom scripts
            hl.bind(mainMod .. " + b", exec("dms ipc call bar toggle"))
            hl.bind(mainMod .. " + minus", exec("${toggleMonitor}"))

            -- DankMaterialShell
            hl.bind(mainMod .. " + comma", exec("dms ipc call settings focusOrToggle"))
            hl.bind(mainMod .. " + N", exec("dms ipc call notifications toggle"))
            hl.bind(mainMod .. " + SHIFT + V", exec("dms ipc call clipboard toggle"))
            hl.bind(mainMod .. " + X", exec("dms ipc call powermenu toggle"))
            hl.bind(mainMod .. " + SHIFT + D", exec("dms ipc call lock lock"))
            hl.bind(mainMod .. " + SHIFT + slash", exec("dms ipc call keybinds toggle hyprland"))
            hl.bind("CTRL + ALT + Delete", exec("dms ipc call processlist focusOrToggle"))

            -- Mouse: back thumb button -> middle click (mchose mouse)
            hl.bind("mouse:275", exec("ydotool click 0xC2"))

            -- Volume/media via DMS (shows OSD)
            hl.bind("XF86AudioRaiseVolume", exec("dms ipc call audio increment 2"), { locked = true, repeating = true })
            hl.bind("XF86AudioLowerVolume", exec("dms ipc call audio decrement 2"), { locked = true, repeating = true })
            hl.bind("XF86AudioMute", exec("dms ipc call audio mute"), { locked = true })
            hl.bind("XF86AudioMicMute", exec("dms ipc call audio micmute"), { locked = true })
            hl.bind("XF86AudioPrev", exec("dms ipc call mpris previous"), { locked = true })
            hl.bind("XF86AudioPlay", exec("dms ipc call mpris playPause"), { locked = true })
            hl.bind("XF86AudioPause", exec("dms ipc call mpris playPause"), { locked = true })
            hl.bind("XF86AudioNext", exec("dms ipc call mpris next"), { locked = true })

            -- Mouse move/resize
            hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
            hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

            -- Mouse scroll workspaces
            hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { non_consuming = true })
            hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { non_consuming = true })

            -- --- DankMaterialShell fragments ---
            -- Written by the DMS settings GUI into ~/.config/hypr/dms/; loaded last so they override the above.
            -- Missing files are skipped. DMS can't add these lines itself (this file is read-only), so each
            -- settings page it should manage needs its line here. dms.binds/binds-user start empty and only
            -- hold binds added or changed in the DMS keybinds page.
            -- dms.outputs is deliberately not loaded: monitors (10-bit) stay in this file.
            local function dms_require(name)
                local ok, err = pcall(require, name)
                if not ok and not tostring(err):find("module '" .. name .. "' not found", 1, true) then
                    error(err)
                end
            end
            dms_require("dms.layout")
            dms_require("dms.cursor")
            dms_require("dms.windowrules")
            dms_require("dms.colors")
            dms_require("dms.binds")
            dms_require("dms.binds-user")
        '';
    };
}
