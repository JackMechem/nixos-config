# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        inputs.home-manager.nixosModules.default
        ../../modules/nixos/user-jack.nix
        ../../modules/nixos/syncthing.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "dell-xps-nixos-serv"; # Define your hostname.
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [
      "nix-command"
      "flakes"
  ];

  time.timeZone = "America/Los_Angeles";

  services.dbus.enable = true;

  programs.zsh.enable = true;

  programs.dconf.enable = true;

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;

  home-manager = {
      extraSpecialArgs = { inherit inputs; };
      users = {
          "jack" = import ./home.nix;
      };
  };

  environment.systemPackages = with pkgs; [
    neovim
    tree
    vim # Both vim and neovim just in case
    wget
    git
    gcc
    fastfetch
    brightnessctl
    killall
    unzip
    python3
    nodejs
  ];

  virtualisation.docker.enable = true;

  services.libinput.enable = true;

  services.gvfs.enable = true;

  system.stateVersion = "25.11";

}

