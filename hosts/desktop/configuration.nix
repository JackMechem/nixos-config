{
    config,
    lib,
    pkgs,
    inputs,
    ...
}:

{
    imports = [
        ./hardware-configuration.nix
        inputs.home-manager.nixosModules.default
        ../../modules/nixos/gtkapps.nix
        ../../modules/nixos/gtkbar.nix
        ../../modules/nixos/fonts.nix
        ../../modules/nixos/system-packages.nix
        ../../modules/nixos/user-jack.nix
        ../../modules/nixos/sound.nix
        ../../modules/nixos/print.nix
        ../../modules/nixos/syncthing.nix
        ../../modules/nixos/ollama.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_6;

    networking.hostName = "jackdesk";
    networking.networkmanager.enable = true;
    networking.nameservers = [ "192.168.1.164" ];

    networking.firewall.allowedTCPPorts = [
        2200
        3000
    ];

    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];

    time.timeZone = "America/Los_Angeles";

    services.dbus.enable = true;

    programs.zsh.enable = true;

    programs.nix-ld.enable = true;

    programs.thunar.enable = true;

    programs.dconf.enable = true;

    nixpkgs.config.allowUnfree = true;

    #    services.gtkapps.enable = true;
    services.gtkbar.enable = true;

    nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (pkgs.lib.getName pkg) [
            "diskdigger"
        ];

    environment.systemPackages = [
        inputs.rust-app-menu.packages.${pkgs.system}.default
        inputs.diskdigger.packages.${pkgs.system}.diskdigger
    ];

    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    #  services.midirun = {
    #        enable = true;
    #    };

    xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
            xdg-desktop-portal-hyprland
            xdg-desktop-portal-gnome
        ];
    };

    home-manager = {
        extraSpecialArgs = { inherit inputs; };
        users = {
            "jack" = import ./home.nix;
        };
    };

    virtualisation.docker.enable = true;

    services.libinput.enable = true;

    services.openssh = {
        enable = true;
    };

    services.gvfs.enable = true;

    services.input-remapper.enable = true;

    system.stateVersion = "25.11";

}
