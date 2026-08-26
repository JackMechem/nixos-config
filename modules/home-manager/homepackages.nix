{ inputs, pkgs, lib, ... }:

let
    claw-code = pkgs.rustPlatform.buildRustPackage {
        pname = "claw-code";
        version = "unstable-2026";

        src = pkgs.fetchFromGitHub {
            owner = "ultraworkers";
            repo = "claw-code";
            rev = "main";
            hash = "sha256-jGJgKOMn2Un6ZbEPh+7RWB1isvFLD86HWMLKTIBMUNs=";
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

        # ===== Desktop / Wayland =====
        pkgs.sway-contrib.grimshot  # screenshots
        waypaper
        hyprpaper
        swaybg

        # ===== Audio =====
        playerctl
        pavucontrol

        # ===== Authentication =====
        bitwarden-desktop

        # ===== Communication =====
        discord
        zoom-us

        # ===== Gaming =====
        lunar-client

        # ===== Note Taking =====
        obsidian

        # ===== System Monitoring =====
        mission-center
        htop

        # ===== Development Tools =====
        jdk
        gnumake
        postman
        inputs.claude-code.packages.${pkgs.system}.claude-code
        claw-code
        opencode

        # ===== Libraries / Runtimes =====
        gtk3
        glib
        zlib
        deno
        pnpm

        # ===== Browsers =====
        epiphany
        chromium

        # ===== Editors =====
        zed-editor

        # ===== Privacy / Security =====
        tor-browser
        proton-vpn

        # ===== Flake Packages =====
        inputs.hyprmwh.packages.${pkgs.system}.default
    ];
}
