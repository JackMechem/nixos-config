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
            name = "tm";
            cmd = ''tmuxinator'';
            desc = "Short for tmuxinator. tm-save saves locally with provided session Other Usage: tm-save <session-name-to-copy>; smae for tm-dup";
        }
        {
            name = "tm-load";
            cmd = "tmuxinator local";
            desc = "Created and opens tmux session from yml file in the current directory. Usage: tm-load";
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

    programs.zsh.initContent = ''
      ZSH_AUTOSUGGEST_USE_ASYNC=false
      fastfetch -c examples/11
      if [[ -n "$IN_NIX_SHELL" ]]; then
        PROMPT="%F{blue}[nix-shell]%f $PROMPT"
      fi
      nix() {
        if [[ "$1" == "develop" ]]; then
          command nix develop -c zsh "''${@:2}"
        else
          command nix "$@"
        fi
      }
      tm-save() {
          tmuxinator new "$1" "$2" --local
      }
      tm-dup() {
          tmuxinator new "$1" "$1" --local
      }
    '';

}
