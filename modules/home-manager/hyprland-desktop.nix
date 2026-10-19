{ pkgs, ... }:
let
    # Toggle a monitor off/on, restoring its layout from the monitor list below
    toggleMonitor = pkgs.writeShellScript "togglemonitor" ''
        mon="$1"
        line="$2"
        if ${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -e --arg m "$mon" '.[] | select(.name == $m)' >/dev/null; then
            ${pkgs.hyprland}/bin/hyprctl keyword monitor "$mon,disable"
        else
            ${pkgs.hyprland}/bin/hyprctl keyword monitor "$line"
        fi
    '';
in
{
    home.packages = [ pkgs.wofi-emoji ];

    wayland.windowManager.hyprland = {
        enable = true;
        # Keep the hyprland.conf format; switching to "lua" means rewriting settings
        configType = "hyprlang";

        settings =
            let
                monitor3Line = "${monitor3},1920x1080@60,-2560x0,1,bitdepth,10";
                monitor1 = "DP-1";
                monitor2 = "DP-2";
                monitor3 = "HDMI-A-1";
                mainMod = "SUPER";
            in
            {
                # --- Monitor Configuration ---
                monitor = [
                    "${monitor1},2560x1440@144,0x0,1,bitdepth,10"
                    "${monitor2},1920x1080@75,2560x0,1,bitdepth,10"
                    monitor3Line
                ];

                # --- Workspaces ---
                workspace = [
                    "1,monitor:${monitor1},default:true"
                    "2,monitor:${monitor1}"
                    "3,monitor:${monitor1}"
                    "4,monitor:${monitor1}"
                    "5,monitor:${monitor1}"
                    "6,monitor:${monitor2},default:true"
                    "7,monitor:${monitor2}"
                    "8,monitor:${monitor2}"
                    "9,monitor:${monitor2}"
                    "10,monitor:${monitor2}"
                    "11,monitor:${monitor3},default:true"
                    "12,monitor:${monitor3}"
                ];

                # --- Exec Once ---
                exec-once = [
                    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                    "solaar -w hide"
                    "ydotoold"
                    # Bar, wallpaper, notifications and polkit agent come from DankMaterialShell (dms.nix)
                ];

                # --- Variables ---
                "$terminal" = "ghostty";
                "$fileManager" = "thunar";
                "$appMenu" = "dms ipc call spotlight toggle";
                "$windowMoveMenu" = "hyprmwh --windows";
                "$browser" = "zen-twilight";
                #"$menu" = "rust-app-menu -ds";

                env = [
                    "XCURSOR_SIZE,24"
                    "QT_QPA_PLATFORMTHEME,qt5ct"
                    # Only plasma-applications.menu is installed; without this, "Open With" menus are empty
                    "XDG_MENU_PREFIX,plasma-"
                ];

                # --- Input ---
                input = {
                    kb_layout = "us";
                    follow_mouse = 1;
                    mouse_refocus = true;
                    touchpad = {
                        natural_scroll = "no";
                    };
                    accel_profile = "flat";
                    sensitivity = 0;
                };

                # --- General ---
                general = {
                    gaps_in = 2;
                    gaps_out = 3;
                    border_size = 1;
                    "col.active_border" = "rgba(ffffff30)";
                    "col.inactive_border" = "rgba(2c2b3180)";
                    layout = "dwindle";
                    allow_tearing = false;
                };

                # --- Fix Zoom ---
                windowrule = [
                    "match:class ^(zoom)$, no_follow_mouse 1"
                    "match:class ^(zoom)$, suppress_event maximize"
                ];

                layerrule = [
                    "blur on, match:namespace Launcher"
                    "ignore_alpha 0.1, match:namespace Launcher"
                    "blur on, match:namespace hyprmwh"
                    "ignore_alpha 0.1, match:namespace hyprmwh"
                ];

                # --- Decoration ---
                decoration = {
                    rounding = 12;
                    blur = {
                        enabled = true;
                        new_optimizations = true;
                        size = 8;
                        passes = 2;
                    };
                    shadow = {
                        enabled = true;
                        range = 10;
                        render_power = 3;
                        color = "rgba(00000040)";
                    };
                };

                # --- Animations ---
                animations = {
                    enabled = false;
                    bezier = "myBezier, 0.05, 0.9, 0.1, 1";
                    animation = [
                        "windows, 1, 3, myBezier"
                        "windowsOut, 1, 7, default, popin 80%"
                        "border, 1, 10, default"
                        "borderangle, 1, 8, default"
                        "fade, 1, 7, default"
                        "workspaces, 1, 6, default"
                    ];
                };

                dwindle = {
                    preserve_split = "yes";
                };

                misc = {
                    force_default_wallpaper = 0;
                };

                # --- Keybinds --- 
                bind = [
                    # System/Rice
                    "${mainMod}, RETURN, exec, $terminal"
                    "${mainMod} SHIFT, RETURN, exec, [float] $terminal"
                    "${mainMod}, Q, killactive"
                    "${mainMod} SHIFT, M, exit"
                    "${mainMod}, E, exec, $fileManager"
                    "${mainMod} SHIFT, E, exec, [float] $fileManager"
                    "${mainMod}, W, exec, $browser"
                    "${mainMod}, TAB, togglefloating"
                    "${mainMod}, SPACE, exec, $appMenu"
                    "${mainMod}, grave, exec, $windowMoveMenu"
                    "${mainMod}, P, pseudo"
                    "${mainMod}, V, layoutmsg, togglesplit"
                    "${mainMod}, M, fullscreen, 1"
                    "${mainMod}, F, fullscreen, 0"
                    "${mainMod}, Escape, focuscurrentorlast"
                    "${mainMod} SHIFT, P, exec, systemctl --user restart dms"
                    "${mainMod} SHIFT, S, exec, dms screenshot region --no-confirm"
                    "${mainMod}, HOME, exec, wofi-emoji"

                    # Focus
                    "${mainMod}, h, movefocus, l"
                    "${mainMod}, l, movefocus, r"
                    "${mainMod}, k, movefocus, u"
                    "${mainMod}, j, movefocus, d"

                    # Move
                    "${mainMod} SHIFT, h, movewindow, l"
                    "${mainMod} SHIFT, l, movewindow, r"
                    "${mainMod} SHIFT, k, movewindow, u"
                    "${mainMod} SHIFT, j, movewindow, d"

                    # Resize
                    "${mainMod} ALT, h, resizeactive, -160 0"
                    "${mainMod} ALT, l, resizeactive, 160 0"
                    "${mainMod} ALT, k, resizeactive, 0 -160"
                    "${mainMod} ALT, j, resizeactive, 0 160"

                    # Workspaces
                    "${mainMod}, 1, workspace, 1"
                    "${mainMod}, 2, workspace, 2"
                    "${mainMod}, 3, workspace, 3"
                    "${mainMod}, 4, workspace, 4"
                    "${mainMod}, 5, workspace, 5"
                    "${mainMod}, 6, workspace, 6"
                    "${mainMod}, 7, workspace, 7"
                    "${mainMod}, 8, workspace, 8"
                    "${mainMod}, 9, workspace, 9"
                    "${mainMod}, 0, workspace, 10"
                    "${mainMod} ALT, 1, workspace, 11"
                    "${mainMod} ALT, 2, workspace, 12"

                    # Move to Workspace
                    "${mainMod} SHIFT, 1, movetoworkspace, 1"
                    "${mainMod} SHIFT, 2, movetoworkspace, 2"
                    "${mainMod} SHIFT, 3, movetoworkspace, 3"
                    "${mainMod} SHIFT, 4, movetoworkspace, 4"
                    "${mainMod} SHIFT, 5, movetoworkspace, 5"
                    "${mainMod} SHIFT, 6, movetoworkspace, 6"
                    "${mainMod} SHIFT, 7, movetoworkspace, 7"
                    "${mainMod} SHIFT, 8, movetoworkspace, 8"
                    "${mainMod} SHIFT, 9, movetoworkspace, 9"
                    "${mainMod} SHIFT, 0, movetoworkspace, 10"
                    "${mainMod} ALT SHIFT, 1, movetoworkspace, 11"
                    "${mainMod} ALT SHIFT, 2, movetoworkspace, 12"

                    # Special
                    "${mainMod}, O, togglespecialworkspace, magic"
                    "${mainMod} SHIFT, O, movetoworkspace, special:magic"

                    # Custom scripts
                    "${mainMod}, b, exec, dms ipc call bar toggle"
                    "${mainMod}, minus, exec, ${toggleMonitor} ${monitor3} '${monitor3Line}'"

                    # DankMaterialShell
                    "${mainMod}, comma, exec, dms ipc call settings focusOrToggle"
                    "${mainMod}, N, exec, dms ipc call notifications toggle"
                    "${mainMod} SHIFT, V, exec, dms ipc call clipboard toggle"
                    "${mainMod}, X, exec, dms ipc call powermenu toggle"
                    "${mainMod} SHIFT, D, exec, dms ipc call lock lock"
                    "${mainMod} SHIFT, slash, exec, dms ipc call keybinds toggle hyprland"
                    "CTRL ALT, Delete, exec, dms ipc call processlist focusOrToggle"

                    # Mouse: back thumb button -> middle click (mchose mouse)
                    ", mouse:275, exec, ydotool click 0xC2"
                ];

                # Volume/media via DMS (shows OSD)
                bindle = [
                    ", XF86AudioRaiseVolume, exec, dms ipc call audio increment 2"
                    ", XF86AudioLowerVolume, exec, dms ipc call audio decrement 2"
                ];

                bindl = [
                    ", XF86AudioMute, exec, dms ipc call audio mute"
                    ", XF86AudioMicMute, exec, dms ipc call audio micmute"
                    ", XF86AudioPrev, exec, dms ipc call mpris previous"
                    ", XF86AudioPlay, exec, dms ipc call mpris playPause"
                    ", XF86AudioPause, exec, dms ipc call mpris playPause"
                    ", XF86AudioNext, exec, dms ipc call mpris next"
                ];

                bindm = [
                    "${mainMod}, mouse:272, movewindow"
                    "${mainMod}, mouse:273, resizewindow"
                ];

                # Mouse scroll workspaces
                bindn = [
                    "${mainMod}, mouse_down, workspace, e+1"
                    "${mainMod}, mouse_up, workspace, e-1"
                ];
            };
    };
}
