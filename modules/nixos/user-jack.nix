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
            "input"
        ]; # Enable ‘sudo’ for the user.
        group = "jack";
        packages = with pkgs; [
            cargo
            clang
            clang-tools
        ];
    };

    users.groups.jack = {};

    services.udev.extraRules = ''
        KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    '';
}
