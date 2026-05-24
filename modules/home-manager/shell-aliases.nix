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
        {
            name = "sign-file";
            cmd = "ssh-keygen -Y sign -f ~/.ssh/sign/yk-5c-nfc/id_ed25519_sk_SSH_SIGN_YUBIKEY_5C_NFC -n file";
            desc = "Sign provided file with SSH-ED25519-SK key. Takes in one argument: sign-file document.pdf)";
        }
        {
            name = "tm-save";
            cmd = "TMUXINATOR_CONFIG=. tmuxinator new";
            desc = "Usage: tm-save <save-name> <session-name-to-copy>";
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
