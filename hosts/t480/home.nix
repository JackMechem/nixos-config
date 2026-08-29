{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.zen-browser.homeModules.twilight

    # --- Shell ---
    ../../modules/home-manager/zsh.nix
    ../../modules/home-manager/shell-aliases.nix
    ../../modules/home-manager/tmux.nix

    # --- Desktop ---
    ../../modules/home-manager/hyprland-desktop.nix
    ../../modules/home-manager/theme.nix
    ../../modules/home-manager/ghostty.nix

    # --- Tools ---
    ../../modules/home-manager/neovimpackages.nix

    # --- Packages ---
    ../../modules/home-manager/homepackages.nix
  ];

  programs.home-manager.enable = true;

  home.username = "jack";
  home.homeDirectory = "/home/jack";
  home.stateVersion = "25.05";

  home.file = { };
  xdg.configFile = { };

  programs.zen-browser.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
