{ pkgs, ... }:
{
    programs.hyprlock = {
        enable = true;
        settings = {
            general = {
                disable_loading_bar = true;
                grace = 0;
                hide_cursor = true;
            };
            background = [{
                monitor = "";
                path = "screenshot";
                blur_passes = 3;
                blur_size = 8;
                brightness = 0.5;
            }];
            label = [
                {
                    monitor = "";
                    text = "Property of Jack Mechem — 702.201.4608";
                    color = "rgba(c5c9c5ff)";
                    font_size = 22;
                    font_family = "JetBrainsMono Nerd Font Bold";
                    position = "0, 200";
                    halign = "center";
                    valign = "center";
                }
                {
                    monitor = "";
                    text = "If found — please contact me and return it ASAP.";
                    color = "rgba(c5c9c5ff)";
                    font_size = 13;
                    font_family = "JetBrainsMono Nerd Font";
                    position = "0, 166";
                    halign = "center";
                    valign = "center";
                }
                {
                    monitor = "";
                    text = "If stolen — fuck you.";
                    color = "rgba(c4746eff)";
                    font_size = 16;
                    font_family = "JetBrainsMono Nerd Font Bold";
                    position = "0, 138";
                    halign = "center";
                    valign = "center";
                }
                {
                    monitor = "";
                    text = "The drive is encrypted and the BIOS is locked. You'll get maybe $150 for it.";
                    color = "rgba(c5c9c580)";
                    font_size = 11;
                    font_family = "JetBrainsMono Nerd Font";
                    position = "0, 112";
                    halign = "center";
                    valign = "center";
                }
                {
                    monitor = "";
                    text = "Contact me now and I won't involve the police. I also have a GPS tracker installed.";
                    color = "rgba(c5c9c580)";
                    font_size = 11;
                    font_family = "JetBrainsMono Nerd Font";
                    position = "0, 94";
                    halign = "center";
                    valign = "center";
                }
                {
                    monitor = "";
                    text = "If you're in my class messing with this — fuck you too, don't touch my shit.";
                    color = "rgba(c5c9c5ff)";
                    font_size = 11;
                    font_family = "JetBrainsMono Nerd Font";
                    position = "0, 76";
                    halign = "center";
                    valign = "center";
                }
            ];
            input-field = [{
                monitor = "";
                size = "250, 50";
                outline_thickness = 2;
                dots_size = 0.33;
                dots_spacing = 0.15;
                dots_center = true;
                outer_color = "rgba(e4687690)";
                inner_color = "rgba(181616cc)";
                font_color = "rgba(c5c9c5ff)";
                fade_on_empty = true;
                placeholder_text = "<i>Password...</i>";
                rounding = 12;
                check_color = "rgba(8a9a7bff)";
                fail_color = "rgba(c4746eff)";
                fail_text = "<i>$FAIL ($ATTEMPTS)</i>";
                position = "0, 0";
                halign = "center";
                valign = "center";
            }];
        };
    };

    services.hypridle = {
        enable = true;
        settings = {
            general = {
                before_sleep_cmd = "loginctl lock-session";
                after_sleep_cmd = "hyprctl dispatch dpms on";
                lock_cmd = "pidof hyprlock || hyprlock";
            };
            listener = [
                {
                    timeout = 300;
                    on-timeout = "loginctl lock-session";
                }
                {
                    timeout = 600;
                    on-timeout = "hyprctl dispatch dpms off";
                    on-resume = "hyprctl dispatch dpms on";
                }
            ];
        };
    };

    wayland.windowManager.hyprland = {
        enable = true;

        settings =
            let
                monitor1 = "eDP-1";
                mainMod = "SUPER";
            in
            {
                # --- Monitor Configuration ---
                monitor = [
                    "${monitor1},1920x1080@60,0x0,1,bitdepth,10"
                ];

                # --- Workspaces ---
                workspace = [
                    "1,monitor:${monitor1}"
                    "2,monitor:${monitor1}"
                    "3,monitor:${monitor1}"
                    "4,monitor:${monitor1}"
                    "5,monitor:${monitor1}"
                    "6,monitor:${monitor1}"
                    "7,monitor:${monitor1}"
                    "8,monitor:${monitor1}"
                    "9,monitor:${monitor1}"
                    "10,monitor:${monitor1}"
                ];

                # --- Exec Once ---
                exec-once = [
                    "waypaper --restore"
                    "gtkbar"
                    "rust-app-menu -d"
                    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                    "solaar -w hide"
                ];

                # --- Variables ---
                "$terminal" = "ghostty";
                "$fileManager" = "thunar";
                "$menu" = "rust-app-menu -ds";

                env = [
                    "XCURSOR_SIZE,24"
                    "QT_QPA_PLATFORMTHEME,qt5ct"
                ];

                # --- Input ---
                input = {
                    kb_layout = "us";
                    kb_options = "caps:escape";
                    follow_mouse = 1;
                    mouse_refocus = true;
                    touchpad = {
                        natural_scroll = "no";
                    };
                    accel_profile = "flat";
                    sensitivity = 1;
                };

                device = {
                    name = "synaptics-tm3276-022";
                    enabled = false;
                };

                # --- General ---
                general = {
                    gaps_in = 3;
                    gaps_out = "10,10,10,10";
                    border_size = 2;
                    "col.active_border" = "rgba(e4687690)";
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
                    "ignore_alpha 0.3, match:namespace Launcher"
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
                        range = 20;
                        render_power = 5;
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
                    pseudotile = "yes";
                    preserve_split = "yes";
                };

                misc = {
                    force_default_wallpaper = 0;
                };

                # --- Keybinds ---
                bind = [
                    # System/Rice
                    "${mainMod} SHIFT, D, exec, loginctl lock-session"
                    "${mainMod}, grave, exec, rice-settings"
                    "${mainMod}, RETURN, exec, $terminal"
                    "${mainMod} SHIFT, RETURN, exec, [float] $terminal"
                    "${mainMod}, Q, killactive"
                    "${mainMod} SHIFT, M, exit"
                    "${mainMod}, E, exec, $fileManager"
                    "${mainMod} SHIFT, E, exec, [float] $fileManager"
                    "${mainMod}, W, exec, zen-browser"
                    "${mainMod}, TAB, togglefloating"
                    "${mainMod}, SPACE, exec, $menu"
                    "${mainMod}, P, pseudo"
                    "${mainMod}, V, togglesplit"
                    "${mainMod}, M, fullscreen, 1"
                    "${mainMod}, F, fullscreen, 0"
                    "${mainMod}, Escape, focuscurrentorlast"
                    "${mainMod} SHIFT, P, exec, killall ags || exec ags"
                    "${mainMod} SHIFT, S, exec, grimshot savecopy area"
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

                    # Multimedia
                    ", XF86AudioPrev, exec, playerctl previous"
                    ", XF86AudioPlay, exec, playerctl play-pause"
                    ", XF86AudioPause, exec, playerctl pause"
                    ", XF86AudioNext, exec, playerctl next"

                    # Custom scripts
                    "${mainMod}, b, exec, bash -c 'pgrep gtkbar &>/dev/null && killall gtkbar || gtkbar &'"
                ];

                bindle = [
                    ", XF86AudioRaiseVolume, exec, pamixer -i 2"
                    ", XF86AudioLowerVolume, exec, pamixer -d 2"
                ];

                bindl = [
                    ", XF86AudioMute, exec, pamixer -t"
                    ", XF86AudioMicMute, exec, pamixer --default-source -t"
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
