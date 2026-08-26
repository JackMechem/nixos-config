{ config, pkgs, ... }:

{
    services.ollama = {
        enable = true;
        package = pkgs.ollama-rocm;
        rocmOverrideGfx = "11.0.1";
    };

    services.open-webui = {
        enable = true;
        port = 11435;
        openFirewall = true;
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
        ollama
        rocmPackages.rocminfo
    ];
}
