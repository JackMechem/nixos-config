{ pkgs, ... }:

{
    gtk = {
        enable = true;
        iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
        };
    };

    home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        name = "capitaine-cursors";
        package = pkgs.capitaine-cursors;
        size = 32;
    };
}
