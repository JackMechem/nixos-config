{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pkgs.sway-contrib.grimshot
    waypaper
    hyprpaper
    swaybg
    gtk3
    glib
    zlib

    # Neovim plugin dependencies
    deno
        
    # LSPs
    lua-language-server
    nil
    nixfmt-rfc-style
    stylua
    nodejs_20
    typescript
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.bash-language-server
    nodePackages.prettier
    nodePackages.eslint_d
    nodePackages.eslint
    nixd
    alejandra

    lunar-client
    discord

    spotify
    pavucontrol

    zoom-us
  ];

    #  environment.variables = {
    #    WEBKIT_DISABLE_COMPOSITING_MODE = "1";
    #  };
}
