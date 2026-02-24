{ pkgs, ... }:
{
    home.packages = with pkgs; [
        ### Desktop Stuff
        pkgs.sway-contrib.grimshot
        waypaper
        hyprpaper
        swaybg

        ### Audio
        playerctl
        spotify
        pavucontrol

        ### Chat apps
        lunar-client
        discord
        zoom-us

        ### Random Libraries and Dependencies
        gtk3
        glib
        zlib
        deno
    ];
}
