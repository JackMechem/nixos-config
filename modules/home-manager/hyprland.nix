{ pkgs, ... }:
{
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
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "solaar -w hide"
        ];

        # --- Variables ---
        "$terminal" = "ghostty";
        "$fileManager" = "thunar";
        "$menu" = "gtkapps";

        env = [
          "XCURSOR_SIZE,24"
          "QT_QPA_PLATFORMTHEME,qt5ct"
        ];

        # --- Input ---
        input = {
          kb_layout = "us";
          kb_options = "caps:escape";
          follow_mouse = 1;
          mouse_refocus = false;
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
