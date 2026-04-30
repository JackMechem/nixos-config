{ pkgs, inputs, ... }:

{

    programs.firefox.enable = true;
    programs.hyprland.enable = true;

    # List packages installed in system profile.
    environment.systemPackages = with pkgs; [
        #    neovim
        tree
        vim # Both vim and neovim just in case
        wget
        git
        gcc
        fastfetch
        brightnessctl
        killall
        unzip
        python3
        nodejs
        input-remapper
        kdePackages.polkit-kde-agent-1
        yubikey-manager
        yubioath-flutter
    ];

    services.udev.packages = [ pkgs.yubikey-personalization ];
    services.pcscd.enable = true;
    programs.ssh.startAgent = true;
}
