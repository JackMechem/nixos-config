{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.shellAliases = {
    nixrebt = "sudo nixos-rebuild switch --flake /home/jack/nixos/#t480";
    nixrebd = "sudo nixos-rebuild switch --flake /home/jack/nixos/#desktop";
    nixrebs = "sudo nixos-rebuild switch --flake /home/jack/nixos/#dellserv";
    v = "nvim";
    c = "clear";
    cl = "clear && ls";
    nixconf = "nvim ~/nixos/";
    a = ''echo -e " a -> List aliases\n nixreb[t,d] -> Rebuild nixos config [t for #t480, d for #dektop]\n nixconf -> Open nixos config\n v -> nvim\n c -> clear\n cl -> clear && ls"'';
  };
}
