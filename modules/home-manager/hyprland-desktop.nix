{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''

$monitor1 = DP-1
$monitor2 = DP-2
$monitor3 = HDMI-A-1

# Configure Monitors
monitor=$monitor1,2560x1440@144,0x0,1,bitdepth,10
monitor=$monitor2,1920x1080@75,2560x0,1,bitdepth,10
monitor=HDMI-A-1,1920x1080@60,-2560x0,1,bitdepth,10

# Workspaces
workspace=1,monitor:$monitor1,default:true
workspace=2,monitor:$monitor1
workspace=3,monitor:$monitor1
workspace=4,monitor:$monitor1
workspace=5,monitor:$monitor1
workspace=6,monitor:$monitor2,default:true
workspace=7,monitor:$monitor2
workspace=8,monitor:$monitor2
workspace=9,monitor:$monitor2
workspace=10,monitor:$monitor2
workspace=11,monitor:$monitor3,default:true
workspace=12,monitor:$monitor3



# Start Shit
#exec-once = sh /home/jack/.config/waybar/launch-waybar.sh & waypaper --restore
exec-once = waypaper --restore
exec-once = gtkbar
exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once=solaar -w hide
# Source a file (multi-file configs)
# source = ~/.config/hypr/myColors.conf

# Set programs that you use
$terminal = ghostty
$fileManager = thunar
#$menu = XDG_DATA_DIRS="/usr/share:/usr/local/share:/var/lib/flatpak/exports/share:/home/jack/.local/share/flatpak/exports/share" wofi --show drun
$menu = gtkapps

# Some default env vars.
env = XCURSOR_SIZE,24
env = QT_QPA_PLATFORMTHEME,qt5ct # change to qt6ct if you have that

# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1
    mouse_refocus = false

    touchpad {
        natural_scroll = no
    }

    accel_profile = flat

    sensitivity = 0 # -1.0 to 1.0, 0 means no modification.
}

general {
    gaps_in = 3
    gaps_out = 10,10,10,10
    border_size = 2
    col.active_border = rgba(e4687690)
    col.inactive_border = rgba(2c2b3180)

    # Every other layout is bad
    layout = dwindle

    # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on (Why tf would you turn this on)
    allow_tearing = false
}

decoration {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 12
    
    blur {
        enabled = true
        new_optimizations = true
        size = 8
        passes = 2
    }

    shadow {
        enabled = true
        range = 20
        render_power = 5
        color = rgba(00000040)
    }

    #layerrule = blur,notifications
    #layerrule = ignorezero,notifications
    #layerrule = blur,gtk4-layer-shell
    #layerrule = ignorealpha 0.3,gtk4-layer-shell
    #layerrule = blur,gtkapps
}

animations {
    enabled = false

    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = myBezier, 0.05, 0.9, 0.1, 1

    animation = windows, 1, 3, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

dwindle {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = yes # you probably want this
}

# master {
#     # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
#     new_is_master = true
# }


misc {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    force_default_wallpaper = 0 # Set to 0 or 1 to disable the anime mascot wallpapers
}


# Example windowrule v1
# windowrule = float, ^(kitty)$
# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
#windowrule = suppressevent maximize, class:.* # You'll probably like this.
#windowrule = float,class:^(pavucontrol)$
#windowrule = float,class:^(nwg-look)$
#windowrule = float,class:^(waypaper)$
#windowrule = float,class:^(openrgb)$
#windowrule = float,class:^(solaar)$
#windowrule = float,class:^(rice-settings)$



# See https://wiki.hyprland.org/Configuring/Keywords/ for more
$mainMod = SUPER

# Rice Settings (Developed by me)
bind = SUPER, grave, exec, rice-settings


# Multimedia Keys
bindle = , XF86AudioRaiseVolume, exec, pamixer -i 2
bindle = , XF86AudioLowerVolume, exec, pamixer -d 2
bindl = , XF86AudioMute, exec, pamixer -t
bindl = , XF86AudioMicMute, exec, pamixer --default-source -t
bind = , XF86AudioPrev, exec, playerctl previous
bind = , XF86AudioPlay, exec, playerctl play-pause
bind = , XF86AudioPause, exec, playerctl pause
bind = , XF86AudioNext, exec, playerctl next

bind = $mainMod, RETURN, exec, $terminal
bind = $mainMod SHIFT, RETURN, exec, [float] $terminal
bind = $mainMod, Q, killactive, 
bind = $mainMod SHIFT, M, exit, 
bind = $mainMod, E, exec, $fileManager
bind = $mainMod SHIFT, E, exec, [float] $fileManager
bind = $mainMod, W, exec, zen-browser
bind = $mainMod, TAB, togglefloating, 
bind = $mainMod, SPACE, exec, $menu
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, V, togglesplit, # dwindle
bind = $mainMod, M, fullscreen, 1
bind = $mainMod, F, fullscreen, 0

# mouse_refocus = false work around since I need this set to false for zoom to work properly...
bind = $mainMod, Escape, focuscurrentorlast

# Hide Bar
bind = $mainMod SHIFT, P, exec, killall ags || exec ags

# screenshot
bind = $mainMod SHIFT, S, exec, grimshot savecopy area

# emojis
bind = $mainMod, HOME, exec, wofi-emoji


# Window focus
bind = SUPER, h, movefocus, l
bind = SUPER, l, movefocus, r
bind = SUPER, k, movefocus, u
bind = SUPER, j, movefocus, d

# Move window
bind = SUPER SHIFT, h, movewindow, l
bind = SUPER SHIFT, l, movewindow, r
bind = SUPER SHIFT, k, movewindow, u
bind = SUPER SHIFT, j, movewindow, d

# Resize window
bind = SUPER ALT, h, resizeactive, -160 0
bind = SUPER ALT, l, resizeactive, 160 0
bind = SUPER ALT, k, resizeactive, 0 -160
bind = SUPER ALT, j, resizeactive, 0 160

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10
bind = $mainMod ALT, 1, workspace, 11
bind = $mainMod ALT, 2, workspace, 12

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10
bind = $mainMod ALT SHIFT, 1, movetoworkspace, 11
bind = $mainMod ALT SHIFT, 2, movetoworkspace, 12

# Example special workspace (scratchpad)
bind = $mainMod, O, togglespecialworkspace, magic
bind = $mainMod SHIFT, O, movetoworkspace, special:magic

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# Toggle bar
bind = $mainMod,b,exec,bash -c 'pgrep gtkbar &>/dev/null && killall gtkbar || gtkbar &'

# Toggle extra monitor
bind = $mainMod, minus, exec, ~/.config/hypr/togglemonitor.sh $monitor3
    '';
  };
}
