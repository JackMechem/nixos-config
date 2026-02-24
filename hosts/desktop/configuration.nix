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
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_6;

    networking.hostName = "jackdesk";
    networking.networkmanager.enable = true;

    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];

    time.timeZone = "America/Los_Angeles";

    services.dbus.enable = true;

    programs.zsh.enable = true;

    programs.thunar.enable = true;

    programs.dconf.enable = true;

    nixpkgs.config.allowUnfree = true;

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

    services.libinput.enable = true;

    services.openssh.enable = true;

    services.gvfs.enable = true;

    system.stateVersion = "25.11";

}
