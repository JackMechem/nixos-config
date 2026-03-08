{ pkgs, ... }:
# let
#   shellAliases = {
#     rebuild-nix = "sudo nixos-rebuild switch --flake /home/jack/nixos/#t480";
#   };
# in
{
  programs.zsh = {
    enable = true;
    #    inherit shellAliases;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    initContent = ''
      ZSH_AUTOSUGGEST_USE_ASYNC=false
      fastfetch -c examples/11
    '';
    oh-my-zsh = {
      enable = true;
      theme = "gentoo";
      plugins = [
        "git"
        "kubectl"
        "helm"
        "docker"
      ];
    };
  };
  programs.bash = {
    enable = true;
    #    inherit shellAliases;
  };
}
