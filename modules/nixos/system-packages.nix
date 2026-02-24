{ pkgs, inputs, ... }:

{

  programs.firefox.enable = true;
  programs.hyprland.enable = true;

  services.gtkapps.enable = true;
  services.gtkbar.enable = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
        #    neovim
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
}
