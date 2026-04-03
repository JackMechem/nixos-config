{
    config,
    pkgs,
    inputs,
    ...
}:

{

    imports = [
        ../../modules/home-manager/zsh.nix
        ../../modules/home-manager/tmux.nix
        ../../modules/home-manager/shell-aliases.nix
        ../../modules/home-manager/neovimpackages.nix
    ];

    programs.home-manager.enable = true;
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = "jack";
    home.homeDirectory = "/home/jack";

    home.stateVersion = "25.05"; # Please read the comment before changing.

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = { };

    nixpkgs = {
        config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
        };
    };

    home.sessionVariables = {
        EDITOR = "nvim";
    };

}
