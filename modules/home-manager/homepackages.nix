{ inputs, pkgs, ... }:
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

        ### Authentication
        bitwarden-desktop

        ### Chat apps
        lunar-client
        discord
        zoom-us

        ### Note Taking
        obsidian

        ### Random Libraries and Dependencies
        gtk3
        glib
        zlib
        deno

        ### System Monitoring Tools
        mission-center
        htop

        ### Development Tools
        jdk
        gnumake
        inputs.claude-code.packages.${pkgs.system}.claude-code

        ### My Stuff
        inputs.hyprmwh.packages.${pkgs.system}.default
    ];
}
