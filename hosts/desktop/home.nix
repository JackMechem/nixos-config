{
  config,
  pkgs,
  inputs,
  ...
}:

{

  imports = [
    inputs.zen-browser.homeModules.twilight
    ../../modules/home-manager/zsh.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/hyprland-desktop.nix
    ../../modules/home-manager/homepackages.nix
    ../../modules/home-manager/shell-aliases.nix
    ../../modules/home-manager/neovimpackages.nix
  ];

  programs.home-manager.enable = true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jack";
  home.homeDirectory = "/home/jack";

  home.stateVersion = "25.05"; # Please read the comment before changing.

  programs.zen-browser.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = { };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  gtk = {
    enable = true;

    theme = {
      name = "Kanagawa-B";
      package = pkgs.kanagawa-gtk-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "capitaine-cursors";
    package = pkgs.capitaine-cursors;
    size = 32; # optional, adjust as needed
  };

  xdg.configFile = {
    "gtk-4.0/assets".source =
      "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source =
      "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source =
      "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  programs.ghostty = {
    enable = true;

    # If you're on a channel/flake that has ghostty packaged:
    # comment this out if you install ghostty some other way
    package = pkgs.ghostty;

    settings = {
      # ----- basic look -----
      "font-family" = "JetBrainsMono Nerd Font";
      "font-size" = 14;

      "window-padding-x" = 8;
      "window-padding-y" = 8;

      # ----- your theme -----
      # repeated keys like `palette` become a list
      palette = [
        "0=#181616"
        "1=#c4746e"
        "2=#8a9a7b"
        "3=#c4b28a"
        "4=#8ba4b0"
        "5=#a292a3"
        "6=#8ea4a2"
        "7=#bcb093"
        "8=#a6a69c"
        "9=#e46876"
        "10=#87a987"
        "11=#6c8384"
        "12=#7fb4ca"
        "13=#938aa9"
        "14=#7aa89f"
        "15=#c5c9c5"
      ];

      background = "#181616";
      foreground = "#c5c9c5";
      "cursor-color" = "#c8c093";
      "selection-background" = "#2d4f67";
      "selection-foreground" = "#c8c093";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

}
