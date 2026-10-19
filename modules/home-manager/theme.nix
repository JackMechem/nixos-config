{ config, pkgs, ... }:

{
    gtk = {
        enable = true;
        iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
        };
        # Plasma rewrites ~/.gtkrc-2.0 on every login, which made home-manager
        # fail with "would be clobbered". Keep ours under ~/.config instead.
        gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    };

    home.pointerCursor = {
        enable = true;
        gtk.enable = true;
        x11.enable = true;
        name = "capitaine-cursors";
        package = pkgs.capitaine-cursors;
        size = 32;
    };
}
