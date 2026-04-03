{ pkgs, ... }:

{

    users.users.jack = {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [
            "wheel"
            "networkmanager"
            "docker"
            "video"
            "render"
        ]; # Enable ‘sudo’ for the user.
        group = "jack";
        packages = with pkgs; [
            cargo
            clang
            clang-tools
        ];
    };

    users.groups.jack = {};
}
