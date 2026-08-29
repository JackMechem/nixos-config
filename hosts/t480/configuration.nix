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

    # --- Desktop UI ---
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/gtkapps.nix
    ../../modules/nixos/gtkbar.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/bluetooth.nix

    # --- System Services ---
    ../../modules/nixos/sound.nix
    ../../modules/nixos/syncthing.nix

    # --- Users & Auth ---
    ../../modules/nixos/user-jack.nix
    ../../modules/nixos/yubikey-pam.nix
    ../../modules/nixos/yubikey-auth.nix

    # --- Packages ---
    ../../modules/nixos/system-packages.nix
  ];

  # --- Boot ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_6_6;

  # --- Networking ---
  networking.hostName = "t480";
  networking.networkmanager.enable = true;
  networking.nameservers = [ "192.168.1.164" ];

  # --- Nix Settings ---
  nix.settings = {
    cores = 0;
    max-jobs = "auto";
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    http-connections = 128;
    http2 = true;
    keep-outputs = true;
    keep-derivations = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # --- Locale ---
  time.timeZone = "America/Los_Angeles";

  # --- Core Programs ---
  programs.zsh.enable = true;

  # --- Virtualisation ---
  virtualisation.docker.enable = true;

  # --- Laptop-specific ---
  services.logind.settings.Login.HandleLidSwitch = "suspend";
  services.openssh.enable = true;
  services.printing.enable = true;


  # --- Home Manager ---
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users."jack" = import ./home.nix;
  };

  system.stateVersion = "25.05";
}
