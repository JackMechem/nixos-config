{ inputs, pkgs, lib, ... }:

let
    claw-code = pkgs.rustPlatform.buildRustPackage {
        pname = "claw-code";
        version = "unstable-2026";

        src = pkgs.fetchFromGitHub {
            owner = "ultraworkers";
            repo = "claw-code";
            rev = "main";
            hash = "sha256-y63Kx7B1q2gWUO/4/k8hUgHzuKTi+HF+cGbr1em0grs=";
        };

        sourceRoot = "source/rust";

        cargoHash = "sha256-bZKghBTbKrhm2Jiyg2su1c9Jlx2HVrMQjOTK6cgEc00=";

        doCheck = false;

        meta = {
            description = "Open-source Rust implementation of the claw CLI agent harness";
            homepage = "https://github.com/ultraworkers/claw-code";
        };
    };
in
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

        ### Input Remapping
        ydotool

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
        claw-code
        opencode
        postman

        ### My Stuff
        inputs.hyprmwh.packages.${pkgs.system}.default

        ### Browsers
        epiphany
        chromium

        ### Editors
        zed-editor
        jetbrains.idea
    ];
}
