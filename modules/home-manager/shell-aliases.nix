{
    config,
    lib,
    pkgs,
    ...
}:

let
    aliases = [
        {
            name = "nixrebt";
            cmd = "sudo nixos-rebuild switch --flake /home/jack/nixos/#t480";
            desc = "Rebuild NixOS config for t480";
        }
        {
            name = "nixrebd";
            cmd = "sudo nixos-rebuild switch --flake /home/jack/nixos/#desktop";
            desc = "Rebuild NixOS config for desktop";
        }
        {
            name = "nixrebs";
            cmd = "sudo nixos-rebuild switch --flake /home/jack/nixos/#dellserv";
            desc = "Rebuild NixOS config for dellserv";
        }
        {
            name = "nd";
            cmd = "nix develop -c zsh";
            desc = "Enter nix dev shell with zsh";
        }
        {
            name = "v";
            cmd = "nvim";
            desc = "Neovim";
        }
        {
            name = "c";
            cmd = "clear";
            desc = "Clear terminal";
        }
        {
            name = "cl";
            cmd = "clear && ls";
            desc = "Clear and list files";
        }
        {
            name = "nixconf";
            cmd = "nvim ~/nixos/";
            desc = "Open nixos config in nvim";
        }
    ];

    helpText = lib.concatMapStringsSep "\\n" (a: " ${a.name} -> ${a.desc}") aliases;

    aliasAttrs = lib.listToAttrs (
        map (a: {
            name = a.name;
            value = a.cmd;
        }) aliases
    );
in
{
    home.shellAliases = aliasAttrs // {
        a = ''echo -e "${helpText}\n a          -> List aliases"'';
    };
}
