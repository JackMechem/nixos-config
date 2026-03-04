{ pkgs, ... }:

{

    users.users.jack = {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [
            "wheel"
            "networkmanager"
            "docker"
        ]; # Enable ‘sudo’ for the user.
        packages = with pkgs; [
            zed-editor
            cargo
            clang
            clang-tools
        ];
    };
}
