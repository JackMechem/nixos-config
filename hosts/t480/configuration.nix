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
    ../../modules/nixos/syncthing.nix
    ../../modules/nixos/yubikey-pam.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_6_6;

  networking.hostName = "t480";
  networking.networkmanager.enable = true;

  nix.settings = {
    # Use all cores for building
    cores = 0; # 0 = use all available cores
    max-jobs = "auto";

    # Binary caches — fetch pre-built packages instead of compiling
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org" # useful for rust-overlay, lix, etc.
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCUSPs="
    ];

    # Avoid redundant downloads
    http-connections = 128;
    http2 = true;

    # Keep build dependencies around so incremental builds are faster
    keep-outputs = true;
    keep-derivations = true;

    # Experimental features (you likely already have these)
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  time.timeZone = "America/Los_Angeles";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.dbus.enable = true;

  programs.zsh.enable = true;

  programs.thunar.enable = true;

  programs.dconf.enable = true;

  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;

  # services.gtkapps.enable = true;
  services.gtkbar.enable = true;
  environment.systemPackages = [
    inputs.rust-app-menu.packages.${pkgs.system}.default
  ];

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

  system.stateVersion = "25.05";

}
